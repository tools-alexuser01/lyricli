Gem::Specification.new do |s|
  s.name        = 'lyricli'
  s.version     = '0.0.2'
  s.summary     = 'Lyricli is an awesome lyric client for your Command Line'
  s.description = 'Lyricli is an awesome CLI tool to read the lyrics of your currently playing song right in the command line'
  s.authors     = ['Ben Beltran']
  s.email       = 'ben@nsovocal.com'
  s.homepage    = 'http://nsovocal.com/lyricli'
  s.licenses    = ['BSD-3-Clause']

  s.files = Dir['lib/**/*.rb'] + Dir['bin/*']
  s.files += Dir['[A-Z]*'] + Dir['spec/**/*']
  s.files += Dir['config/**/*', 'lib/**/*.scpt']

  s.executables << 'lrc'

  # Runtime Dependencies
  s.add_runtime_dependency 'nokogiri', '~> 1.5'
  s.add_runtime_dependency 'multi_json', '~> 1.3'
  s.add_runtime_dependency 'rdio', '~> 0.1'
  s.add_runtime_dependency  'launchy', '~> 2.1'

  # Development Dependencies
  s.add_development_dependency 'ruby-debug19', '~> 0.11'
  s.add_development_dependency 'yard', '~> 0.8'
  s.add_development_dependency 'thin', '~> 1.5'
  s.add_development_dependency 'rspec', '~> 2.11'
end
