shader_type canvas_item;

uniform vec4 tint:source_color=vec4(1,1,1,1);
instance uniform float tint_power: hint_range(0,1) = 1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 tex_col =texture(TEXTURE, UV);

	vec4 colorDifference = vec4(0,0,0,1);
	colorDifference.r = tint.r - tex_col.r;
	colorDifference.g = tint.g - tex_col.g;
	colorDifference.b = tint.b - tex_col.b;

	tex_col.r = tex_col.r + colorDifference.r * tint_power;
	tex_col.g = tex_col.g + colorDifference.g * tint_power;
	tex_col.b = tex_col.b + colorDifference.b * tint_power;

	COLOR = tex_col;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
