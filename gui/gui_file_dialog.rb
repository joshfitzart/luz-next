require 'pathname'

class GuiFileDialog < GuiBox
	attr_accessor :path

	callback :selected, :closed

	DIRECTORY_COLOR = [0.5,0.5,1.0,1.0]
	FILE_COLOR = [1,1,1,1]

	def initialize(title)
		super()
		@title = title
		create!
	end

	def show_for_path(path, extensions=nil)
		return unless File.exists?(path)
		path = Pathname.new(path).realpath.to_s
		@extensions = extensions
		@path_string.set_value(path)		# this calls path=
	end

	def path=(path)
		@directory_list.clear!
		if File.exists?(path)
			@path = Pathname.new(path).realpath.to_s
			@directories, @files = load_directories, load_files(@extensions)
			fill_directory_list
		end
	end

	def fill_directory_list
		add_directories
		add_files
	end

	def add_directories
		@directories.each { |filename|
			@directory_list << (renderer = GuiLabel.new.set(:string => filename, :width => 20, :color => DIRECTORY_COLOR))
			renderer.on_clicked { show_for_path(File.join(@path, filename)) }
		}
	end

	def add_files
		@files.each { |filename|
			@directory_list << (renderer = GuiLabel.new.set(:string => filename, :color => FILE_COLOR))
			renderer.on_clicked { notify_for_filename(filename) }
		}
	end

	def notify_for_filename(filename)
		selected_notify(Pathname.new(File.join(@path, filename)).realpath.to_s)
	end

private

	def create!
		self << (@background = GuiObject.new.set(:background_image => $engine.load_image('images/file-dialog-background.png')))

		self << (@title_label = GuiLabel.new.set({:width => 10, :color => [0.6,0.6,1.0], :string => @title, :offset_x => 0.0, :offset_y => 0.47, :scale_x => 0.15, :scale_y => 0.05}))

		#self << (@title_label = GuiLabel.new.set({:color => [0.6,0.6,1.0], :string => @title, :offset_x => -0.03, :offset_y => 0.47, :scale_x => 0.1, :scale_y => 0.05}))

		self << (@up_button=GuiButton.new.set(:scale_x => 0.05, :scale_y => 0.07, :offset_x => -0.452, :offset_y => 0.5 - 0.09, :background_image => $engine.load_image('images/buttons/directory-up.png')))
		@up_button.on_clicked { show_for_path(File.join(@path, '..')) }
		self << (@path_string = GuiString.new(self, :path).set(:width => 20, :color => [0.7,0.7,0.7], :offset_x => 0.0, :scale_x => 0.8, :scale_y => 0.04, :offset_y => 0.5 - 0.08))
		self << (@directory_list = GuiList.new.set(:scale_y => 0.825, :offset_x => 0.0, :offset_y => -0.035, :spacing_y => -1.0, :item_aspect_ratio => 16.5))

		self << (@close_button=GuiButton.new.set(:scale_x => 0.3, :scale_y => 0.05, :offset_x => 0.0, :offset_y => -0.5 + 0.025, :background_image => $engine.load_image('images/buttons/close.png')))
		@close_button.on_clicked { closed_notify }

		# focus
		@directory_list.grab_keyboard_focus!
	end

	def load_directories
		directories = []
		Dir.new(@path).each { |filename|
			directories << filename if show_directory?(filename)
		}
		directories.delete('.')
		directories.delete('..')
		directories.sort
	end

	def show_directory?(filename)
		return false if filename[0] == '.'
		File.directory?(File.join(@path, filename))		# it exists.
	end

	def load_files(extensions)
		files = []
		Dir.new(@path).each_with_extensions(extensions) { |filename|
			files << File.basename(filename) if show_filename?(filename)
		}
		files
	end

	def show_filename?(filename)
		return false if filename[0] == '.'
		filepath = File.join(@path, filename)
		File.exist?(filepath) && !File.directory?(filepath)
	end
end

class GuiFileObject < GuiObject
	def initialize(dialog, path)
		@dialog, @path = dialog, path
		$engine.load_image_thumbnail(path) { |thumbnail|
			set(:background_image => thumbnail)
		}
	end

	def click(pointer)
		@dialog.selected_notify(@path)
	end
end

class GuiImageDialog < GuiFileDialog
	def create!
		super
		@directory_list.set(:scale_x => 0.35, :scale_y => 0.75, :offset_x => -0.5 + 0.36 / 2.0, :offset_y => -0.04, :item_aspect_ratio => 6.5)
		self << @images_grid = GuiGrid.new.set(:min_columns => 4, :scale_x => 0.6, :scale_y => 0.5, :offset_x => 0.19, :offset_y => 0.1, :spacing_x => 0.2, :spacing_y => 0.1, :item_scale_x => 0.9, :item_scale_y => 0.8)
	end

	def add_files
		@images_grid.clear!
		Dir.new(@path).each_with_extensions(Engine::SUPPORTED_IMAGE_EXTENSIONS) { |filename|
			@images_grid << GuiFileObject.new(self, filename) unless File.directory?(filename)
		}
	end
end
