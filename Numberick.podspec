#=-----------------------------------------------------------------------------=
# This source file is part of the Numberick open source project.
#
# Copyright (c) 2023 Oscar Byström Ericsson
# Licensed under Apache License, Version 2.0
#
# See http://www.apache.org/licenses/LICENSE-2.0 for license information.
#=-----------------------------------------------------------------------------=

#*=============================================================================*
# MARK: * NBK
#*=============================================================================*

Pod::Spec.new do |spec|
    spec.version = "0.16.0"
    spec.module_name = "Numberick"
    spec.name = "Numberick"
    spec.summary = "✨ An arithmagick overhaul in Swift."
    
    spec.license = { :type => "Apache-2.0", :file => "LICENSE" }
    spec.author  = { "Oscar Byström Ericsson" => "oscbyspro@protonmail.com" }
    
    spec.homepage = "https://github.com/oscbyspro/Numberick"
    spec.readme = "https://raw.githubusercontent.com/oscbyspro/Numberick/v#{spec.version}/README.md"
    spec.documentation_url = "https://oscbyspro.github.io/Numberick/documentation/numberick/"
    
    spec.source = { :git => "https://github.com/oscbyspro/Numberick.git", :tag => "CocoaPods-v#{spec.version}" }
    spec.source_files = "Sources/#{spec.module_name}/**/*.swift"
    
    #=-------------------------------------------------------------------------=
    # MARK: Requirements
    #=-------------------------------------------------------------------------=
    
    spec.swift_version = "5.7"
    spec.platforms = { :ios => "14.0", :osx => "11.0", :tvos => "14.0", :watchos => "7.0" }
    
    #=-------------------------------------------------------------------------=
    # MARK: Tests
    #=-------------------------------------------------------------------------=
    
    spec.test_spec "Tests" do |test_spec|
        test_spec.source_files = "Tests/*Tests/**/*.swift"
        test_spec.platforms = { :ios => "14.0", :osx => "11.0", :tvos => "14.0" }
    end
    
    #=-------------------------------------------------------------------------=
    # MARK: Dependencies
    #=-------------------------------------------------------------------------=
    
    spec.dependency "Numberick-NBKCoreKit", "#{spec.version}"
    spec.dependency "Numberick-NBKDoubleWidthKit", "#{spec.version}"
end
