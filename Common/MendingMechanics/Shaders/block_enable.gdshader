shader_type canvas_item;

group_uniforms Shadow;
uniform int dist = 2;
uniform vec4 color: source_color = vec4(0.0, 0.0, 0.0, 0.5);
uniform float angle: hint_range(0.0, 360.0) = 90.0;
group_uniforms;

group_uniforms SpecularEffect;
uniform float specular_strength: hint_range(0.0, 1.0, 0.1) = 0.2;
uniform float specular_speed = 2.0;
uniform vec3 specular_colour: source_color = vec3(0.0, 0.0, 0.0);
group_uniforms;

varying vec2 main_uv;
varying vec2 shadow_uv;


float projection(vec2 a, vec2 b, vec2 c) {
	vec2 cb = c - b; 
	vec2 ab = a - b; 
	return dot(ab, cb) / dot(cb, cb);
}


float segment_sd(vec2 uv, vec2 p0, vec2 p1) {
	// define the projection of each pixel between points p0 and p1
	float h = projection	(uv, p0, p1);
	h = clamp(h, 0.0, 1.0);
	
	// Compute the position along the segment using 
	// a linear combination (similar to the form mx + b)
	vec2 p2 = p0 + h * (p1 - p0);
	
	// Calculate the distance between each point (uv) 
	// and the closest point p2 on the segment. 
	return distance(p2, uv);
}


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
	// --------------------------------
	
	// 2. Specular Effect
	vec4 specular_color_main = texture(TEXTURE, UV);
	float time = TIME/specular_speed;
	float offset = fract(time) * 3.0 - 1.5;
	float offset_mask = ceil(sin(time * PI)) + 0.00001; //  alternates between 1.0 and 0.0
	offset *= offset_mask; // so the segment stops moving every other cycle. 
	
	vec2 p0 = vec2(0.5 + offset, 0.8); 
	vec2 p1 = vec2(0.5 + offset, 0.2); 
	
	vec2 uv = vec2(UV.x, 1.0 - UV.y); // Invert V coord
	uv += specular_color_main.b;
	float specular = segment_sd(uv, p0, p1);
	specular = smoothstep(specular_strength, 0.1, specular);
	specular *= offset_mask;
	
	vec3 specular_color = vec3(specular) * specular_colour;
	specular_color_main.rgb += specular_color;
	specular_color_main.rgb = clamp(specular_color_main.rgb, 0.0, 1.0);
	
	COLOR = specular_color_main;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
