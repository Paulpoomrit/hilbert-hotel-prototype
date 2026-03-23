shader_type canvas_item;


uniform vec4 background_colour : source_color;
uniform vec4 shadow_colour : source_color;
uniform vec2 offset_in_pixels;


uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	
	// Read screen texture
	vec4 current_colour = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	
	// Check if the current colour is backgroud
	if (length(current_colour - background_colour) < 0.01) {
		
		vec4 offset_colour = textureLod(SCREEN_TEXTURE, SCREEN_UV - offset_in_pixels * SCREEN_PIXEL_SIZE, 0.0);
		
		// Check if at our offset pos, we have a colour != background
		// i.e., need a shadow to be drawn!
		if (length(offset_colour - background_colour) > 0.01) {
			current_colour = shadow_colour;
		}
	}
	COLOR = current_colour;
	
}