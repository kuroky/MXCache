
Pod::Spec.new do |s|

  s.name         = "MXCache"
  s.version      = "1.0.1"
  s.summary      = "基于YYCache的缓存轻量封装"

  s.description  = <<-DESC
                    1.内存缓存的管理
                    2.磁盘缓存的管理
                   DESC

  s.homepage     = "https://github.com/kuroky/MXCache.git"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "kurokyfan" => "kuro2007cumt@gmail.com" }

  s.platform     = :ios, "11.0"

  s.source       = { :git => "https://github.com/kuroky/MXCache.git", :tag => "#{s.version}" }


  s.source_files  = "MXCache/*.{h,m}"

  # s.public_header_files = "MXCache/*.h"


  s.requires_arc = true

  s.dependency "YYCache", "~> 1.0.4"

end
