#!/usr/bin/env ruby

######################################################################################
# Copyright 2014 Ian McIntosh <ian@openanswers.org> released until the GPL version 2 #
######################################################################################

$LOAD_PATH << '/usr/lib/ruby/1.9.1/i486-linux/'			# TODO: remove this

APP_NAME = 'Luz 2'
BASE_SET_PATH = 'base.luz'

Dir.chdir(File.dirname(__FILE__))	# So that this file can be run from anywhere
$LOAD_PATH.unshift('./utils').unshift('.')
$LOAD_PATH << './engine'
$LOAD_PATH << './engine/user_object_settings'

require 'reloadable_require'
multi_require 'optparse', 'sdl', 'opengl', 'addons/dir'
load_directory(File.join(Dir.pwd, 'utils', 'addons'), '**.rb')
multi_require 'method_piping', 'boolean_accessor', 'constants', 'drawing', 'luz_performer', 'engine', 'settings', 'vector3'

if RUBY_VERSION[0,3] != '1.9'
	puts "For Speed and Smoooth Flow, choose Ruby Version 1.9 (you are using #{RUBY_VERSION})"
	exit
else
	puts "Using Ruby #{RUBY_VERSION}"
end

#
# Begin App
#
$settings = Settings.new.load(File.join(Dir.home, SETTINGS_DIRECTORY, SETTINGS_FILENAME))
$application = LuzPerformer.new(APP_NAME)

options = OptionParser.new do |opts|
	opts.banner = "Usage: luz.rb [options] [project.luz]"

	opts.on("--width <width>", Integer, "Resolution width (eg. 800)") do |w|
		$application.width = w
	end
	opts.on("--height <height>", Integer, "Resolution height (eg. 600)") do |h|
		$application.height = h
	end
	opts.on("--bits-per-pixel <bpp>", Integer, "Bits per pixel (8, 16, 24, 32)") do |bpp|
		$application.bits_per_pixel = bpp
	end
	opts.on("--frames-per-second <fps>", Integer, "Target FPS") do |fps|
		$application.frames_per_second = fps.to_i
	end
	opts.on("--fullscreen", "Fullscreen") do
		$application.fullscreen = true
	end
	opts.on("--window", "Window") do
		$application.fullscreen = false
	end
	opts.on("--system-mouse", "System Mouse") do
		$application.system_mouse = true
	end
	opts.on("--borderless", "Borderless") do
		$application.border = false
	end
end

# Parse command line arguments
options.parse!
project_path = ARGV.pop		# last argument is optional project name

$application.create

# Create Luz Engine
$engine = Engine.new
$engine.post_initialize		# TODO: add message bus ip/port params
$engine.load_plugins

# Engine callbacks
USER_OBJECT_EXCEPTION_FORMAT = "#{'#' * 80}\nOops! The plugin shown below has caused an error and has stopped functioning:\n\n%s\nObject:%s\n#{'#' * 80}\n"
$engine.on_user_object_exception { |object, exception| puts sprintf(USER_OBJECT_EXCEPTION_FORMAT, exception.report_format, object.title) }

# GUI
multi_require 'easy_accessor', 'value_animation', 'value_animation_states'
$LOAD_PATH << './gui'
multi_require 'pointer', 'pointer_mouse', 'gui_default'

# Load
$engine.load_from_path(project_path || BASE_SET_PATH)

$gui = GuiDefault.new

$engine.on_new_project {
	$gui = GuiDefault.new
}

# Go!
$application.run
