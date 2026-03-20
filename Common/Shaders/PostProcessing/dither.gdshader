// Based on: https://godotshaders.com/shader/dither-gradient-shader/
shader_type canvas_item;

group_uniforms Textures;
uniform sampler2D dither_tex; // Needs repeat = enable and no filtering
uniform sampler2D colour_tex; // Pallete: the more colour, the less effect the dither has
group_uniforms;


group_uniforms DitherSettings;
uniform int bit_depth; // Lower -> banded appearance
uniform float contrast; // Higher -> darken shadows and brighten highlights.
uniform float offset; // Shifts luminance up or down
uniform int dither_size;
group_uniforms;


void fragment() {
	// Sample the screen texture at the desired output resolution (according to dither_size)
	// this will effectively pixelate the resulting output
	vec2 screen_size = vec2(textureSize(TEXTURE, 0)) / float(dither_size);
	vec2 screen_sample_uv= floor(UV * screen_size) / screen_size;
	vec3 screen_col = texture(TEXTURE, screen_sample_uv).rgb;
	
	// Calculate pixel luminosity
	// See: https://stackoverflow.com/questions/596216/formula-to-determine-perceived-brightness-of-rgb-color
	float lum = (screen_col.r * 0.299) + (screen_col.g * 0.587) + (screen_col.b * 0.114);
	
	// Adjust constrast and offset
	lum = (lum - 0.5 + offset) * contrast + 0.5;
	lum = clamp(lum, 0.0, 1.0);
	
	// Reduce luminosity bit depth to give a more banded visual
	float bits = float(bit_depth);
	lum = floor(lum * bits) / bits;
	
	
	// To support multicolour palettes, we want to dither between the two colours on the palette
	// which are adjacent to the current pixel luminosity.
	// to do this, we need to determine which 'band' lum falls into, calculate the upper and lower
	// bound of that band, then later we will use the dither texture to pick either the upper or 
	// lower colour.
	
	// get the palette texture size mapped so it is 1px high (so the x value however many colour bands there are)
	ivec2 col_size = textureSize(colour_tex, 0);
	col_size /= col_size.y;
	
	float col_x = float(col_size.x) - 1.0; // colour boundaries is 1 less than the number of colour bands
	float col_texel_size = 1.0 / col_x; // the size of one colour boundary
	
	lum = max(lum - 0.00001, 0.0); // makes sure our floor calculation below behaves when lum == 1.0
	float lum_lower = floor(lum * col_x) * col_texel_size;
	float lum_upper = (floor(lum * col_x) + 1.0) * col_texel_size;
	float lum_scaled = lum * col_x - floor(lum * col_x); // calculates where lum lies between the upper and lower bound
	
	
	// Map dither texture onto the screen
	ivec2 noise_size = textureSize(dither_tex, 0);
	vec2 inv_noise_size = vec2(1.0 / float(noise_size.x), 1.0 / float(noise_size.y));
	vec2 noise_uv = UV * inv_noise_size * vec2(float(screen_size.x), float(screen_size.y));
	float threshold = texture(dither_tex, noise_uv).r;
	
	// Adjust the dither slightly so min and max aren't quite at 0.0 and 1.0
	// otherwise we wouldn't get fullly dark and fully light dither patterns at lum 0.0 and 1.0
	threshold = threshold * 0.99 + 0.005;
	
	// The lower lum_scaled is, the fewer pixels will be below the dither threshold, and thus will use the lower bound colour,
	// and vice-versa
	float ramp_val = lum_scaled < threshold ? 0.0f : 1.0f;
	
	// Sample at the lower bound colour if ramp_val is 0.0, upper bound colour if 1.0
	float col_sample = mix(lum_lower, lum_upper, ramp_val);
	vec3 final_col = texture(colour_tex, vec2(col_sample, 0.5)).rgb;
	
	COLOR.rgb = final_col;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
