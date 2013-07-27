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

class EventInputButtonToggleRepeater < EventInput
	title				"Button Toggle Repeater"
	description "When toggled on, repeats periodically."

	categories :button

	setting 'button', :button, :summary => true
	setting 'period', :timespan, :summary => true

	def value
		@on = false if @on.nil?

		if $engine.button_pressed_this_frame?(button)
			@on = !@on
		end

		return (@on && time_since_last_activation > period.to_seconds)
	end
end
