Pod::Spec.new do |s|
  s.name              = 'IndoorwayKit'
  s.version           = '1.0.0'
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
    'Michal Dabrowski' => 'michal.dabrowski@daftcode.pl',
    'Robert Sobolewski' => 'robert.sobolewski@daftcode.pl'
  }
  
  s.source = {
    :git => 'https://github.com/indoorway/IndoorwayKit.git',
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

  s.dependency 'SwiftyJSON'
  s.dependency 'HanekeSwift'
  s.dependency 'Alamofire', '~> 4.0'
  s.dependency 'CryptoSwift'
  s.dependency 'AWSSQS'
  
  s.requires_arc = true
end

