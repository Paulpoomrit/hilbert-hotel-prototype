shader_type canvas_item;

#include "res://Common/Shaders/ColourDither/colour_dither_include.gdshaderinc"

group_uniforms Shadow;
uniform int dist = 2;
uniform vec4 color: source_color = vec4(0.0, 0.0, 0.0, 0.5);
uniform float angle: hint_range(0.0, 360.0) = 90.0;
group_uniforms;

// Pixel offset used only for alpha dithering
uniform vec2 alpha_dither_pixel_offset = vec2(0.0);

varying vec2 main_uv;
varying vec2 shadow_uv;

void vertex() {
	// Called for every vertex the material is visible on.
	
	// 1. Shadow
	vec2 uv = TEXTURE_PIXEL_SIZE * float(dist * 2);
	
	vec2 uv_half = uv * 0.5;
	vec2 uv_dist = uv + 1.0;
	
	vec2 shadow_direction = (vec4(cos(radians(angle)), sin(radians(angle)), 0.0, 1.0) * MODEL_MATRIX).xy;
	
	VERTEX *= uv_dist;
	
	main_uv = UV * uv_dist - uv_half;
	shadow_uv = main_uv - shadow_direction * uv_half;
	// --------------------------------
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	// 1. Shadow
	// sample colors for shadow
	float shadow_amt = texture(TEXTURE, shadow_uv).a
		* step(-1.0, -shadow_uv.x)
		* step(-1.0, -shadow_uv.y)
		* step(0.0, shadow_uv.x)
		* step(0.0, shadow_uv.y);
	
	// shadow color
	COLOR = color * shadow_amt;
	
	// sample main colors on top of shadow
	vec4 main_color = texture(TEXTURE, main_uv)
		* step(-1.0, -main_uv.x)
		* step(-1.0, -main_uv.y)
		* step(0.0, main_uv.x)
		* step(0.0, main_uv.y);
	
	// need to make area where main and shadow overlap black for next step
	COLOR = mix(COLOR, vec4(0.0, 0.0, 0.0, 1.0), main_color.a);

	// add main color on top of blackened area
	COLOR += main_color * main_color.a;
	
	// 2. Dither
	vec4 colour_before_dither = COLOR;
    vec2 pixel = get_pixel_center(TEXTURE, UV);
    float dither_value_alpha = get_dither_value(pixel + alpha_dither_pixel_offset);
    if (colour_before_dither.a <= dither_value_alpha) {
        discard;
    }
    float dither_value = get_dither_value(pixel);
    COLOR = get_dither_colour(dither_value, colour_before_dither);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
