# frozen_string_literal: true

require 'rake/clean'
require 'fileutils'

desc 'Compile LibUCL from submodule'
task :compile do
  ext_dir = "#{__dir__}/../../ext/libucl"
  lib_dir = "#{__dir__}/../ucl/"

  system 'git', 'submodule', 'update', '--init'

  Dir.chdir(ext_dir) do |_path|
    system './autogen.sh'
    system './configure'
    system 'make'
  end

  suffix = RUBY_PLATFORM.include?('darwin') ? 'dylib' : 'so'

  FileUtils.cp "#{ext_dir}/src/.libs/libucl.#{suffix}", "#{lib_dir}/libucl.#{suffix}"
end

desc 'Make clean'
task :make_clean do
  ext_dir = "#{__dir__}/../../ext/libucl"
  lib_dir = "#{__dir__}/../ucl/"

  Dir.chdir(ext_dir) do |_path|
    system 'make clean'
  end

  suffix = RUBY_PLATFORM.include?('darwin') ? 'dylib' : 'so'

  FileUtils.rm_f "#{lib_dir}/libucl.#{suffix}"
end

task clean: [:make_clean]
