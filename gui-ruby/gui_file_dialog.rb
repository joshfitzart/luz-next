require 'pathname'

class GuiFileDialog < GuiBox
	attr_reader :path

	callback :selected

	DIRECTORY_COLOR = [0.5,0.5,1.0,1.0]
	FILE_COLOR = [1,1,1,1]

	def initialize
		super
		create!
	end

	def show_for_path(path, pattern='*.*')
		@path = path
		@directories, @files = load_directories, load_files(pattern)
		@directory_list.clear!
		@directories.each { |filename|
			@directory_list << (renderer = GuiTextRenderer.new(filename).set(:label_color => DIRECTORY_COLOR))
			renderer.on_clicked { show_for_path(File.join(@path, filename)) }
		}
		@files.each { |filename|
			@directory_list << (renderer = GuiTextRenderer.new(filename).set(:label_color => FILE_COLOR))
			renderer.on_clicked { notify_for_filename(filename) }
		}
	end

private

	def create!
		self << GuiObject.new.set(:background_image => $engine.load_image('images/overlay.png'))		# background
		self << (@path_string = GuiString.new(self, :path).set(:scale_y => 0.05, :offset_y => 0.5 - 0.025))
		self << (@directory_list = GuiList.new.set(:scale_y => 0.85, :offset_x => -0.04, :offset_y => -0.03, :spacing_y => -1.0, :item_aspect_ratio => 16.5))

		self << (@up_button=GuiButton.new.set(:scale_x => 0.15, :scale_y => -0.07, :offset_x => -0.40, :offset_y => 0.5 - 0.035, :background_image => $engine.load_image('images/buttons/close.png')))
		@up_button.on_clicked { show_for_path(File.join(@path, '..')) }

		self << (@close_button=GuiButton.new.set(:scale_x => 0.15, :scale_y => 0.07, :offset_x => 0.0, :offset_y => -0.5 + 0.035, :background_image => $engine.load_image('images/buttons/close.png')))
		@close_button.on_clicked { hidden! }

		show_for_path(File.dirname($engine.project.path))
	end

	def load_directories
		directories = []
		Dir.new(@path).each { |filename|
			directories << filename if File.directory?(File.join(@path, filename))
		}
		directories.delete('.')
		directories.delete('..')
		directories.sort
	end

	def load_files(pattern)
		files = []
		Dir.new(@path).each_matching(pattern) { |filename|
			files << File.basename(filename) unless File.directory?(File.join(@path, filename))
		}
		files
	end

	def notify_for_filename(filename)
		selected_notify(Pathname.new(File.join(@path, filename)).realpath.to_s)
	end
end
