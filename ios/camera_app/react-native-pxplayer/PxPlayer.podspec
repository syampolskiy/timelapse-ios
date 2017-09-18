require 'json'
version = JSON.parse(File.read('package.json'))["version"]

Pod::Spec.new do |s|

  s.name            = "PxPlayer"
  s.version         = version
  s.homepage        = "https://github.com/xiongchuan86/react-native-pxplayer"
  s.summary         = "A <PxPlayer /> component for react-native"
  s.license         = "MIT"
  s.author          = { "123" => "123@gmail.com" }
  s.platform        = :ios, "7.0"
  s.source          = { :git => "https://github.com/xiongchuan86/react-native-pxplayer.git", :tag => "#{s.version}" }
  s.source_files    = 'PxPlayer/*.{h,m}'
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/../camera_app/ffmpeg/include"', 'LIBRARY_SEARCH_PATHS' => '"${PODS_ROOT}/../camera_app/ffmpeg/lib"' }
  s.preserve_paths  = "**/*.js"
  s.libraries = "avcodec", "avformat", "avdevice", "avfilter", "avutil", "swscale", "swresample", "z", "bz2", "iconv"
  s.frameworks = "VideoToolbox"

  s.dependency 'React'

end
