Pod::Spec.new do |s|
  s.name         = "SwiftInterview"
  s.version      = "1.1.0"
  s.summary      = "A cocoapod for interviews and new projects with generally helpful helpers"
  s.description  = "A cocoapod for interviews and new projects with generally helpful helpers.  "
  s.homepage     = "https://github.com/ElevatedUnderdogs/SwiftInterview"
  
  s.license      = "Private implementation, public interface"
  s.author       = { "Scott Lydon" => "email_private" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/ElevatedUnderdogs/SwiftInterview.git", :tag => s.version.to_s }
  s.source_files =  "Classes/**/*.swift"
  s.requires_arc = true
  s.swift_version= '5.0'
  s.xcconfig     = { 'SWIFT_VERSION' => '5.0' }
#  s.dependency "APodYourPodDependsOn"
end
