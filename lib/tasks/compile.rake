# frozen_string_literal: true

require 'rake/clean'
require 'fileutils'

desc 'Compile LibUCL from submodule'
task :compile do
  ext_dir = "#{__dir__}/../../ext/libucl"
  lib_dir = "#{__dir__}/../ucl/"

  system 'git', 'submodule', 'update', '--init'

  Dir.chdir(ext_dir) do |path|
    system './autogen.sh'
  end

  Dir.chdir(ext_dir) do |path|
    system './configure'
  end

  Dir.chdir(ext_dir) do |path|
    system 'make'
  end

  FileUtils.cp "#{ext_dir}/src/.libs/libucl.so", "#{lib_dir}/libucl.so"
end

desc 'Make clean'
task :make_clean do
  ext_dir = "#{__dir__}/../../ext/libucl"
  lib_dir = "#{__dir__}/../ucl/"

  Dir.chdir(ext_dir) do |path|
    system 'make clean'
  end

  FileUtils.rm_f "#{lib_dir}/libucl.so"
end

task clean: [:make_clean]
