final static int N_ATOMS = 16;
Atom[] atoms;
float[] atomX;
float[] atomY;

// Audio
Audio audio;
final static int B = 128;

// Shader variables
PShader myShader;
PGraphics pg;

void settings()
{
    fullScreen(P2D);
    // size(600, 600, P2D);
}

void setup()
{
    pg = createGraphics(width, height, P2D);
    pg.noSmooth();

    initShader();
    generateAtoms();
    setupAudio();
}

void draw()
{
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
    audio = new Audio(N_ATOMS * 4, "skr.wav");
    audio.cue(230);
    audio.play();
}
void generateAtoms()
{
    atoms = new Atom[N_ATOMS];
    atomX = new float[N_ATOMS];
    atomY = new float[N_ATOMS];
    for(int i = 0; i < N_ATOMS; i++)
        atoms[i] = new Atom(round(random(0, 30)));
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
}