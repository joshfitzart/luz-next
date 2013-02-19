class GuiUserObjectEditor < GuiBox
	attr_accessor :pointer

	BACKGROUND_COLOR = [0,0,0,0.8]

	def initialize(user_object, options)
		@user_object, @options = user_object, options
		super([])
		create!
		set(options)
	end

	def create!
		#
		# Background
		#
		self << (@background=GuiObject.new.set(:color => BACKGROUND_COLOR))

		#
		# Let object build its own content (eg. lists of effects and settings)
		#
		self << @user_object.gui_build_editor		# find gui_build_editor implementations in gui-ruby/addons

		#
		# Title
		#
		if @user_object.has_settings_list?
			self << (@title_button=GuiButton.new.set(:scale_x => 0.5, :offset_x => -0.25, :scale_y => 0.10, :offset_y => 0.5 - 0.06, :color => [0,0,0,0.1]))		#.set(:background_image => $engine.load_image('images/buttons/menu.png'))

			@title_button.on_clicked {
				@user_object.gui_fill_settings_list(@user_object)
			}
		end
		self << (@title_text=BitmapFont.new.set_string(@user_object.title).set(:scale_x => 0.5, :float => :left, :scale_y => 0.10, :offset_x => 0.0, :offset_y => 0.5 - 0.06))		#.set(:background_image => $engine.load_image('images/buttons/menu.png'))

		self << (@delete_button = GuiButton.new.set(:scale_x => 0.04, :scale_y => -0.04, :offset_x => 0.48, :offset_y => 0.47, :background_image => $engine.load_image('images/buttons/menu.png')))
		@delete_button.on_clicked { |pointer|
			$gui.trash!(@user_object)
		}
	end

	def close!
		animate({:opacity => 0.0, :offset_y => offset_y - 0.2, :scale_x => scale_x * 1.1}, duration=0.2) { set_hidden(true) }
	end
end
