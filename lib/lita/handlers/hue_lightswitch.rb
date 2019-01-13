# START:header
module Lita
  module Handlers
    class HueLightswitch < Handler

      # Set these in your bot's lita_config.rb
      config :hue_bulb_name, default: 'Bloom'

      # Create a reusable instance variable handle to a bulb
      #   named 'Bloom' (or whatever your config value for
      #   :hue_bulb_name is set to.
      def light
	@_light ||= HueColoredBulb.new(config.hue_bulb_name)
      end
      # END:header

      # START:handle
      # Any command of the form 'lita hue ____' should be caught
      #   and passed to the :handle_hue method
      route /^hue\s+(.+)/i, :handle_hue, command: true

      # Split the captured hue command into a one-word command name
      #   and everything after that (if anything) and pass the results
      #   on to the :hue_execute mapping below.
      def handle_hue(message)
	command, *rest = message.matches.last.last.split
	response = hue_execute(command, rest)
	message.reply response
      end
      # END:handle

      # START:mapping
      # Given a one-word hue :command and a possibly-empty array of 
      #   additional parameters :rest, step through this case 
      #   statement and perform the first matching action.
      def hue_execute(command, rest=[])
	case command
	when 'demo'
	  demo
	  'Enjoy the light demo!'
	when 'list_colors'
	  list_colors
	when 'color'
	  recolor rest
	  "Setting color to #{rest.join ' '}"
	when 'off'
	  off!
	  "Turning off light!"
	when 'on'
	  on!
	  "Turning on light!"
	else
          debug_message = [command, rest].flatten.join ' '
	  "I don't know how to [#{debug_message}] a hue bulb."
	end
      end
      # END: mapping

      # START:colors
      # Simple help text in case someone forgets Lita's `hue` commands
      def list_colors
	light.colors.join ' '
      end

      # Set the bulb's color to one of the named colors it recognizes
      #   e.g. red, green, blue, etc.
      def recolor(rest)
	new_color = rest.first
	light.set_color new_color
      end
      # END:colors

      # START:basics
      ##################
      #
      # These three commands are pass-throughs to the HueColoredBulb wrapper.
      #
      ##################

      def off!
	light.off!
      end

      def on!
	light.on!
      end

      def demo
	light.demo
      end
      # END:basics

      Lita.register_handler(self)
    end
  end
end
