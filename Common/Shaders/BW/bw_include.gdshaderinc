group_uniforms BW;
uniform float strength: hint_range(0.0, 1.0, 0.1) = 1.0;
varying vec4 modulate;
group_uniforms;

void vertex() {
	modulate = COLOR;
}


vec3 get_bw_colour_from_tex(sampler2D original_tex, vec2 original_uv) {
	vec4 original_colour = texture(original_tex, original_uv);
	float grayscale = (original_colour.r + original_colour.g + original_colour.b)/3.0;
	vec3 grayscale_colour = vec3(grayscale, grayscale, grayscale) * strength;
	original_colour = original_colour * (1.0 - strength);
	
	return (grayscale_colour + original_colour.rgb * modulate.rgb);
}

vec3 get_bw_colour_from_colour(vec3 original_colour) {
	float grayscale = (original_colour.r + original_colour.g + original_colour.b)/3.0;
	vec3 grayscale_colour = vec3(grayscale, grayscale, grayscale) * strength;
	original_colour = original_colour * (1.0 - strength);
	
	return (grayscale_colour + original_colour.rgb * modulate.rgb);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
