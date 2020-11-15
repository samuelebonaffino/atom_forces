import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class atom_forces extends PApplet {

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

public void settings()
{
    fullScreen(P2D);
    // size(600, 600, P2D);
}

public void setup()
{
    pg = createGraphics(width, height, P2D);
    pg.noSmooth();

    initShader();
    generateAtoms();
    setupAudio();
}

public void draw()
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

public void setupAudio()
{
    audio = new Audio(N_ATOMS * 4, "skr.wav");
    audio.cue(230);
    audio.play();
}
public void generateAtoms()
{
    atoms = new Atom[N_ATOMS];
    atomX = new float[N_ATOMS];
    atomY = new float[N_ATOMS];
    for(int i = 0; i < N_ATOMS; i++)
        atoms[i] = new Atom(round(random(0, 30)));
}
public void updateAtoms(Audio audio)
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
public void initShader()
{
    myShader = loadShader("shader.glsl");
    
    // Uniforms
    myShader.set("u_resolution", PApplet.parseFloat(pg.width), PApplet.parseFloat(pg.height));
    myShader.set("u_num_atoms", N_ATOMS);
}
public void updateShader()
{   
    myShader.set("u_atom_x", atomX);
    myShader.set("u_atom_y", atomY);
}
class Atom
{
    int id;
    float x, y;
    float speed;
    int dirX, dirY;

    Atom(int id)
    {
        this.id = id;
        x = random(100, width - 100);
        y = random(100, height - 100);
        // x = width/2;
        // y = height/2;
        // x = map(random(width), 0, width, 0, 1);
        // y = map(random(height), 0, height, 0, 1);
        // speed = random(10);
        speed = 0.5f;
        dirX = round(random(-1, 1));
        dirY = round(random(-1, 1));
    }

    public void draw()
    {
        fill(255, 255, 0, 255);
        ellipse(x, y, 10, 10);
    }
    public void updatePos()
    {
        // if(round(random(100)) == 3)
        //     dir = round(random(-1, 1));
        checkBounds();
        x += speed * dirX;
        y += speed * dirY;
    }
    public void updatePos(Audio audio)
    {
        // if(round(random(100)) == 3)
        //     dir = round(random(-1, 1));
        checkBounds();
        float f = audio.getFrequency(id, 10);
        float a = audio.getAmplitude(5);
        x += (f + a) * dirX;
        y += (f + a) * dirY;
    }
    public void checkBounds()
    {
        if(x < 0 || x > width)
            dirX *= -1;
        if(y < 0 || y > height)
            dirY *= -1;
    }
    public int getId()
    {
        return id;
    }
}


class Audio
{
    // Attributes
    int band;
    String name;
    SoundFile input;
    float[] spectrum;
    FFT fft;
    Amplitude amp;

    // Constructor
    Audio(int band, String name)
    {
        this.band = band;
        this.name = name;

        spectrum = new float[band];

        input = new SoundFile(atom_forces.this, name);
        fft = new FFT(atom_forces.this, band);
        amp = new Amplitude(atom_forces.this);

        fft.input(input);
        amp.input(input);
    }

    // Methods
    public void cue(float time)
    {
        input.cue(time);
    }
    public void play()
    {
        input.play();
    }
    public int getSpectrumID(int index)
    {
        return index % band;
    }
    public float getFrequency(int id)
    {
        if(id >= band)
            id = getSpectrumID(id);
        return spectrum[id];
    }
    public float getFrequency(int id, float mult)
    {
        if(id >= band)
            id = getSpectrumID(id);
        return spectrum[id] * mult;
    }
    public float getAmplitude()
    {
        return amp.analyze();
    }
    public float getAmplitude(float mult)
    {
        return amp.analyze() * mult;
    }
    public void updateSpectrum()
    {
        fft.analyze(spectrum);
    }
    public boolean isPlaying()
    {
        return input.isPlaying();
    }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "atom_forces" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
