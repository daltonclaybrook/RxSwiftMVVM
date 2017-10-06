platform :ios, '10.0'
use_frameworks!

target 'RxSwiftMVVM' do
  pod 'Moya/RxSwift'
  pod 'SwiftyJSON'
  pod 'RxCocoa'
end

swift_4_pods = ["Moya"]
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if !swift_4_pods.include?(target.name)
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end

