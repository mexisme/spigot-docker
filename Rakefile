#!/usr/bin/env rake -f

require 'logging'
require 'rake'

require_relative 'lib/myshell'

# Convert to bool
DEBUG = ENV['DEBUG'] ? true : false
LOG = Logging.logger(STDOUT)
LOG.level = :debug if DEBUG

DOCKER = 'docker'
PACKER = 'packer build' + (DEBUG ? ' -debug' : '')
PORT = 25565
VERSION = '1.11.2'
ARTEFACT_DIR = 'artefacts'

task :default => :help

desc "Show help"
task :help do
  MyShell::Benchmarked.new(*%w[rake -s -T]).call
end

desc "Build the Spigot docker container"
task :build => ['build:build_tools', 'build:spigot', 'build:spigot_server']

namespace :build do
  directory ARTEFACT_DIR

  task :build_tools => "artefacts/BuildTools.jar"
  file "artefacts/BuildTools.jar" => ARTEFACT_DIR do
    MyShell::Benchmarked.run(
      "#{PACKER_BUILD} -var 'local-artefact-dir=#{ARTEFACT_DIR}' build-tools.json"
    )
  end

  task :spigot => "artefacts/spigot-#{VERSION}.jar"
  file "artefacts/spigot-#{VERSION}.jar" => ARTEFACT_DIR do
    MyShell::Benchmarked.run(
      "#{PACKER_BUILD} -var 'version=#{VERSION}' -var 'local-artefact-dir=#{ARTEFACT_DIR}' spigot.json"
    )
  end

  task :spigot_server => ARTEFACT_DIR do
    MyShell::Benchmarked.run(
      "#{PACKER_BUILD} -var 'version=#{VERSION}' -var 'local-artefact-dir=#{ARTEFACT_DIR}' spigot-server.json"
    )
  end
end

desc "Bring the Spigot Minecraft server up"
task :up do
  DIR = ENV['DIR'] or fail "You need to provide 'DIR=${minecraft-dir}' to set where Spigot stores config and World data"
  MyShell::Benchmarked.run("#{DOCKER} run --detach --tty --name minecraft-spigot --publish #{PORT}:#{PORT} --volume #{DIR}:/minecraft minecraft-spigot:#{VERSION}")
end

desc "Bring the Spigot Minecraft server down"
task :down do
  MyShell::Benchmarked.run("#{DOCKER} stop minecraft-spigot && #{DOCKER} rm minecraft-spigot")
end

desc "Show the Spigot Minecraft server's logs"
task :logs do
  MyShell::Benchmarked.run("#{DOCKER} logs minecraft-spigot")
end
