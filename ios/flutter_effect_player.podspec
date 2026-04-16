require 'yaml'

#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tceffectplayer_flutter.podspec` to validate before publishing.
#

# ── Read sub_spec from host pubspec.yaml ──
sub_spec_version = 'Default'

project_root = ENV['FLUTTER_APPLICATION_PATH']
if project_root.nil? && defined?(Pod::Config)
  podfile_dir = Pod::Config.instance.project_root.to_s
  project_root = File.expand_path('..', podfile_dir)
end

if project_root
  pubspec_path = File.join(project_root, 'pubspec.yaml')
  if File.exist?(pubspec_path)
    begin
      pubspec = YAML.load_file(pubspec_path)
      effect_config = pubspec['EffectPlayer']
      if effect_config && effect_config['sub_spec']
        parsed = effect_config['sub_spec']
        if ['Default', 'NoXMagic'].include?(parsed)
          sub_spec_version = parsed
        else
          puts "[EffectPlayer] Unknown sub_spec '#{parsed}', fallback to 'Default'"
        end
      else
        puts "[EffectPlayer] sub_spec not set, use default: Default"
      end
    rescue => e
      puts "[EffectPlayer] Failed to parse pubspec.yaml: #{e.message}"
    end
  else
    puts "[EffectPlayer] pubspec.yaml not found, use default: Default"
  end
end

puts "[EffectPlayer] subspec: #{sub_spec_version}"
# ──────────────────────────────────────────

Pod::Spec.new do |s|
  s.name             = 'flutter_effect_player'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.default_subspec = sub_spec_version

  s.subspec 'Default' do |ss|
    ss.dependency 'TCMediaX'
    ss.dependency 'TCEffectPlayer'
    ss.dependency 'YTCommonXMagic'
  end

  s.subspec 'NoXMagic' do |ss|
    ss.dependency 'TCMediaX'
    ss.dependency 'TCEffectPlayer'
  end

  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.static_framework = true

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'tceffectplayer_flutter_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
