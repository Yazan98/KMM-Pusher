require 'fastlane/action'
require_relative '../helper/kmm_pusher_helper'

module Fastlane
  module Actions
    class KmmPusherAction < Action
      def self.run(params)
        UI.message("Fastlane Kotlin Multiplatform Pusher Started ...")

        def isXcFrameworkEnabled = params[:is_xc_framework_enabled]
        def serviceType = params[:service_type]
        def projectName = params[:project_name]
        def is_commit_enabled = params[:is_commit_enabled]
        def commit_message = params[:commit_message]
        def slack_channel = params[:slack_channel]
        def slack_app_token = params[:slack_app_token]

        Helper::KmmPusherHelper.start_plugin(
          projectName,
          serviceType,
          isXcFrameworkEnabled,
          is_commit_enabled,
          commit_message,
          slack_channel,
          slack_app_token
        )
      end

      def self.description
        "Kotlin Multiplatform Mobile Plugin to Collect Android and IOS Builds to Push them on (Slack, Discord, Telegram)"
      end

      def self.authors
        ["Yazan Tarifi"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        "Build Kotlin Multiplatform Mobile Library Projects and Generate Builds to Push them on Slack, Discord, Telegram Channels to be able to Track All KMM Library Builds"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :project_name,
            env_name: "project_name",
            description: "Module Name of the Library that you Generate Builds on",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :is_xc_framework_enabled,
            env_name: "is_xc_framework_enabled",
            description: "Decide which Builds Enabled for XCFramework or Normal Framework",
            optional: false,
            type: Boolean
          ),
          FastlaneCore::ConfigItem.new(
            key: :service_type,
            env_name: "service_type",
            description: "Service Type to Push the Builds on (slack, discord, telegram)",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :is_commit_enabled,
            env_name: "is_commit_enabled",
            description: "Boolean Value to Decide if the Commit after Build enabled or Not",
            optional: true,
            type: Boolean
          ),
          FastlaneCore::ConfigItem.new(
            key: :commit_message,
            env_name: "commit_message",
            description: "Send the Commit Message when Push the Build Results",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :slack_channel,
            env_name: "slack_channel",
            description: "Channel name that KMM Pusher gonna Push the Builds on",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :slack_app_token,
            env_name: "slack_app_token",
            description: "Application Bot Name that KMM Pusher Push the Builds on",
            optional: true,
            type: String
          ),
        ]
      end

      def self.is_supported?(platform)
        [:ios, :android].include?(platform)
        true
      end
    end
  end
end
