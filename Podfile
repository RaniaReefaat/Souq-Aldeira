# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'

target 'Najat' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Najat

 pod 'SDWebImage'
  pod 'NVActivityIndicatorView'
  pod 'IQKeyboardManagerSwift'
  pod 'Cosmos'
#  pod 'GoogleMaps'
  
  pod "ImageSlideshow/Alamofire"
  pod "ImageSlideshow"
    
  pod 'YPImagePicker'
  pod 'Firebase'
  pod 'FirebaseMessaging'
  pod 'SwiftyGif'
  pod 'JBDatePicker', :git => 'https://github.com/myfitnesspal/JBDatePicker.git'
  
  pod 'Firebase/Core'
  pod 'Firebase/Firestore'
  pod 'AlamofireEasyLogger'
  pod 'GoogleMaps'
  pod 'GooglePlaces'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        xcconfig_path = config.base_configuration_reference.real_path
        xcconfig = File.read(xcconfig_path)
        xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
        File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
      end
      if target.name == 'BoringSSL-GRPC'
        target.source_build_phase.files.each do |file|
          if file.settings && file.settings['COMPILER_FLAGS']
            flags = file.settings['COMPILER_FLAGS'].split
            flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
            file.settings['COMPILER_FLAGS'] = flags.join(' ')
          end
        end
      end
    end
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
      end
    end
  end
end

