# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

use_frameworks!

target 'KAPU' do
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
    pod 'Firebase/Database'
    pod 'Firebase/Storage'
    pod 'Firebase/Auth'
    pod 'IQKeyboardManagerSwift'
end


post_install do |installer|
installer.pods_project.targets.each do |target|
target.build_configurations.each do |config|
config.build_settings['SWIFT_VERSION'] = '3.0'
end
end
end
