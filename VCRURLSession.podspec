Pod::Spec.new do |s|
  s.name     = 'VCRURLSession'
  s.version  = '1.3.0'
  s.license  = 'MIT'
  s.summary  = 'VCRURLSession'
  s.homepage = 'https://github.com/plu/VCRURLSession'
  s.authors  = { 'Johannes Plunien' => 'plu@pqpq.de' }
  s.social_media_url = 'https://twitter.com/plutooth'
  s.source   = { :git => 'https://github.com/plu/VCRURLSession.git', :tag => s.version.to_s, :submodules => true }
  s.requires_arc = true
  s.library = 'z'

  s.ios.deployment_target = '7.0'

  s.default_subspec = 'Core'
  s.subspec 'Core' do |cs|
    cs.source_files = 'VCRURLSession/**/*.{h,m}'
    cs.public_header_files = 'VCRURLSession/*.h'
  end
end
