shader_type canvas_item;


group_uniforms WobblyEffect;
uniform sampler2D flowMap;
uniform float strength;
uniform float speed;
uniform int frames: hint_range(0, 10);
group_uniforms;

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
}


// TEST CLOCK
//void fragment(){
	//float c = clock(TIME);
	//COLOR = vec4( c, c, c, 1);
//}
