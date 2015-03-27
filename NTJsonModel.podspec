Pod::Spec.new do |s|
  s.name                = "NTJsonModel"
  s.version             = "1.00"
  s.summary             = "model objects for JSON objects using a declarative approach for defining properties. Supports immutable (and mutable) model objects"
  s.homepage            = "https://github.com/NagelTech/NTJsonModel"
  s.license             = { :type => 'MIT', :file => 'LICENSE' }
  s.author              = { "Ethan Nagel" => "eanagel@gmail.com" }
  s.platform            = :ios, '6.0'
s.source              = { :git => "https://github.com/NagelTech/NTJsonModel.git", :tag => s.version.to_s }
  s.requires_arc        = true

  s.source_files        = 'classes/ios/*.{h,m}'
  s.public_header_files = 'classes/ios/NTJsonModel.h',
                          'classes/ios/NTJsonPropertyInfo.h',
                          'classes/ios/NTJsonPropertyConversion.h',
                          'classes/ios/NSArray+NTJsonModel.h',
                          'classes/ios/NSDictionary+NTJsonModel.h'

end
