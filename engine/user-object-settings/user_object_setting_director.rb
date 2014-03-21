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

require 'user_object_setting'

class UserObjectSettingDirector < UserObjectSetting
	def to_yaml_properties
		super + ['@director']
	end

	def one
		yield @director if @director
	end

	def render
		one { |director|
			if (@enable_render_on_actor and @render_on_actor)
				with_offscreen_buffer { |buffer|
					# save future actor renders to buffer
					buffer.using {
						director.render!
					}

					# render buffer on chosen actor
					buffer.with_image {
						@render_on_actor.render!
					}
				}
			else
				director.render!
			end
		}
	end

	def summary
		summary_format(@director.title) if @director
	end
end
