require 'hue'
require 'logger'

module Lita
  module Handlers
    class HueLightswitch < Handler
      BLOOM = HueColoredBulb.new('Bloom')

      route /^hue\s+(.+)/i, :handle_hue

      def handle_hue(message)
	      command, *rest = message.matches.last.last.split
	      case command
	      when 'list_colors'
		      message.reply BLOOM.colors.join ' '
	      when 'color'
		      recolor rest
	      when 'off'
		      turn_off rest
	      when 'on'
		      turn_on rest
	      else
		      message.reply "I don't know how to [#{rest}] a hue bulb."
	      end
      end

      def recolor(rest)
	      BLOOM.set_color rest.first
      end

      def turn_off(rest)
	      BLOOM.light.off!
      end

      def turn_on(rest)
	      BLOOM.light.on!
      end

      #BLOOM.demo

      # insert handler code here

      Lita.register_handler(self)
    end
  end
end
