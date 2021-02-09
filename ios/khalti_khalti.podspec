#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint khalti_khalti.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'khalti_khalti'
  s.version          = '0.0.1'
  s.summary          = 'Flutter khalti plugin'
  s.description      = <<-DESC
Flutter khalti plugin
                       DESC
  s.homepage         = 'http://codeforcore.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Codeforcore' => 'raj@codeforcore.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Khalti'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
