#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER

// UNIFORMS
// uniform float u_time;
uniform vec2  u_resolution;
uniform float u_amp;
uniform int   u_num_atoms;
uniform float u_atom_x[16];
uniform float u_atom_y[16];

// PROTOTYPES
float dist(float x1, float y1, float x2, float y2);
float force(float d, float f);
vec3 showAtoms(float d, vec2 p, float atomX[16], float atomY[16]);
float thresholdAmplitude(float amplitude, float threshold);

void main()
{
    vec2 p = gl_FragCoord.xy / u_resolution.xy;
    float atomX[16];
    float atomY[16];

    // Normalize between 0.0 and 1.0 atoms coordinates
    for(int i = 0; i < u_num_atoms; i++)
    {
        atomX[i] = u_atom_x[i] / u_resolution.x;
        atomY[i] = u_atom_y[i] / u_resolution.y;
    }

    // Calculate forces
    float f = 0.0;
    float d = 0.0;
    for(int i = 0; i < u_num_atoms; i++)
    {
        d = dist(p.x, p.y, atomX[i], atomY[i]);
        f = force(d, f);
    }

    // float c = sin(f * 10.0);
    float amp = pow(u_amp, 6);
    float c = sin(f * amp * 50.0);
    
    // Colour
    // vec3 cl = vec3(1.5-c, f/5.0, f);
    vec3 cl = vec3(c, c, c);
    // cl = showAtoms(p, d, atomX, atomY);

    // gl_FragColor = vec4(cl, 1.0);
    gl_FragColor = vec4(cl, f/5.0);
}

// FUNCTIONS
float dist(float x1, float y1, float x2, float y2)
{
    float dx = x2 - x1;
    float dy = y2 - y1;
    float d = pow(dx, 2.0) + pow(dy, 2.0);
    return pow(d, 0.5);
}
float force(float d, float f)
{
    f += exp(-pow(d * 8.0, 2.0)) / 1.0;
    return f;
}
vec3 showAtoms(float d, vec2 p, float atomX[16], float atomY[16])
{
    vec3 cl = vec3(0.0);
    for(int i = 0; i < u_num_atoms; i++)
    {
        d = dist(p.x, p.y, atomX[i], atomY[i]);
        if(d < 0.005)
            cl = vec3(1.0, 1.0, 0);
    }
    return cl;
}
float thresholdAmplitude(float amplitude, float threshold)
{
    if(amplitude < threshold)
        return 0;
    return amplitude;
}