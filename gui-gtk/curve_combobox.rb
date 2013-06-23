 ###############################################################################
 #  Copyright 2006 Ian McIntosh <ian@openanswers.org>
 #
 #  This program is free software; you can redistribute it and/or modify
 #  it under the terms of the GNU General Public License as published by
 #  the Free Software Foundation; either version 2 of the License, or
 #  (at your option) any later version.
 #
 #  This program is distributed in the hope that it will be useful,
 #  but WITHOUT ANY WARRANTY; without even the implied warranty of
 #  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 #  GNU Library General Public License for more details.
 #
 #  You should have received a copy of the GNU General Public License
 #  along with this program; if not, write to the Free Software
 #  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 ###############################################################################

require 'object_combobox'

class CurveComboBox < ObjectComboBox
	column :pixbuf, :type => :pixbuf, :model_column => :pixbuf, :expand => false
	column :title, :type => :markup, :model_column => :title, :expand => true

	def initialize
		super :model => $gui.curve_model

		# Hide curve titles on closed comboboxes
		if $settings['hide-curve-titles']
			signal_connect("notify::popup-shown") { @title_column_renderer.visible = popup_shown? }
			@title_column_renderer.visible = false		# starts hidden
		end
	end
end
