## Fastlane Plugin: KMM Pusher 🚀

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-kmm_pusher)

A Fastlane plugin designed to streamline the build, distribution, and notification process for Kotlin Multiplatform Mobile (KMM) projects. This plugin integrates seamlessly with Fastlane to automate your KMM workflows, ensuring your team stays informed via Slack notifications.

<img width="661" alt="Screenshot 2025-03-10 at 10 16 04 PM" src="https://github.com/user-attachments/assets/2523eeda-185a-4a16-be76-ad86515c454e" />


## Description

This plugin is built to automate the build and distribution process for Kotlin Multiplatform Mobile (KMM) libraries, particularly when your app relies on an external KMM library. It simplifies the process of building, uploading artifacts, and notifying your team via Slack, making your development workflow more efficient.

## Features ✨
1. Build KMM Projects: Automate the build process for Kotlin Multiplatform projects with ease.
2. Upload Files to Slack: Effortlessly upload build artifacts (e.g., .aar, .zip, .xcframework) to designated Slack channels.
3. Notify Teams: Send real-time build status updates and notifications to your team via Slack.
4. Customizable: Tailor the plugin to fit your project's specific requirements with flexible configuration options.


## Installation

To integrate the KMM Pusher plugin into your Fastlane setup, follow these steps:

1. Update Your Gemfile
Add the following lines to your Gemfile:
```
gem 'fastlane-plugin-kmm_pusher', '1.0.1'
gem 'rubyzip'
gem 'fastlane'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
```

2. Configure Your Fastfile
In your Fastfile, define a lane to generate builds using the kmm_pusher plugin:

```
default_platform(:android)

platform :android do
  desc "Generate Build"
  lane :generateBuild do
    kmm_pusher(
      project_name: "Module Name",          # Name of the module to build (usually "shared")
      service_type: "slack",                # Service type (currently supports Slack)
      commit_message: "New Build Version",  # Message to send to Slack upon build completion
      slack_channel: "Channel ID",          # Slack channel ID (not the name)
      slack_app_token: "Token",             # Slack app token with required permissions
      is_xc_framework_enabled: true,        # Enable XCFramework generation for CocoaPods
      is_commit_enabled: true               # Push builds to Git after generation
    )
  end
end
```

## Params Description

| Param Name          | Key    | Description                                                                                             |
|---------------------|--------|---------------------------------------------------------------------------------------------------------|
| Module Name         | project_name | The name of the module to build (typically "shared").                                          |
| Feature Type        | service_type | The service type for notifications (currently only supports Slack).                                                     |
| Builds Message      | commit_message | The message sent to the Slack channel once the build is complete.                                          |
| Slack Channel Id    | slack_channel | The ID of the Slack channel where notifications and files will be sent (not the channel name).                                |
| Slack Token         | slack_app_token | The Slack app token with the necessary permissions (e.g., sending messages and uploading files). |
| IOS Cocopods Builds | is_xc_framework_enabled | A boolean to enable or disable XCFramework generation for CocoaPods projects.                                             |                                             |
| Git Access          | is_commit_enabled | A boolean to determine whether to push the generated builds to Git. |                                                    |                                             |

## Build Note

Due to limitations in Ruby integration within Fastlane and the Ruby Slack client, any KMM library using this plugin must include a pusher.js file in the project's root directory. This file enables push features via JavaScript until Fastlane updates its support for the Faraday dependency. Additionally, ensure you run the following command to install the required Slack dependencies:

```
npm install @slack/web-api
```

## Development Commands
To release new versions of the plugin, use the following commands:

```
Push Command
rake install
rake build
sudo gem push pkg/fastlane-plugin-kmm_pusher-1.0.0.gem
```

## Local Include
For apps that need to include local builds, follow these steps:

1. Install the latest package from the pkg directory.
2. Execute the following commands:

```
gem build fastlane-plugin-kmm_pusher.gemspec   
gem install ./fastlane-plugin-kmm_pusher-0.0.14.gem  
```

To Execute the Builds from Local mapping Buile in the Clients execute the Following Command
```
    bundle exec fastlane 
```

## License 📄
This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgments 🙏

1. Fastlane: For providing an amazing automation toolset.
2. Slack: For their API and support for integrations.
3. Kotlin Multiplatform: For making cross-platform development a breeze.

## Get Started Today! 🚀
Automate your KMM workflows and keep your team informed with Fastlane Plugin: KMM Pusher. Install it now and take your build process to the next level!
