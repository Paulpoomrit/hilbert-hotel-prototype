shader_type canvas_item;
#include "res://Common/Shaders/BW/bw_include.gdshaderinc"


uniform vec4 background_colour : source_color;
uniform vec4 shadow_colour : source_color;
uniform vec2 offset_in_pixels;
uniform sampler2D BG: source_color, repeat_enable;
uniform sampler2D height_map: source_color;


uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;


void fragment() {
	// Read screen texture
	vec4 current_colour = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);

	// Check if the current colour is backgroud
	if (length(current_colour - background_colour) < 0.01) {

		vec4 offset_colour = textureLod(SCREEN_TEXTURE, SCREEN_UV - offset_in_pixels * SCREEN_PIXEL_SIZE, 0.0);

		vec4 height_map_col = texture(height_map, UV);
		float depth = (height_map_col.r) + 1.0;
		vec2 sample_point = SCREEN_UV - (offset_in_pixels * depth * SCREEN_PIXEL_SIZE);
		vec4 grab_col = texture(SCREEN_TEXTURE, sample_point, 0.0);

		// Check if at our offset pos, we have a colour != background
		// i.e., need a shadow to be drawn!
		if (length(grab_col - background_colour) > 0.01) {
			current_colour = shadow_colour;
		} else {
			// if it is background, we replace with the actual bg texture
			vec4 bg_colour = texture(BG, UV);
			current_colour = bg_colour;
			// make this works with mendable gravity
			current_colour.rgb = get_bw_colour_from_colour(current_colour.rgb);
		}
	}
	COLOR = current_colour;
}