shader_type canvas_item;


#include "colour_dither_include.gdshaderinc"

// Pixel offset used only for alpha dithering
uniform vec2 alpha_dither_pixel_offset = vec2(0.0);


void fragment() {
	vec4 colour = get_albedo(TEXTURE, UV);
    vec2 pixel = get_pixel_center(TEXTURE, UV);
    float dither_value_alpha = get_dither_value(pixel + alpha_dither_pixel_offset);
    if (colour.a <= dither_value_alpha) {
        discard;
    }
    float dither_value = get_dither_value(pixel);
    COLOR = get_dither_colour(dither_value, colour);
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
