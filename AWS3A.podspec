Pod::Spec.new do |s|
  s.name                      = "AWS3A"
  s.version                   = "1.0.2"
  s.summary                   = "AWS3A"
  s.homepage                  = "https://github.com/MarkEvans/AWS3A"
  s.license                   = { :type => "MIT", :file => "LICENSE" }
  s.author                    = { "Mark Evans" => "mevansjr@gmail.com" }
  s.source                    = { :git => "https://github.com/MarkEvans/AWS3A.git", :tag => s.version.to_s }
  s.ios.deployment_target     = "8.0"
  s.tvos.deployment_target    = "9.0"
  s.watchos.deployment_target = "2.0"
  s.osx.deployment_target     = "10.10"
  s.source_files              = "Sources/**/*"
  s.ios.frameworks            = "Foundation", "UIKit", "Dispatch", "CommonCrypto"
end
