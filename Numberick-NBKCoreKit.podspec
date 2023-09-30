#=-----------------------------------------------------------------------------=
# This source file is part of the Numberick open source project.
#
# Copyright (c) 2023 Oscar Byström Ericsson
# Licensed under Apache License, Version 2.0
#
# See http://www.apache.org/licenses/LICENSE-2.0 for license information.
#=-----------------------------------------------------------------------------=

#*=============================================================================*
# MARK: * NBK x Core Kit
#*=============================================================================*

Pod::Spec.new do |spec|
    spec.version = "0.13.0"
    spec.module_name = "NBKCoreKit"
    spec.name = "Numberick-#{spec.module_name}"
    spec.summary = "A new protocol hierarchy that refines Swift's standard library."
    
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
        test_spec.source_files = "Tests/#{spec.module_name}Tests/**/*.swift"
        test_spec.platforms = { :ios => "14.0", :osx => "11.0", :tvos => "14.0" }
    end
end
