shader_type canvas_item;

group_uniforms BW;
uniform float strength: hint_range(0.0, 1.0, 0.1) = 1.0;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 original_colour = texture(TEXTURE, UV);
	float grayscale = (original_colour.r + original_colour.g + original_colour.b)/3.0;
	vec3 grayscale_colour = vec3(grayscale, grayscale, grayscale) * strength;
	original_colour = original_colour * (1.0 - strength);
	
	COLOR.rgb = grayscale_colour + original_colour.rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
