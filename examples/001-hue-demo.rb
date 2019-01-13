# START:setup
[1] pry(main)> require 'hue'
=> true

[2] pry(main)> client = Hue::Client.new
=> #<Hue::Client:0x0000555b194f0b40
 @bridges=
  [#<Hue::Bridge:0x0000555b194f0140
    @client=#<Hue::Client:0x0000555b194f0b40 ...>,
    @id="001788fffe2c1ba4",
    @ip="10.0.0.106">],
 @username="redacted">
# END:setup

# START:lights
[3] pry(main)> client.lights.map(&:name)
=> ["Bottom lamp", "Middle lamp", "Top lamp", "Bloom"]

[4] pry(main)> bloom = client.lights.last
=> #<Hue::Light:0x0000555b1970a750
 @alert="none",
 @bridge=
  #<Hue::Bridge:0x0000555b194f0140
   @client=
    #<Hue::Client:0x0000555b194f0b40
     @bridges=[#<Hue::Bridge:0x0000555b194f0140 ...>],
     @username="CSvQNKCBeyLj-FRitKTPUNRD4tEmphZIjUG1VGp1">,
   @id="001788fffe2c1ba4",
   @ip="10.0.0.106",
   @lights=
   # END:lights
#	   ... snipped for brevity ...

# START:commands
[6] pry(main)> ls bloom
Hue::TranslateKeys#methods: translate_keys  unpack_hash
Hue::EditableState#methods: 
  alert=       color_temperature=  hue=  on!  on?          set_xy
  brightness=  effect=             off!  on=  saturation=
Hue::Light#methods: 
  alert       color_mode         hue    name          reachable?
  bridge      color_temperature  id     name=         refresh   
  brightness  effect             model  point_symbol  saturation
instance variables: 
  @alert       @client      @hue    @name       @saturation       
  @bridge      @color_mode  @id     @on         @software_ver
  @brightness  @effect      @model  @reachable  @state            
# END:commands

# START:action
# Change my bulb to a blue color
[7] pry(main)> bloom.hue = 44444
=> 44444

# Turn off my bulb
[8] pry(main)> bloom.off!
=> false

# Turn on my bulb
[9] pry(main)> bloom.on!
=> true
# END:action