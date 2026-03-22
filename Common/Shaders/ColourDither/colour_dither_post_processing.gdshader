shader_type canvas_item;


#define IS_POSTPROCESSOR


#include "colour_dither_include.gdshaderinc"


void fragment() {
	vec4 colour = get_albedo(SCREEN_UV);
    vec2 pixel = get_pixel_center(SCREEN_UV);
    float dither_value = get_dither_value(pixel);
    COLOR = get_dither_colour(dither_value, colour);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
