Gem::Specification.new do |s|
  s.name        = 'lyricli'
  s.version     = '0.0.1'
  s.summary     = 'Lyricli is an awesome lyric client for your Command Line'
  s.description = 'Lyricli is an awesome CLI tool to read the lyrics of your currently playing song right in the command line'
  s.authors     = ['Ben Beltran']
  s.email       = 'ben@nsovocal.com'
  s.homepage    = 'http://nsovocal.com/lyricli'

  s.files = Dir['lib/**/*.rb'] + Dir['bin/*']
  s.files += Dir['[A-Z]*'] + Dir['spec/**/*']
  s.files += Dir['lib/**/*.json', 'lib/**/*.scpt']

  s.executables << 'lrc'

  # Runtime Dependencies
  s.add_runtime_dependency 'nokogiri', '~> 1.5.5'
  s.add_runtime_dependency 'multi_json', '~> 1.3.6'
  s.add_runtime_dependency 'rdio', '~> 0.1.0'
  s.add_runtime_dependency  'launchy', '~> 2.1.2'

  # Development Dependencies
  s.add_development_dependency 'ruby-debug19', '~> 0.11.6'
  s.add_development_dependency 'yard', '~> 0.8.2.1'
  s.add_development_dependency 'thin', '~> 1.5.0'
end
