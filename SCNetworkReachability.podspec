Pod::Spec.new do |s|
  s.name         = "SCNetworkReachability"
  s.version      = "2.0.6"
  s.summary      = "Flexible network reachability with blocks for iOS and OS X."
  s.homepage     = "https://github.com/belkevich/reachability-ios"
  s.social_media_url = 'https://twitter.com/okolodev'
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author       = { "Alexey Belkevich" => "belkevich.alexey@gmail.com" }
  s.source       = { :git => "https://github.com/belkevich/reachability-ios.git", :tag => s.version.to_s }
  s.framework    = 'SystemConfiguration', 'Foundation'
  s.requires_arc = true
  s.ios.deployment_target = "5.0"
  s.osx.deployment_target = "10.7"

  s.subspec 'Core' do |ss|
    ss.source_files = 'Classes/P*/*.{h,m}'
    ss.dependency 'macros_blocks', '~> 0.0.1'
  end

  s.subspec 'Multithreading' do |ss|
    ss.dependency 'SCNetworkReachability/Core'
    ss.source_files = 'Classes/Subspecs/Multithreading/*.{h,m}'
  end

  s.subspec 'Shared' do |ss|
    ss.dependency 'SCNetworkReachability/Core'
    ss.dependency 'ABMultiton', '~> 2.0'
    ss.source_files = 'Classes/Subspecs/Shared/*.{h,m}'
  end

  s.subspec 'Compatibility' do |ss|
    ss.dependency 'SCNetworkReachability/Core'
    ss.source_files = 'Classes/Subspecs/Compatibility/*.{h,m}'
  end

  s.subspec 'All' do |ss|
    ss.dependency 'SCNetworkReachability/Core'
    ss.dependency 'SCNetworkReachability/Shared'
    ss.dependency 'SCNetworkReachability/Multithreading'
    ss.dependency 'SCNetworkReachability/Compatibility'
  end

  s.default_subspec = 'Core'

end
