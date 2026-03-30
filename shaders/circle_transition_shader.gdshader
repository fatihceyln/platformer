shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	float aspect_ratio = SCREEN_PIXEL_SIZE.y / max(SCREEN_PIXEL_SIZE.x, 1e-5);
	vec2 centered_uv = UV - 0.5;
	centered_uv.x *= aspect_ratio;
	float distance_to_center = length(centered_uv);
	vec2 corner_top_left = vec2(-0.5 * aspect_ratio, -0.5);
	vec2 corner_top_right = vec2(0.5 * aspect_ratio, -0.5);
	vec2 corner_bottom_left = vec2(-0.5 * aspect_ratio, 0.5);
	vec2 corner_bottom_right = vec2(0.5 * aspect_ratio, 0.5);
	float max_radius = max(max(length(corner_top_left), length(corner_top_right)), max(length(corner_bottom_left), length(corner_bottom_right)));
	float edge = progress * max_radius;
	float mask = 1.0 - step(edge, distance_to_center);
	COLOR = vec4(COLOR.rgb, COLOR.a * mask);
}
