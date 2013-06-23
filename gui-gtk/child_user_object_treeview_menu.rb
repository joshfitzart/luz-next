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

require 'glade_window'

class ChildUserObjectTreeviewMenu < GladeWindow
	callback :new, :edit, :clone, :delete

	# create GTK+ callbacks by cloning the ruby ones created by 'callback'
	alias :on_new_activate :new_notify
	alias :on_edit_activate :edit_notify
	alias :on_clone_activate :clone_notify
	alias :on_delete_activate :delete_notify

	def initialize
		super('child_user_object_treeview_menu', :widgets => [:edit_menuitem, :clone_menuitem, :delete_menuitem])
	end

	def popup_for_objects(objects, event)
		@edit_menuitem.sensitive = objects.size > 0
		@clone_menuitem.sensitive = objects.size > 0
		@delete_menuitem.sensitive = objects.size > 0

		popup(nil, nil, event.button, event.time)
	end
end
