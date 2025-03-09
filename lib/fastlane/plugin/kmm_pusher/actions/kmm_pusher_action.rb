require 'fastlane/action'
require_relative '../helper/kmm_pusher_helper'

module Fastlane
  module Actions
    class KmmPusherAction < Action
      def self.run(params)
        UI.message("The kmm_pusher plugin is working!")
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
        # Optional:
        "Build Kotlin Multiplatform Mobile Library Projects and Generate Builds to Push them on Slack, Discord, Telegram Channels to be able to Track All KMM Library Builds"
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "KMM_PUSHER_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
