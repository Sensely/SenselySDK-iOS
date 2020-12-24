platform :ios, '12.0'

inhibit_all_warnings!

abstract_target 'Samples' do

  workspace 'SenselySamples'
  use_frameworks!
  
  pod 'googleapis', :path => '.', :inhibit_warnings => true
  
  pod 'SenselySDK'

  target 'SwiftSample' do
    project 'SwiftSample/SwiftSample.xcodeproj'
  end

  target 'ObjCSample' do
    project 'ObjCSample/ObjCSample.xcodeproj'
  end

end
