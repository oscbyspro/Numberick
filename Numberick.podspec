Pod::Spec.new do |s|
  s.name             = 'Numberick'
  s.version          = '0.8.0'
  s.summary          = 'A composable, large, fixed-width, two's complement, binary integer.'

  s.description      = <<-DESC
  A generic software model for working with fixed-width integers larger 
  than one machine word. Its bit width is double the bit width of its High component.
                       DESC

  s.homepage         = 'https://github.com/oscbyspro/Numberick'

  s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author           = { 'Oscar Byström Ericsson' => 'oscbyspro@protonmail.com' }
  s.source           = { :git => 'https://github.com/oscbyspro/Numberick.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.tvos.deployment_target = '13.0'
  s.watchos.deployment_target = '6.0'
  
  s.swift_version = '5.8'
  
  s.source_files = 'Sources/NBKCoreKit/**/*.swift', 'Sources/NBKDoubleWidthKit/*.swift'
  
  s.test_spec 'Tests' do |test_spec|
    test_spec.platforms = {:ios => '13.0', :osx => '10.15', :tvos => '13.0'}
    test_spec.source_files = 'Tests/NBKCoreKitTests/**/*.swift', 'Tests/NBKDoubleWidthKitTests/*.swift'
  end
end
