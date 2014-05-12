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

class ProjectEffectScreenClear < ProjectEffect
	title				'Screen Clear'
	description "Clears screen (frame buffer) to selected color."

	setting 'color', :color, :default => [0.0,0.0,0.0]
	setting 'amount', :float, :range => 0.0..1.0, :default => 1.0..0.0

	def render
		fade_screen_to_color_with_alpha_blend(color, amount)
		yield
	end
end
