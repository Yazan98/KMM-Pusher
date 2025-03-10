require 'fastlane_core/ui/ui'
require 'zip'
require 'net/http'
require 'uri'
require 'json'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class KmmPusherHelper
      def self.start_plugin(
        project_name,
        service_type,
        is_xc_framework_enabled,
        is_commit_enabled,
        commit_message,
        slack_channel,
        slack_app_token
      )

        # Pre Check Plugin Params before Start the Plugin
        raise PluginMissingParamsException, print_error_message("project_name is required in configuration!") if project_name.nil? || project_name.empty?
        raise PluginMissingParamsException, print_error_message("service_type is required in configuration!") if service_type.nil? || service_type.empty?

        # Pre Check on Slack Configurations if Service Type is Slack
        if service_type == "slack"
          raise PluginMissingParamsException, print_error_message("slack_channel is required in configuration!") if slack_channel.nil? || slack_channel.empty?
          raise PluginMissingParamsException, print_error_message("slack_app_token is required in configuration!") if slack_app_token.nil? || slack_app_token.empty?
        end

        if service_type == "slack"
          send_slack_message(
            "Pusher Triggered new Build with Number (#{get_git_reference})",
            slack_app_token,
            slack_channel
          )
        end

        # Print Plugin Params Start
        print_log_message("KMM Pusher Started with Project #{project_name} and Service Type #{service_type}")

        # 1. Remove Prev Build for Android and IOS
        delete_prev_builds(project_name)

        # 2. Start Building the Library By Project Module
        build_library_module(project_name, is_xc_framework_enabled)

        # 3. Find Build Paths
        move_builds_to_root_path(project_name)

        # 4. Compress Files to Zip Files
        if is_xc_framework_enabled
          compress_files(project_name, "xcframework")
        else
          compress_files(project_name, "framework")
        end

        # 5. Check if the Git Commits Enabled after Build Push the Builds to Repository
        if is_commit_enabled
          push_build(commit_message)
        end

        # 6. Push the Builds to Service
        if service_type == "slack"
          push_slack_build(slack_channel, project_name, is_xc_framework_enabled, slack_app_token)
        end

      end

      def self.send_slack_message(message, token, channel_id)
        # Slack API endpoint for posting messages
        uri = URI.parse("https://slack.com/api/chat.postMessage")

        # Create the HTTP request
        request = Net::HTTP::Post.new(uri)
        request.content_type = "application/json; charset=utf-8"
        request["Authorization"] = "Bearer #{token}"

        # Prepare the request body
        body = {
          channel: channel_id,
          text: message
        }
        request.body = body.to_json

        # Send the request
        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(request)
        end

        # Parse the response
        if response.is_a?(Net::HTTPSuccess)
          puts "Message sent successfully!"
          puts JSON.parse(response.body)
        else
          puts "Failed to send message: #{response.body}"
        end
      end

      def self.push_slack_build(slack_channel, project_name, is_xc_framework_enabled, token)
        if is_xc_framework_enabled
          upload_file_to_slack(
            "#{get_current_working_directory}/#{project_name}.xcframework.zip",
            slack_channel,
            "A new Build Pushed for IOS Client with XCFramework",
            token
          )
        else
          upload_file_to_slack(
            "#{get_current_working_directory}/#{project_name}.framework.zip",
            slack_channel,
            "A new Build Pushed for IOS Client with Framework",
            token
          )
        end

        upload_file_to_slack(
          "#{get_current_working_directory}/#{project_name}-debug.aar",
          slack_channel,
          "A new Build Pushed for Android Client with Framework",
          token
        )
      end

      def self.get_current_working_directory
        Dir.pwd
      end

      def self.upload_file_to_slack(file_path, channel, initial_comment = nil, slack_token)
        Actions.sh("node pusher.js #{file_path} \"#{channel}\" \"#{initial_comment}\" #{slack_token}")
      end

      def self.compress_files(project_name, extention)
        # Define the file to compress
        file_to_compress = "#{project_name}.#{extention}"
        zip_file = "#{file_to_compress}.zip"

        # Create the ZIP file
        Zip::File.open(zip_file, Zip::File::CREATE) do |zip|
          if File.directory?(file_to_compress)
            # Add all files in the directory recursively
            Dir["#{file_to_compress}/**/**"].each do |file|
              zip.add(file.sub("#{file_to_compress}/", ""), file)
            end
          else
            # Add a single file
            zip.add(File.basename(file_to_compress), file_to_compress)
          end
        end

        print_log_message("Successfully created #{zip_file}")
      end

      def self.push_build(commit_message)
        Actions.sh("git add .")
        Actions.sh("git commit -m \"#{commit_message}\" ")

        current_branch = get_git_reference
        Actions.sh("git push origin #{current_branch}")
      end

      def self.get_git_reference
        # Try to get the first tag name
        first_tag = `git describe --tags --abbrev=0 2>&1`.strip

        if $?.success?
          first_tag
        else
          # Fall back to the current branch name
          current_branch = `git rev-parse --abbrev-ref HEAD 2>&1`.strip
          current_branch
        end
      end

      def self.move_builds_to_root_path(project_name)
        print_log_message("Start Moving Builds from Build Folder to Root Folder")

        directory = Actions.sh("pwd").delete(" \t\r\n")
        iosSourceDirectory = directory + "/#{project_name}/build/XCFrameworks/release/#{project_name}.xcframework"
        androidBuildDirectory = directory + "/#{project_name}/build/outputs/aar/#{project_name}-debug.aar"

        print_log_message("Current Working Directory : #{directory}")
        print_log_message("IOS Working Directory : #{iosSourceDirectory}")
        print_log_message("Android Working Directory : #{androidBuildDirectory}")

        Actions.sh("mv " + iosSourceDirectory + " " + directory + "/#{project_name}.xcframework")
        Actions.sh("mv " + androidBuildDirectory + " " + directory + "/#{project_name}-debug.aar")
      end

      def self.build_library_module(project_name, is_xc_framework_enabled)
        Actions.sh("./gradlew #{project_name}:clean")
        Actions.sh("./gradlew #{project_name}:assemble")
        if is_xc_framework_enabled
          Actions.sh("./gradlew #{project_name}:assembleXCFramework")
        end
      end

      def self.delete_prev_builds(project_name)
        begin
          Actions.sh("rm ./#{project_name}-debug.aar")
        rescue Exception
          # Ignored if Not Exists
        end

        begin
          Actions.sh("rm -rf ./#{project_name}.framework")
        rescue Exception
          # Ignored if Not Exists
        end

        begin
          Actions.sh("rm -rf ./#{project_name}.xcframework")
        rescue Exception
          # Ignored if Not Exists
        end

        begin
          Actions.sh("rm -rf ./#{project_name}.framework.zip")
        rescue Exception
          # Ignored if Not Exists
        end

        begin
          Actions.sh("rm -rf ./#{project_name}.xcframework.zip")
        rescue Exception
          # Ignored if Not Exists
        end
      end

      def self.print_log_message(message)
        puts " ---------------------------------------- "
        puts " -------------- #{message} -------------- "
        puts " ---------------------------------------- "
      end

      def self.print_error_message(message)
        "\e[31m ------ [#{message}] ------ \e[0m"
      end

      def self.show_message
        UI.message("Kotlin Pusher Plugin Started Message")
      end
    end
  end
end

class PluginMissingParamsException < StandardError
end