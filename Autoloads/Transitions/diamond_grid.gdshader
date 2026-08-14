shader_type canvas_item;

uniform vec4 start_color = vec4(0, 0, 0, 0);
uniform vec4 end_color = vec4(1, 1, 1, 1);
uniform float progress : hint_range(0.0, 1.0) = 0.0;


// Size of each diamond, in pixels.
uniform float diamondPixelSize = 10.0;

void fragment() {
	float xFraction = fract(FRAGCOORD.x / diamondPixelSize);
	float yFraction = fract(FRAGCOORD.y / diamondPixelSize);
	float xDistance = abs(xFraction - 0.5);
	float yDistance = abs(yFraction - 0.5);
	if (xDistance + yDistance + UV.x + UV.y > progress * 4.0) {
		//discard;
		COLOR = start_color;
	} else {
		COLOR = end_color;
	}
}