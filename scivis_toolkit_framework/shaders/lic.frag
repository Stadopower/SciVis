#version 330 core

uniform sampler2D velocityField;  // Velocity field texture (normalized to [0,1]^2)
uniform sampler2D noiseTexture;   // Optional noise texture

uniform int streamlineLength;  // L, number of steps forward and backward
uniform float stepSize;        // Δt, step size for Euler integration

in vec2 texCoordinates;  // Fragment's texture coordinates
out vec4 color;          // Final color output

vec2 inkfield1 = vec2(1/3 , 2/3);   // add (1/4, 0, 0) to color
vec2 inkfield2 = vec2(2/3, 2/3);    // add(0, 1/4, 0) to color
vec2 inkfield3 = vec2(1/2, 1/3);    // add(0, 0, 1/4) to color
float radius = 0.01;
// function to detect if we are in the inkfield or not
bool inInk(vec2 pos, vec2 inkPos)
{
    return length(pos - inkPos) <= radius;
}

void main()
{
    vec2 velocity;
    float noiseValue;
    float magnitude;
    float intensity = 0.0;
    vec3 inkColor = vec3(0.0, 0.0, 0.0);
    // The overall sum of the weights
    float kernelWeightSum = (streamlineLength + 1) * (streamlineLength + 1); // same as (L+1) squared


    // forward trace
    vec2 tempCoords = texCoordinates;
    for (int l = 0; l <= streamlineLength; l++)
    {
        // retrieving the velocity and normalizing it again
        velocity = normalize(texture(velocityField, tempCoords).xy);
        // calculating the weight for l+1
        float weight = (l + 1) / kernelWeightSum;


        magnitude = length(velocity);
        noiseValue = texture(noiseTexture, tempCoords).r;   // noise at current position
        intensity += magnitude * noiseValue * weight;       // accumulating the intensity
        // Check if we are in an inkfield
        if(inInk(tempCoords, inkfield1)){
            inkColor += vec3(1/4,0,0);
        }if(inInk(tempCoords, inkfield2)){
            inkColor += vec3(0,1/4,0);
        }if(inInk(tempCoords, inkfield3)){
            inkColor += vec3(0,0,1/4);
        }

        // stepping one direction forward
        tempCoords += velocity * stepSize;
    }

    // backward trace, start by going to the starting position again
    tempCoords = texCoordinates;
    for (int l = 0; l <= streamlineLength; l++)
    {
        // retrieving the velocity and normalizing it again
        velocity = normalize(texture(velocityField, tempCoords).xy);
        // calculating the weight for l+1
        float weight = (l + 1) / kernelWeightSum;

        magnitude = length(velocity);
        noiseValue = texture(noiseTexture, tempCoords).r;   // noise at current position
        intensity += magnitude * noiseValue * weight;       // accumulating the intensity

        if(inInk(tempCoords, inkfield1)){
            inkColor += vec3(1/4,0,0);
        }if(inInk(tempCoords, inkfield2)){
            inkColor += vec3(0,1/4,0);
        }if(inInk(tempCoords, inkfield3)){
            inkColor += vec3(0,0,1/4);
        }
        // stepping one direction forward
        tempCoords -= velocity * stepSize;
    }
    // Returning the final greyscale color
    color = vec4(vec3(intensity)+inkColor, 1.0);
}
