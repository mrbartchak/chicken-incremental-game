shader_type canvas_item;
uniform float speed = 2.0;
uniform float height = 10.0;

void vertex() {
    VERTEX.y += round(sin(TIME * speed) * height);
}