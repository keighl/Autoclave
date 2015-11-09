Pod::Spec.new do |s|
  s.name = 'Autoclave'
  s.version = '0.1.0'
  s.license = 'MIT'
  s.summary = 'Your easygoing Autolayout friend.'
  s.homepage = 'https://github.com/keighl/Autoclave'
  s.authors = { 'keighl' => 'keighl@keighl.com' }
  s.source = { :git => 'https://github.com/keighl/Autoclave.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.source_files = 'Source/*.swift'
  s.requires_arc = true
end