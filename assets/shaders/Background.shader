shader_type canvas_item;

uniform int type = 0;

//Function for re-use
float cubicPulseMiddle( float c, float w, float x ){
    x = abs(x - c);
    if( x>w ) return 0.0;
    x /= w;
    return 1.0 - x*x*(3.0-2.0*x);
}

float cubicPulseEdges( float c, float w, float x ){
    x = abs(x - c);
    if( x<w ) return 0.0;
    x /= w;
    return 1.0 - x*x*(3.0-2.0*x);
}

//Shaders algorithims
vec4 both_sides_color(vec2 uv, float time) {
	float color = cubicPulseEdges(0.5,0.2,uv.x);
	vec3 bars = vec3(color)*vec3(0.0,sin(time + 1.0),0.0);
	return vec4(bars, 1.0);
}

vec4 cross_color(vec2 uv, float time) {
	float verticalColor = cubicPulseMiddle(0.5,0.2,uv.x);
    float horizontalColor = cubicPulseMiddle(0.5, 0.2, uv.y);
	
	vec3 colorBlue = vec3(verticalColor)*vec3(0.0,0.0,sin(time + 1.0));
    vec3 colorRed = vec3(horizontalColor)*vec3(sin(time + 1.0),0.0,0.0);
	
	return vec4(colorRed + colorBlue, 1.0);
}

vec4 hollow_square(vec2 uv, float time) {
	float verticalColor = cubicPulseEdges(0.5,0.2,uv.x);
    float horizontalColor = cubicPulseEdges(0.5, 0.2, uv.y);
	
	vec3 colorBlue = vec3(verticalColor)*vec3(0.0,0.0,sin(time + 1.0));
    vec3 colorRed = vec3(horizontalColor)*vec3(sin(time + 1.0),0.0,0.0);
	
	return vec4(colorRed + colorBlue, 1.0);
}

vec4 strafing_pulse(vec2 uv, float time) {
	float color = cubicPulseMiddle(tan(time),0.2,uv.x);
	return vec4(vec3(color) * vec3(0.0, 0.0, 1.0), 1.0);
}

//Shader Functions
void fragment() {
	if(type == 0) {
		COLOR = clamp(both_sides_color(UV, TIME), 0.05, 1.0);
	}
	if(type == 1) {
		COLOR = clamp(cross_color(UV, TIME), 0.05, 1.0);
	}
}