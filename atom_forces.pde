final static int N_ATOMS = 16;
Atom[] atoms;
float[] atomX;
float[] atomY;
float time;

// Audio
Audio audio;
final static int B = 128;

// Shader variables
PShader myShader;
PGraphics pg;

void settings()
{
    fullScreen(P2D);
    // size(1920, 1080, P2D);
}

void setup()
{
    // surface.setResizable(true);
    pg = createGraphics(width, height, P2D);
    pg.noSmooth();

    time = 0;

    initShader();
    generateAtoms();
    setupAudio();
}

void draw()
{
    time += 0.001;
    updateAtoms(audio);
    updateShader();
    pg.beginDraw();
    pg.background(0);
    pg.shader(myShader);
    pg.rect(0, 0, pg.width, pg.height);
    pg.endDraw();
    image(pg, 0, 0, width, height);
}

void setupAudio()
{
    audio = new Audio(B, "waaatari.wav");
    audio.cue(190);
    audio.play();
}
void generateAtoms()
{
    atoms = new Atom[N_ATOMS];
    atomX = new float[N_ATOMS];
    atomY = new float[N_ATOMS];
    for(int i = 0; i < N_ATOMS; i++)
        atoms[i] = new Atom(round(random(50, 80)));
}
void updateAtoms(Audio audio)
{
    audio.updateSpectrum();
    for(int i = 0; i < N_ATOMS; i++)
    {
        Atom a = atoms[i];
        a.updatePos(audio);
        //a.draw();
        atomX[i] = a.x;
        atomY[i] = a.y;
    }
}
void initShader()
{
    myShader = loadShader("shader.glsl");
    
    // Uniforms
    myShader.set("u_resolution", float(pg.width), float(pg.height));
    myShader.set("u_num_atoms", N_ATOMS);
}
void updateShader()
{   
    myShader.set("u_atom_x", atomX);
    myShader.set("u_atom_y", atomY);
    myShader.set("u_amp", audio.getAmplitude());
    // myShader.set("u_time", time);
}