Pod::Spec.new do |s|

  s.name         = "XYWebImage"
  s.version      = "1.0.2"
  s.summary      = "asynchronous load images"
  s.homepage     = "https://github.com/fifyrio/XYWebImage"
  s.license      = { :type => 'MIT' }
  s.author             = { "wuw" => "fifyrio@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/fifyrio/XYWebImage.git", :tag => s.version }
  s.source_files  = "XYWebImage","XYWebImage/**/*.{h,m}"
  s.frameworks   = 'UIKit','Foundation','CoreGraphics','ImageIO'

end
