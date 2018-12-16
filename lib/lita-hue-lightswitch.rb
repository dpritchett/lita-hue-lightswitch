require "lita"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/hue_colored_bulb"
require "lita/handlers/hue_lightswitch"

Lita::Handlers::HueLightswitch.template_root File.expand_path(
  File.join("..", "..", "templates"),
 __FILE__
)
