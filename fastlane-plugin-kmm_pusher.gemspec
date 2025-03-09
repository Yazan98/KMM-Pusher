lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/kmm_pusher/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-kmm_pusher'
  spec.version       = Fastlane::KmmPusher::VERSION
  spec.author        = 'Yazan Tarifi'
  spec.email         = 'yazantarifi989@gmail.com'

  spec.summary       = 'Kotlin Multiplatform Mobile Plugin to Collect Android and IOS Builds to Push them on (Slack, Discord, Telegram)'
  # spec.homepage      = "https://github.com/<GITHUB_USERNAME>/fastlane-plugin-kmm_pusher"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 2.6'

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  # spec.add_dependency 'your-dependency', '~> 1.0.0'
end
