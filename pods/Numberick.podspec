Pod::Spec.new do |s|
    s.name             = 'Numberick'
    s.version          = '999.99.9'
    s.summary          = "A composable, large, fixed-width, two's complement, binary integer."
  
    s.description      = <<-DESC
    A generic software model for working with fixed-width integers larger than one machine word.
    Main package.
                         DESC
  
    s.homepage         = 'https://github.com/oscbyspro/Numberick'
  
    s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
    s.author           = { 'Oscar Byström Ericsson' => 'oscbyspro@protonmail.com' }
    s.source           = { :git => 'https://github.com/oscbyspro/Numberick.git', :tag => "v#{s.version}" }

    s.platforms        = { :ios => '14.0', :osx => '11.0', :tvos => '14.0', :watchos => '7.0' }

    s.swift_version    = '5.7'

    s.source_files     = 'Sources/Numberick/**/*.swift'

    swift_custom_flags = ''

    if ENV['SWIFT_FEATURE_StaticBigInt'] == 'true'
        s.platforms     = { :ios => '16.4', :osx => '13.3', :tvos => '16.4', :watchos => '9.4' }
        s.swift_version = '5.8'
        swift_custom_flags += 'SBI '
    end

    s.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => swift_custom_flags }
    
    s.dependency 'Numberick-CoreKit', "#{s.version}"
    s.dependency 'Numberick-DoubleWidthKit', "#{s.version}"
end