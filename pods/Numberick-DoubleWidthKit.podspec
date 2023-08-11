Pod::Spec.new do |s|
    s.name             = 'Numberick-DoubleWidthKit'
    s.version          = '999.99.9'
    s.summary          = "Generic software model for working with fixed-width integers larger than one machine word"
  
    s.description      = <<-DESC
    NBKDoubleWidth is a generic software model for working with fixed-width integers larger than one machine word.
    Its bit width is double the bit width of its High component. Main part of Numberick.
                         DESC
  
    s.homepage         = 'https://github.com/oscbyspro/Numberick'
  
    s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
    s.author           = { 'Oscar Byström Ericsson' => 'oscbyspro@protonmail.com' }
    s.source           = { :git => 'https://github.com/oscbyspro/Numberick.git', :tag => "v#{s.version}" }
  
    base_platforms = { :ios => '14.0', :osx => '11.0', :tvos => '14.0' }

    s.platforms = base_platforms.merge({ :watchos => '7.0' })

    s.module_name = 'NBKDoubleWidthKit'
    
    s.swift_version = '5.7'
    
    s.source_files = 'Sources/NBKDoubleWidthKit/**/*.swift'

    s.dependency 'Numberick-CoreKit', "#{s.version}"
    
    s.test_spec 'Tests' do |ts|
        ts.platforms = base_platforms
        ts.source_files = 'Tests/NBKDoubleWidthKitTests/**/*.swift'
    end

    s.test_spec 'Benchmarks' do |ts|
        ts.platforms = base_platforms
        ts.source_files = 'Tests/NBKDoubleWidthKitBenchmarks/**/*.swift'
    end
end