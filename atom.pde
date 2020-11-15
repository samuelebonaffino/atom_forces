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
        speed = 0.2;
        dirX = round(random(-1, 1));
        dirY = round(random(-1, 1));
    }

    void draw()
    {
        fill(255, 255, 0, 255);
        ellipse(x, y, 10, 10);
    }
    void updatePos()
    {
        // if(round(random(100)) == 3)
        //     dir = round(random(-1, 1));
        checkBounds();
        x += speed * dirX;
        y += speed * dirY;
    }
    void updatePos(Audio audio)
    {
        // if(round(random(100)) == 3)
        //     dir = round(random(-1, 1));
        checkBounds();
        float f = audio.getFrequency(id, 10);
        float a = audio.getAmplitude(6);
        a = pow(a, 2);
        x += (f + a + speed) * dirX;
        y += (f + a + speed) * dirY;
    }
    void checkBounds()
    {
        if(x < 0 || x > width)
            dirX *= -1;
        if(y < 0 || y > height)
            dirY *= -1;
    }
    int getId()
    {
        return id;
    }
}