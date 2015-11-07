Pod::Spec.new do |s|
  s.name = 'Autoclave'
  s.version = '0.1.0'
  s.license = 'MIT'
  s.summary = ''
  s.homepage = 'https://github.com/keighl/Autoclave'
  s.authors = { 'Autoclave Software Foundation' => 'info@alamofire.org' }
  s.source = { :git => 'https://github.com/keighl/Autoclave.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.7'
  s.source_files = 'Source/*.swift'
  s.requires_arc = true
end