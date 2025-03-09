## Fastlane Plugin: KMM Pusher 🚀

A Fastlane plugin to streamline the build, distribution, and notification process for Kotlin Multiplatform (KMM) projects. This plugin integrates seamlessly with Fastlane to automate your KMM workflows and keep your team informed via Slack.

## Features ✨
1. Build KMM Projects: Automate the build process for Kotlin Multiplatform projects.
2. Upload Files to Slack: Easily upload build artifacts (.aar, .zip, .xcframework) to Slack channels.
3. Notify Teams: Send build status updates and notifications to Slack channels.
4. Customizable: Configure the plugin to suit your project's needs.

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-kmm_pusher)

## Installation

1. Include in gem file
```
    gem 'fastlane-plugin-kmm_pusher', '~> 1.0'
```

2. Install via Fastlane
```
Gemfile
gem 'fastlane-plugin-kmm_pusher', '0.0.20'
gem 'rubyzip'
gem 'fastlane'

Fastfile
default_platform(:android)

platform :android do
  desc "Generate Build"
  lane :generateBuild do
    kmm_pusher(
        project_name: "Module Name",
        service_type: "slack",
        commit_message: "New Build Version",
        slack_channel: "Channel Id",
        slack_app_token: "Token",
        is_xc_framework_enabled: true,
        is_commit_enabled: true
      )
  end

end

```

Commands
```
gem build fastlane-plugin-kmm_pusher.gemspec   
gem install ./fastlane-plugin-kmm_pusher-0.0.14.gem  

Push Command
rake install
rake build
sudo gem push pkg/fastlane-plugin-kmm_pusher-1.0.0.gem
```