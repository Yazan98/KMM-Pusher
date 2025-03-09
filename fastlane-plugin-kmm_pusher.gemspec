lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/kmm_pusher/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-kmm_pusher'
  spec.version       = Fastlane::KmmPusher::VERSION
  spec.author        = 'Yazan Tarifi'
  spec.email         = 'yazantarifi989@gmail.com'

  spec.summary       = 'Kotlin Multiplatform Mobile Plugin to Collect Android and IOS Builds to Push them on Slack'
  spec.homepage      = "https://github.com/Yazan98/KMM-Pusher"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']
end
