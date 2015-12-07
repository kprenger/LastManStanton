source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Alamofire', '~> 3.0'
pod 'ObjectMapper', '~> 1.0'
pod 'AlamofireObjectMapper', '~> 2.0'
pod 'FuzzySearch', '1.1.0'

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-Acknowledgements.plist', 'LastManStanton/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
