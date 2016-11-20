

Pod::Spec.new do |s|
s.name         = "SJLocation"
s.version      = "1.0"
s.summary      = "The easiest way to user location."
s.homepage     = "https://github.com/zhoushejun/SJLocation"
s.license      = "MIT"
s.author       = { "shejunzhou" => "965678322@qq.com" }
s.platform     = :ios, "7.0"
s.source       = { :git => "https://github.com/zhoushejun/SJLocation.git", :tag => s.version }
s.source_files = "Vendor/SJLocation/*.{h,m}"
s.resource     = "SJLocation/Assets.xcassets"
s.requires_arc = true
end
