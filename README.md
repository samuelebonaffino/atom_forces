# atom_forces
First attempt to use GLSL in addition to Processing

# Requirements
This algorithm uses Processing as base language, GLSL is used to program the shader. You have to install a Processing library called "Sound", following these steps:

1) open Processing IDE;
2) go to Sketch->Import Library->Add Library;
3) look for "Sound", from Processing Foundation, and install it.

In order to launch the algorithm, you need to add a track of your choice (.wav format) in "data" folder, and modify a line in "atom_forces.pde" (function "setupAudio()", first line, second parameter passed as a string being the name of the song, specifying ".wav" extension).
