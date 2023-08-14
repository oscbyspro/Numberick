Pod::Spec.new do |s|
    s.name             = 'Numberick-CoreKit'
    s.version          = '999.99.9'
    s.summary          = "A new protocol hierarchy that refines Swift's standard integer library."
  
    s.description      = <<-DESC
    A new protocol hierarchy that refines Swift's standard library. Core part of Numberick.
                         DESC
  
    s.homepage         = 'https://github.com/oscbyspro/Numberick'
  
    s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
    s.author           = { 'Oscar Byström Ericsson' => 'oscbyspro@protonmail.com' }
    s.source           = { :git => 'https://github.com/oscbyspro/Numberick.git', :tag => "v#{s.version}" }
  
    base_platforms     = { :ios => '14.0', :osx => '11.0', :tvos => '14.0' }

    s.platforms        = base_platforms.merge({ :watchos => '7.0' })

    s.module_name      = 'NBKCoreKit'
    
    s.swift_version    = '5.7'
    
    s.source_files     = 'Sources/NBKCoreKit/**/*.swift'

    swift_custom_flags = ''
    
    if ENV['SWIFT_FEATURE_StaticBigInt'] == 'true'
        base_platforms     = { :ios => '16.4', :osx => '13.3', :tvos => '16.4' }
        s.platforms        = base_platforms.merge({ :watchos => '9.4' })
        s.swift_version    = '5.8'
        swift_custom_flags += 'SBI '
    end

    s.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => swift_custom_flags }
    
    s.test_spec 'Tests' do |ts|
        ts.platforms = base_platforms
        ts.source_files = 'Tests/NBKCoreKitTests/**/*.swift'
    end

    s.test_spec 'Benchmarks' do |ts|
        ts.platforms = base_platforms
        ts.source_files = 'Tests/NBKCoreKitBenchmarks/**/*.swift'
    end
end