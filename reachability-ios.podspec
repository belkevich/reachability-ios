Pod::Spec.new do |s|
  s.name         = "reachability-ios"
  s.version      = "1.0.0"
  s.summary      = "Wrapper for SCNetworkReachability methods of SystemConfiguration.framework"
  s.homepage     = "https://github.com/belkevich/reachability-ios"
  s.license      = 'MIT'
  s.author       = { "Alexey Belkevich" => "belkevich.alexey@gmail.com" }
  s.source       = { :git => "https://github.com/belkevich/reachability-ios.git",
		     :tag => "1.0.0"}
  s.platform     = :ios
  s.source_files = '{h,m}'
  s.framework  = 'SystemConfiguration.framework'
end