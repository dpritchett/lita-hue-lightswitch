require 'hue'

class HueColoredBulb
	def initialize(name='Bloom')
		@client = Hue::Client.new
		@light = @client.lights.select do |light|
			light.name == name
		end.first
		raise ArgumentError if @light.nil?
	end

	attr_reader :light, :client

	def colors
		%w[
		red orange yellow
		chartreuse green aquamarine
		cyan azure blue
		violet magenta rose
		]
	end

	def max_color
		# 0..65535
		Hue::Light::HUE_RANGE.last
	end

	def hue_for(name)
		colors.find_index(name) * (self.max_color / colors.count).to_i
	end

	def set_color(name)
		raise ArgumentError.new("I don't know that color!") unless colors.include? name.downcase
		n = self.hue_for name
		puts "\t#{n}"
		light.hue = n
	end

	def demo
		colors.each do |name|
			puts name
			self.set_color name
			sleep 1
		end
	end
end
