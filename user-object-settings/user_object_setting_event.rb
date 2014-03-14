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

class UserObjectSettingEvent < UserObjectSetting
	def to_yaml_properties
		['@event'] + super
	end

	attr_reader :event

	#
	#
	#
	def now?
		return (@event and (@event.do_value == true))
	end

	def on_this_frame?
		return (@event and @event.on_this_frame?)
	end

	def previous_frame?
		return (@event and @event.previous_frame?)
	end

	def count
		return (@event ? @event.count : 0)
	end

	def with_value(value, &proc)
		return yield unless @event
		@event.with_value(value, &proc)
	end

	def summary
		summary_format(@event.title) if @event
	end
end
