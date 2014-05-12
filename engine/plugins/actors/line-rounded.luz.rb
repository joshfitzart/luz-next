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

class ActorLineRounded < ActorShape
	virtual		# deprecated

	title				"Line Rounded"
	description "A line with rounded corners and controllable length and width."

	setting 'length', :float, :range => 0..100.0, :default => 0.0..1.0, :breaks_cache => true
	setting 'width', :float, :range => 0.0..100.0, :default => 1.0..100.0, :breaks_cache => true
	setting 'detail', :integer, :range => 2..100, :default => 100..100, :breaks_cache => true

	cache_rendering

	def shape
		yield :shape => Path.generate { |s|
			s.start_at(width / 2, 0)
			s.arc_to(0.0, 0.0, width / 2, width / 2, 0.0, -Math::PI, detail)
			s.line_to(-width / 2, length)
			s.arc_to(0.0, length, width / 2, width / 2, Math::PI, 0.0, detail)
			s.line_to(width/2, 0)
		}
	end
end
