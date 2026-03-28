shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	//// Called for every pixel the material is visible on.
	vec4 tex_col = texture(TEXTURE, UV);
	
	float depth = (tex_col.r + tex_col.g + tex_col.b) / 3.0;
	vec2 sample_point = UV - (depth * 0.1);
	
	
	vec4 grab_col = textureLod(screen_texture, sample_point, 0.0);
	COLOR = grab_col;
	//if (grab_col.a == 0.0) {
		//COLOR.r = 1.0;
	//}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
