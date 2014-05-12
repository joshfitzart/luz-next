 ###############################################################################
 #  Copyright 2012 Ian McIntosh <ian@openanswers.org>
 ###############################################################################

class DirectorEffectDMXActorEffects < DirectorEffect
	title				"DMX Actor Effects"
	description "Combines a Director full of DMX light plugins with an Actor that sets colors."

	hint "Use plugins like Theme Children in the Actor, as the 'child number' will be set for each light."

	setting 'director', :director, :summary => true
	setting 'actor', :actor, :summary => true

	def tick
		director.one { |dmx_director|
			lights = dmx_director.effects
			actor.one { |actor_effects|
				with_env(:total_children, lights.size) {			# this can have an effect on the resulting color set
					lights.each_with_index { |light, index|
						$engine.user_object_try(light) {					# this ensures the plugin is usable and blames it for any exceptions from here on in
							with_env(:child_index, index) {					# this can have an effect on the resulting color set
								actor_effects.render_recursive {			# run actor's effects, and when they're done...
									light.resolve_settings							# this is for settings that we're not manually setting values for below

									# Set RGB
									if light.respond_to? :red
										color = current_color_array				# ...read the final color and send it to the DMX plugin (respecting alpha!)
										light.red, light.green, light.blue = color[0]*color[3], color[1]*color[3], color[2]*color[3]
									elsif light.respond_to? :brightness
										color = current_color_array
										light.brightness = ((color[0] + color[1] + color[2]) / 3.0) * color[3]
									end

									# Set pan and tilt
									if light.respond_to? :pan
										translate_x, translate_y, translate_z = current_xyz_translation
										light.pan = (translate_x + 0.5).clamp(0.0, 1.0)
										light.tilt = (translate_y + 0.5).clamp(0.0, 1.0)
									end

									light.tick													# let plugin do its work
								}
							}
						}
					}
				}
			}
		}
	end
end
