#!/usr/bin/env rake -f

require 'logging'
require 'rake'

require_relative 'lib/myshell'

# Convert to bool
DEBUG = ENV['DEBUG'] ? true : false
LOG = Logging.logger(STDOUT)
LOG.level = :debug if DEBUG

DOCKER = 'docker'
PACKER = 'packer'
PORT = 25565
VERSION = '1.11.2'

task :default => :help

desc "Show help"
task :help do
  MyShell::Benchmarked.new(*%w[rake -s -T]).call
end

desc "Build the Spigot docker container"
task :build => ['build:builder', 'build:runner']

namespace :build do
  task :builder do
    MyShell::Benchmarked.run("#{PACKER} build builder.json")
  end

  task :runner do
    MyShell::Benchmarked.run("#{PACKER} build runner.json")
  end
end

desc "Run the Spigot Minecraft server"
task :run do
  DIR = ENV['DIR'] or fail "You need to provide 'DIR=${minecraft-dir}' to set where Spigot stores config and World data"
  MyShell::Benchmarked.run("#{DOCKER} run --detach --tty --publish #{PORT}:#{PORT} --volume #{DIR}:/minecraft minecraft-spigot:#{VERSION}")
end
