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

class ActorEffectChildNumberingRotate < ActorEffect
	title				"Child Numbering Rotate"
	description "Rotate the numbering of children (eg. 1,2,3,4 to 2,3,4,1), which may change how future effects treat the children."

	categories :child_consumer

	setting 'number', :integer, :range => 0..100, :default => 1..2

	def render
		yield :child_index =>	(child_index + number) % total_children, :total_children => total_children
	end
end
