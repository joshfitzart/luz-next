require 'user_object_setting'

class UserObjectSettingActor < UserObjectSetting
	include Drawing

	#
	# API for plugins
	#
	def present?
		!@actor.nil?
	end

	def one
		yield @actor if @actor
	end

	def render
		@actor.render! if @actor
	end

	def summary
		summary_format(@actor.title) if @actor
	end
end
