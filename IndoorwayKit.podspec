Pod::Spec.new do |s|
  s.name              = 'IndoorwayKit'
  s.version           = '1.4.7'
  s.cocoapods_version = '>= 1.0.0'
  s.summary           = 'IndoorwayKit - find yourself indoors.'
  s.homepage          = 'https://indoorway.com'
  s.social_media_url  = 'https://twitter.com/indoorway'
  s.description       = <<-DESC
                        Indoorway lets you find your way indoors. Check it out!
                        DESC

  s.license = {
    :type => 'Custom',
    :file => 'LICENSE'
  }

  s.authors = {
    'Indoorway' => 'contact@indoorway.com'
  }
  
  s.source = {
    :git => 'https://github.com/indoorway/SDKforiOS.git',
    :tag => s.version.to_s
  }

  s.platform              = :ios
  s.ios.deployment_target = '10.0'

  s.ios.vendored_frameworks = 'IndoorwayKit/IndoorwayKit.framework'
  s.frameworks              = 'CoreMotion', 'CoreBluetooth', 'Security', 'UIKit', 'CoreGraphics', 'CoreLocation'
  
  s.pod_target_xcconfig = {
    'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/Headers/IndoorwayKit"',
    'ENABLE_BITCODE' => 'NO'
  }

  s.dependency 'SwiftyJSON',    '~> 3.1.4'
  s.dependency 'Alamofire',     '~> 4.5.1'
  s.dependency 'AWSSQS',        '~> 2.6.1'
  
  s.requires_arc = true
  
  #  Configuration for CommonCrypto to work properly
  s.xcconfig = { 
    'HEADER_SEARCH_PATHS' => '"$(PODS_ROOT)/IndoorwayKit/IndoorwayKit/IndoorwayKit.framework/CommonCrypto"'
  }
  s.preserve_paths = 'IndoorwayKit/IndoorwayKit.framework/CommonCrypto/module.modulemap'

end
