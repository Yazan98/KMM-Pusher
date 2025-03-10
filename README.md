## Fastlane Plugin: KMM Pusher 🚀

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-kmm_pusher)

A Fastlane plugin to streamline the build, distribution, and notification process for Kotlin Multiplatform (KMM) projects. This plugin integrates seamlessly with Fastlane to automate your KMM workflows and keep your team informed via Slack.

## Description

This project built to automate builds for Kotlin Multiplatform Mobile Libraries when your app has an external KMM Library that you need to build and push the builds via slack

## Features ✨
1. Build KMM Projects: Automate the build process for Kotlin Multiplatform projects.
2. Upload Files to Slack: Easily upload build artifacts (.aar, .zip, .xcframework) to Slack channels.
3. Notify Teams: Send build status updates and notifications to Slack channels.
4. Customizable: Configure the plugin to suit your project's needs.


## Installation

The Following installation on KMM Library on Fastlane files
1. Gemfile
```
gem 'fastlane-plugin-kmm_pusher', '1.0.1'
gem 'rubyzip'
gem 'fastlane'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
```

2. Fastfile
```
default_platform(:android)

platform :android do
  desc "Generate Build"
  lane :generateBuild do
    kmm_pusher(
        project_name: "Module Name",
        service_type: "slack",
        commit_message: "New Build Version",
        slack_channel: "Channel ID",
        slack_app_token: "Token",
        is_xc_framework_enabled: true,
        is_commit_enabled: true
      )
  end

end
```

## Params Description

| Param Name          | Key    | Description                                                                                             |
|---------------------|--------|---------------------------------------------------------------------------------------------------------|
| Module Name         | project_name | The Module that you Build for (Most of the Time called shared)                                          |
| Feature Type        | service_type | Send Service on supported Types (slack)                                                                 |
| Builds Message      | commit_message | The message sent on the Channel once Build Finished                                                     |
| Slack Channel Id    | slack_channel | The Channel Id that you need to send builds on not the Channel Name                                     |
| Slack Token         | slack_app_token | Create Slack App and Invite it to Channel and Add its token with Scopes (Send Messages and Write Files) |
| IOS Cocopods Builds | is_xc_framework_enabled | Boolean to Generate XCFramework file for Cocopods Projects                                              |                                             |
| Git Access          | is_commit_enabled | After Generating the Builds Push them to Git or Not |                                                    |                                             |

## Build Note

Due to the limitation of Ruby Integration in fastlane and Ruby Slack Client any KMM Library should include <strong>pusher.js</strong> file in the root of the project to be able to use push features from Javascript until Fastlane push the new update version to support Faraday Dependency
also Need to execute the Following command
```
npm install @slack/web-api
```

## Development Commands
Release Builds
```
Push Command
rake install
rake build
sudo gem push pkg/fastlane-plugin-kmm_pusher-1.0.0.gem
```

## Local Include

1. For Apps That need to Include Local Builds Install the Latest Package from the pkg directory
2. Then Execute the Following Commands

```
gem build fastlane-plugin-kmm_pusher.gemspec   
gem install ./fastlane-plugin-kmm_pusher-0.0.14.gem  
```

## License 📄
This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgments 🙏

1. Fastlane: For providing an amazing automation toolset.
2. Slack: For their API and support for integrations.
3. Kotlin Multiplatform: For making cross-platform development a breeze.

## Get Started Today! 🚀
Automate your KMM workflows and keep your team informed with Fastlane Plugin: KMM Pusher. Install it now and take your build process to the next level!
