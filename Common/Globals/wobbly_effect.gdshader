shader_type canvas_item;


#include "res://Common/Shaders/ColourDither/colour_dither_include.gdshaderinc"

group_uniforms WobblyEffect;
uniform sampler2D flowMap;
uniform float strength;
uniform float speed;
uniform int frames: hint_range(0, 10);
group_uniforms;


// Pixel offset used only for alpha dithering
uniform vec2 alpha_dither_pixel_offset = vec2(0.0);


uniform sampler2D screen_texture : source_color, repeat_disable, filter_nearest;


//Returns a value between 0 and 1 depending of the frames -> exemple: frames = 4, frame 1 = 0.25
float clock(float time){
	float fframes = float(frames);
	return floor(mod(time * speed, fframes)) / fframes;
}


void fragment() {
	// Called for every pixel the material is visible on.
	float c = clock(TIME); //Get clock frame
	vec4 offset = texture(flowMap, vec2(UV.x + c, UV.y + c)) * strength; //Get offset 
	//COLOR = texture(TEXTURE, vec2(UV.x,UV.y) + normal.xy); //Apply offset
	COLOR = texture(TEXTURE, vec2(UV.x,UV.y) + offset.xy - vec2(0.5,0.5)*strength); //We need to remove the displacement 
	
	
	// Dither
	vec4 colour_before_dither = COLOR;
    vec2 pixel = get_pixel_center(TEXTURE, UV);
    float dither_value_alpha = get_dither_value(pixel + alpha_dither_pixel_offset);
    if (colour_before_dither.a <= dither_value_alpha) {
        discard;
    }
    float dither_value = get_dither_value(pixel);
    COLOR = get_dither_colour(dither_value, colour_before_dither);
}


// TEST CLOCK
//void fragment(){
	//float c = clock(TIME);
	//COLOR = vec4( c, c, c, 1);
//}
