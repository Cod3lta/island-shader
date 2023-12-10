shader_type canvas_item;

uniform sampler2D heightTex;
uniform sampler2D colorTex;

uniform bool isometricShadows = false;
uniform vec3 sunPos;

uniform float steps = 100.;
const float SHADOW_BRIGHTNESS = .5;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// get height from heightmap
	float height = texture(heightTex, UV).r;
	
	// start pos for ray cast
	vec3 p = vec3(UV, height);
	vec3 stepDir;
	if (isometricShadows) {
		stepDir = sunPos / steps;
	} else {
		stepDir = (sunPos - p) / steps;
	}
	float inShadow = 0.;
	
	for (float i = 0.; i < steps; i++) {
		//step towards the sun
		p += stepDir;
		// check land height at new location
		if (texture(heightTex, p.xy).r > p.z) {
			// we're in the shadow
			inShadow = 1.;
			break;
		}
		// check if we're already above the highest terrain level
		if (p.z > 1.0) {
			break;
		}
	}
	
	vec4 color = texture(colorTex, UV);
	vec4 shadowColor = vec4(color.rgb * SHADOW_BRIGHTNESS, color.a);
	
	COLOR = mix(color, shadowColor, inShadow);
}