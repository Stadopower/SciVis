#version 330 core
// scalarData_customcolormap fragment shader
in float value;
uniform vec3 colorMapColors[3];
out vec4 color;
void main()
{
    float numColors = 3;
    float index = floor(value * numColors);
    color = vec4(colorMapColors[int(index)], 1.0);
}
