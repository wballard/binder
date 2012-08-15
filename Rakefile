
require 'coffee-script'
require 'fileutils'
require 'uglifier'
require 'listen'

COFFEE_SRC = FileList['src/*.coffee']
COFFEE_DEST = COFFEE_SRC.pathmap "build/%n.js"
JAVASCRIPT_SRC = FileList['src/*.js']
JAVASCRIPT_DEST = JAVASCRIPT_SRC.pathmap "build/%n.js"
DEST = 'binder.min.js'

task :default => [DEST]

directory "build"

COFFEE_DEST.each do |jsfile|
  srcfile = File.join('src', File.basename(jsfile).ext('.coffee'))

  file jsfile => srcfile do |t|
    File.write jsfile, CoffeeScript.compile(File.read(srcfile))
  end
end

JAVASCRIPT_DEST.each do |jsfile|
  srcfile = File.join('src', File.basename(jsfile).ext('.js'))

  file jsfile => srcfile do |t|
    FileUtils.cp srcfile, jsfile
  end
end

file DEST => COFFEE_DEST + JAVASCRIPT_DEST do |t|
  source = t.prerequisites.collect { |fn| File.read(fn) }
  source = source.join ' '
  File.write t.name, Uglifier.compile(source)
end

task :clean do
  File.delete DEST
  FileUtils.rmdir 'build'
end

task :watch do
  Listen.to 'src' do
    puts 'compiling'
    system 'rake'
  end
end

task :test => DEST do
    system 'ichabod --jasmine SpecRunner.html'
end
