#version 330 core
// isolines geometry shader

layout (lines_adjacency) in;
layout (line_strip, max_vertices = 4) out;

uniform bool useInterpolation;
uniform bool ambiguousCaseMidpoint;
uniform float rho;

in VS_OUT
{
    float value;
    int greaterThanRho;
} gs_in[];

void main()
{
    int index = 0;
    if(gs_in[0].greaterThanRho == 1){
        index |= 1;}    //0001
    if(gs_in[1].greaterThanRho == 1){
        index |= 2;}    //0010
    if(gs_in[2].greaterThanRho == 1){
        index |= 8;}    //1000   This is 8 to have it match the cases on the slides makes it a bit more complicated later because 2 and 3 are switched from the slides
    if(gs_in[3].greaterThanRho == 1){
        index |= 4;}    //0100

// in this switch statement compute interpolation for the lines, and the special case either average or asymptotical
if(useInterpolation==false){
    switch(index){
        case 1:    //0001
            // For no interpolation starting at the midpoint
            gl_Position = (gl_in[0].gl_Position + gl_in[1].gl_Position)/2; EmitVertex();
            gl_Position = (gl_in[0].gl_Position + gl_in[2].gl_Position)/2; EmitVertex();
            EndPrimitive();
            break;
        case 2:    //0010
            gl_Position = (gl_in[0].gl_Position + gl_in[1].gl_Position)/2; EmitVertex();
            gl_Position = (gl_in[1].gl_Position + gl_in[3].gl_Position)/2; EmitVertex();
            EndPrimitive();
            break;
        case 3:    //0011
            gl_Position = (gl_in[0].gl_Position + gl_in[2].gl_Position)/2; EmitVertex();
            gl_Position = (gl_in[1].gl_Position + gl_in[3].gl_Position)/2; EmitVertex();
            EndPrimitive();
            break;
        case 4:    //0100
            gl_Position = (gl_in[1].gl_Position + gl_in[3].gl_Position)/2; EmitVertex();
            gl_Position = (gl_in[2].gl_Position + gl_in[3].gl_Position)/2; EmitVertex();
            EndPrimitive();
            break;
        case 5:    //0101 Here check how we handle the ambigous case
            if(ambiguousCaseMidpoint){ // Average of the Vertices for midpoint
                if((gs_in[0].value + gs_in[1].value + gs_in[2].value + gs_in[3].value)/4 < rho){    // Middle point is not in the isoline
                    gl_Position = (gl_in[0].gl_Position + gl_in[2].gl_Position)/2; EmitVertex();
                    gl_Position = (gl_in[2].gl_Position + gl_in[3].gl_Position)/2; EmitVertex();
                    EndPrimitive();
                    gl_Position = (gl_in[0].gl_Position + gl_in[1].gl_Position)/2; EmitVertex();
                    gl_Position = (gl_in[1].gl_Position + gl_in[3].gl_Position)/2; EmitVertex();
                    EndPrimitive();
                }else{
                    gl_Position = (gl_in[0].gl_Position + gl_in[1].gl_Position)/2; EmitVertex();
                    gl_Position = (gl_in[0].gl_Position + gl_in[2].gl_Position)/2; EmitVertex();
                    EndPrimitive();
                    gl_Position = (gl_in[1].gl_Position + gl_in[3].gl_Position)/2; EmitVertex();
                    gl_Position = (gl_in[2].gl_Position + gl_in[3].gl_Position)/2; EmitVertex();
                    EndPrimitive();
                }
            }
            break;
        case 6:    //0110
            gl_Position = (gl_in[0].gl_Position + gl_in[1].gl_Position)/2; EmitVertex();
            gl_Position = (gl_in[2].gl_Position + gl_in[3].gl_Position)/2; EmitVertex();
            EndPrimitive();
            break;
        case 7:    //0111
            gl_Position = (gl_in[2].gl_Position + gl_in[3].gl_Position)/2; EmitVertex();
            gl_Position = (gl_in[0].gl_Position + gl_in[2].gl_Position)/2; EmitVertex();
            EndPrimitive();
            break;
        case 8:    //1000
            gl_Position = (gl_in[2].gl_Position + gl_in[3].gl_Position)/2; EmitVertex();
            gl_Position = (gl_in[0].gl_Position + gl_in[2].gl_Position)/2; EmitVertex();
            EndPrimitive();
            break;
        case 9:
            gl_Position = (gl_in[0].gl_Position + gl_in[1].gl_Position)/2; EmitVertex();
            gl_Position = (gl_in[2].gl_Position + gl_in[3].gl_Position)/2; EmitVertex();
            EndPrimitive();
            break;
        case 10:
            if (ambiguousCaseMidpoint){
                if((gs_in[0].value + gs_in[1].value + gs_in[2].value + gs_in[3].value)/4 < rho){    // Middle point is not in the isoline
                    gl_Position = (gl_in[0].gl_Position + gl_in[2].gl_Position)/2; EmitVertex();
                    gl_Position = (gl_in[2].gl_Position + gl_in[3].gl_Position)/2; EmitVertex();
                    EndPrimitive();
                    gl_Position = (gl_in[0].gl_Position + gl_in[1].gl_Position)/2; EmitVertex();
                    gl_Position = (gl_in[1].gl_Position + gl_in[3].gl_Position)/2; EmitVertex();
                    EndPrimitive();
                }else{
                    gl_Position = (gl_in[0].gl_Position + gl_in[1].gl_Position)/2; EmitVertex();
                    gl_Position = (gl_in[0].gl_Position + gl_in[2].gl_Position)/2; EmitVertex();
                    EndPrimitive();
                    gl_Position = (gl_in[1].gl_Position + gl_in[3].gl_Position)/2; EmitVertex();
                    gl_Position = (gl_in[2].gl_Position + gl_in[3].gl_Position)/2; EmitVertex();
                    EndPrimitive();
                    }
                }
            break;
        case 11:
            gl_Position = (gl_in[1].gl_Position + gl_in[3].gl_Position)/2; EmitVertex();
            gl_Position = (gl_in[2].gl_Position + gl_in[3].gl_Position)/2; EmitVertex();
            EndPrimitive();
            break;
        case 12:
            gl_Position = (gl_in[0].gl_Position + gl_in[2].gl_Position)/2; EmitVertex();
            gl_Position = (gl_in[1].gl_Position + gl_in[3].gl_Position)/2; EmitVertex();
            EndPrimitive();
            break;
        case 13:
            gl_Position = (gl_in[0].gl_Position + gl_in[1].gl_Position)/2; EmitVertex();
            gl_Position = (gl_in[1].gl_Position + gl_in[3].gl_Position)/2; EmitVertex();
            EndPrimitive();
            break;
        case 14:
            gl_Position = (gl_in[0].gl_Position + gl_in[1].gl_Position)/2; EmitVertex();
            gl_Position = (gl_in[0].gl_Position + gl_in[2].gl_Position)/2; EmitVertex();
            EndPrimitive();
            break;
        default:
            break;
    }}
    else{
        switch(index) {
            case 1:    //0001
                gl_Position = ((gs_in[1].value - rho) * gl_in[0].gl_Position + (rho - gs_in[0].value) * gl_in[1].gl_Position) / (gs_in[1].value - gs_in[0].value); EmitVertex();
                gl_Position = ((gs_in[2].value - rho) * gl_in[0].gl_Position + (rho - gs_in[0].value) * gl_in[2].gl_Position) / (gs_in[2].value - gs_in[0].value); EmitVertex();
                EndPrimitive();
                break;
            case 2:    //0010
                gl_Position = ((gs_in[0].value - rho) * gl_in[1].gl_Position + (rho - gs_in[1].value) * gl_in[0].gl_Position) / (gs_in[0].value - gs_in[1].value); EmitVertex();
                gl_Position = ((gs_in[3].value - rho) * gl_in[1].gl_Position + (rho - gs_in[1].value) * gl_in[3].gl_Position) / (gs_in[3].value - gs_in[1].value); EmitVertex();
                EndPrimitive();
                break;
            case 3:    //0011
                gl_Position = ((gs_in[2].value - rho) * gl_in[0].gl_Position + (rho - gs_in[0].value) * gl_in[2].gl_Position) / (gs_in[2].value - gs_in[0].value); EmitVertex();
                gl_Position = ((gs_in[3].value - rho) * gl_in[1].gl_Position + (rho - gs_in[1].value) * gl_in[3].gl_Position) / (gs_in[3].value - gs_in[1].value); EmitVertex();
                EndPrimitive();
                break;
            case 4:    //0100
                gl_Position = ((gs_in[1].value - rho) * gl_in[3].gl_Position + (rho - gs_in[3].value) * gl_in[1].gl_Position) / (gs_in[1].value - gs_in[3].value); EmitVertex();
                gl_Position = ((gs_in[2].value - rho) * gl_in[3].gl_Position + (rho - gs_in[3].value) * gl_in[2].gl_Position) / (gs_in[2].value - gs_in[3].value); EmitVertex();
                EndPrimitive();
                break;
            case 5:    //0101
                if(ambiguousCaseMidpoint) {    // Average of the vertices for midpoint
                    if((gs_in[0].value + gs_in[1].value + gs_in[2].value + gs_in[3].value) / 4 < rho) {    // Middle point is not in the isoline
                        gl_Position = ((gs_in[2].value - rho) * gl_in[0].gl_Position + (rho - gs_in[0].value) * gl_in[2].gl_Position) / (gs_in[2].value - gs_in[0].value); EmitVertex();
                        gl_Position = ((gs_in[2].value - rho) * gl_in[3].gl_Position + (rho - gs_in[3].value) * gl_in[2].gl_Position) / (gs_in[2].value - gs_in[3].value); EmitVertex();
                        EndPrimitive();
                        gl_Position = ((gs_in[1].value - rho) * gl_in[0].gl_Position + (rho - gs_in[0].value) * gl_in[1].gl_Position) / (gs_in[1].value - gs_in[0].value); EmitVertex();
                        gl_Position = ((gs_in[1].value - rho) * gl_in[3].gl_Position + (rho - gs_in[3].value) * gl_in[1].gl_Position) / (gs_in[1].value - gs_in[3].value); EmitVertex();
                        EndPrimitive();
                    } else {
                        gl_Position = ((gs_in[1].value - rho) * gl_in[0].gl_Position + (rho - gs_in[0].value) * gl_in[1].gl_Position) / (gs_in[1].value - gs_in[0].value); EmitVertex();
                        gl_Position = ((gs_in[2].value - rho) * gl_in[0].gl_Position + (rho - gs_in[0].value) * gl_in[2].gl_Position) / (gs_in[2].value - gs_in[0].value); EmitVertex();
                        EndPrimitive();
                        gl_Position = ((gs_in[1].value - rho) * gl_in[3].gl_Position + (rho - gs_in[3].value) * gl_in[1].gl_Position) / (gs_in[1].value - gs_in[3].value); EmitVertex();
                        gl_Position = ((gs_in[2].value - rho) * gl_in[3].gl_Position + (rho - gs_in[3].value) * gl_in[2].gl_Position) / (gs_in[2].value - gs_in[3].value); EmitVertex();
                        EndPrimitive();
                    }
                } else {  // Asymptotic Decider
                if((gs_in[0].value + gs_in[1].value + gs_in[2].value + gs_in[3].value) / 4.0 < rho) {
                    gl_Position = gl_in[0].gl_Position + ((rho - gs_in[0].value) / (gs_in[2].value - gs_in[0].value)) * (gl_in[2].gl_Position - gl_in[0].gl_Position); EmitVertex();
                    gl_Position = gl_in[2].gl_Position + ((rho - gs_in[2].value) / (gs_in[3].value - gs_in[2].value)) * (gl_in[3].gl_Position - gl_in[2].gl_Position); EmitVertex();
                    EndPrimitive();
                    gl_Position = gl_in[0].gl_Position + ((rho - gs_in[0].value) / (gs_in[1].value - gs_in[0].value)) * (gl_in[1].gl_Position - gl_in[0].gl_Position); EmitVertex();
                    gl_Position = gl_in[1].gl_Position + ((rho - gs_in[1].value) / (gs_in[3].value - gs_in[1].value)) * (gl_in[3].gl_Position - gl_in[1].gl_Position); EmitVertex();
                    EndPrimitive();
                } else {
                    gl_Position = gl_in[0].gl_Position + ((rho - gs_in[0].value) / (gs_in[1].value - gs_in[0].value)) * (gl_in[1].gl_Position - gl_in[0].gl_Position); EmitVertex();
                    gl_Position = gl_in[0].gl_Position + ((rho - gs_in[0].value) / (gs_in[2].value - gs_in[0].value)) * (gl_in[2].gl_Position - gl_in[0].gl_Position); EmitVertex();
                    EndPrimitive();
                    gl_Position = gl_in[1].gl_Position + ((rho - gs_in[1].value) / (gs_in[3].value - gs_in[1].value)) * (gl_in[3].gl_Position - gl_in[1].gl_Position); EmitVertex();
                    gl_Position = gl_in[2].gl_Position + ((rho - gs_in[2].value) / (gs_in[3].value - gs_in[2].value)) * (gl_in[3].gl_Position - gl_in[2].gl_Position); EmitVertex();
                    EndPrimitive();
                    }
                }
                break;
            case 6:    //0110
                gl_Position = ((gs_in[0].value - rho) * gl_in[1].gl_Position + (rho - gs_in[1].value) * gl_in[0].gl_Position) / (gs_in[0].value - gs_in[1].value); EmitVertex();
                gl_Position = ((gs_in[2].value - rho) * gl_in[3].gl_Position + (rho - gs_in[3].value) * gl_in[2].gl_Position) / (gs_in[2].value - gs_in[3].value); EmitVertex();
                EndPrimitive();
                break;
            case 7:    //0111
                gl_Position = ((gs_in[2].value - rho) * gl_in[3].gl_Position + (rho - gs_in[3].value) * gl_in[2].gl_Position) / (gs_in[2].value - gs_in[3].value); EmitVertex();
                gl_Position = ((gs_in[2].value - rho) * gl_in[0].gl_Position + (rho - gs_in[0].value) * gl_in[2].gl_Position) / (gs_in[2].value - gs_in[0].value); EmitVertex();
                EndPrimitive();
                break;
            case 8:    //1000
                gl_Position = ((gs_in[3].value - rho) * gl_in[2].gl_Position + (rho - gs_in[2].value) * gl_in[3].gl_Position) / (gs_in[3].value - gs_in[2].value); EmitVertex();
                gl_Position = ((gs_in[0].value - rho) * gl_in[2].gl_Position + (rho - gs_in[2].value) * gl_in[0].gl_Position) / (gs_in[0].value - gs_in[2].value); EmitVertex();
                EndPrimitive();
                break;
            case 9:    //1001
                gl_Position = ((gs_in[1].value - rho) * gl_in[0].gl_Position + (rho - gs_in[0].value) * gl_in[1].gl_Position) / (gs_in[1].value - gs_in[0].value); EmitVertex();
                gl_Position = ((gs_in[3].value - rho) * gl_in[2].gl_Position + (rho - gs_in[2].value) * gl_in[3].gl_Position) / (gs_in[3].value - gs_in[2].value); EmitVertex();
                EndPrimitive();
                break;
            case 10:    //1010
                if(ambiguousCaseMidpoint){
                    if((gs_in[0].value + gs_in[1].value + gs_in[2].value + gs_in[3].value) / 4 < rho) {    // Middle point is not in the isoline
                        gl_Position = ((gs_in[0].value - rho) * gl_in[2].gl_Position + (rho - gs_in[2].value) * gl_in[0].gl_Position) / (gs_in[0].value - gs_in[2].value); EmitVertex();
                        gl_Position = ((gs_in[3].value - rho) * gl_in[2].gl_Position + (rho - gs_in[2].value) * gl_in[3].gl_Position) / (gs_in[3].value - gs_in[2].value); EmitVertex();
                        EndPrimitive();
                        gl_Position = ((gs_in[0].value - rho) * gl_in[1].gl_Position + (rho - gs_in[1].value) * gl_in[0].gl_Position) / (gs_in[0].value - gs_in[1].value); EmitVertex();
                        gl_Position = ((gs_in[3].value - rho) * gl_in[1].gl_Position + (rho - gs_in[1].value) * gl_in[3].gl_Position) / (gs_in[3].value - gs_in[1].value); EmitVertex();
                        EndPrimitive();
                    } else {
                        gl_Position = ((gs_in[0].value - rho) * gl_in[1].gl_Position + (rho - gs_in[1].value) * gl_in[0].gl_Position) / (gs_in[0].value - gs_in[1].value); EmitVertex();
                        gl_Position = ((gs_in[0].value - rho) * gl_in[2].gl_Position + (rho - gs_in[2].value) * gl_in[0].gl_Position) / (gs_in[0].value - gs_in[2].value); EmitVertex();
                        EndPrimitive();
                        gl_Position = ((gs_in[3].value - rho) * gl_in[1].gl_Position + (rho - gs_in[1].value) * gl_in[3].gl_Position) / (gs_in[3].value - gs_in[1].value); EmitVertex();
                        gl_Position = ((gs_in[3].value - rho) * gl_in[2].gl_Position + (rho - gs_in[2].value) * gl_in[3].gl_Position) / (gs_in[3].value - gs_in[2].value); EmitVertex();
                        EndPrimitive();
                    }}else{  // Asymptotic Decider
                    if((gs_in[0].value + gs_in[1].value + gs_in[2].value + gs_in[3].value) / 4.0 < rho) {
                        gl_Position = gl_in[0].gl_Position + ((rho - gs_in[0].value) / (gs_in[2].value - gs_in[0].value)) * (gl_in[2].gl_Position - gl_in[0].gl_Position); EmitVertex();
                        gl_Position = gl_in[2].gl_Position + ((rho - gs_in[2].value) / (gs_in[3].value - gs_in[2].value)) * (gl_in[3].gl_Position - gl_in[2].gl_Position); EmitVertex();
                        EndPrimitive();
                        gl_Position = gl_in[0].gl_Position + ((rho - gs_in[0].value) / (gs_in[1].value - gs_in[0].value)) * (gl_in[1].gl_Position - gl_in[0].gl_Position); EmitVertex();
                        gl_Position = gl_in[1].gl_Position + ((rho - gs_in[1].value) / (gs_in[3].value - gs_in[1].value)) * (gl_in[3].gl_Position - gl_in[1].gl_Position); EmitVertex();
                        EndPrimitive();
                    } else {
                        gl_Position = gl_in[0].gl_Position + ((rho - gs_in[0].value) / (gs_in[1].value - gs_in[0].value)) * (gl_in[1].gl_Position - gl_in[0].gl_Position); EmitVertex();
                        gl_Position = gl_in[0].gl_Position + ((rho - gs_in[0].value) / (gs_in[2].value - gs_in[0].value)) * (gl_in[2].gl_Position - gl_in[0].gl_Position); EmitVertex();
                        EndPrimitive();
                        gl_Position = gl_in[1].gl_Position + ((rho - gs_in[1].value) / (gs_in[3].value - gs_in[1].value)) * (gl_in[3].gl_Position - gl_in[1].gl_Position); EmitVertex();
                        gl_Position = gl_in[2].gl_Position + ((rho - gs_in[2].value) / (gs_in[3].value - gs_in[2].value)) * (gl_in[3].gl_Position - gl_in[2].gl_Position); EmitVertex();
                        EndPrimitive();
                        }
                    }
                break;
            case 11:    //1011
                gl_Position = ((gs_in[3].value - rho) * gl_in[1].gl_Position + (rho - gs_in[1].value) * gl_in[3].gl_Position) / (gs_in[3].value - gs_in[1].value); EmitVertex();
                gl_Position = ((gs_in[3].value - rho) * gl_in[2].gl_Position + (rho - gs_in[2].value) * gl_in[3].gl_Position) / (gs_in[3].value - gs_in[2].value); EmitVertex();
                EndPrimitive();
                break;
            case 12:    //1100
                gl_Position = ((gs_in[0].value - rho) * gl_in[2].gl_Position + (rho - gs_in[2].value) * gl_in[0].gl_Position) / (gs_in[0].value - gs_in[2].value); EmitVertex();
                gl_Position = ((gs_in[1].value - rho) * gl_in[3].gl_Position + (rho - gs_in[3].value) * gl_in[1].gl_Position) / (gs_in[1].value - gs_in[3].value); EmitVertex();
                EndPrimitive();
                break;
            case 13:    //1101
                gl_Position = ((gs_in[1].value - rho) * gl_in[0].gl_Position + (rho - gs_in[0].value) * gl_in[1].gl_Position) / (gs_in[1].value - gs_in[0].value); EmitVertex();
                gl_Position = ((gs_in[1].value - rho) * gl_in[3].gl_Position + (rho - gs_in[3].value) * gl_in[1].gl_Position) / (gs_in[1].value - gs_in[3].value); EmitVertex();
                EndPrimitive();
                break;
            case 14:    //1110
                gl_Position = ((gs_in[0].value - rho) * gl_in[1].gl_Position + (rho - gs_in[1].value) * gl_in[0].gl_Position) / (gs_in[0].value - gs_in[1].value); EmitVertex();
                gl_Position = ((gs_in[0].value - rho) * gl_in[2].gl_Position + (rho - gs_in[2].value) * gl_in[0].gl_Position) / (gs_in[0].value - gs_in[2].value); EmitVertex();
                EndPrimitive();
                break;
            default:
                break;
        }
    }
}
