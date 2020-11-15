# ATOM FORCES
First attempt to use GLSL in addition to Processing

# REQUIREMENTS
This algorithm uses Processing as base language, GLSL is used to program the shader. You have to install a Processing library called "Sound", following these steps:
1) open Processing IDE;
2) go to Sketch->Import Library->Add Library;
3) look for "Sound", from Processing Foundation, and install it.

# HOW TO RUN
In order to launch the algorithm, you need to add a track of your choice (.wav format) in "data" folder, and modify a line in "atom_forces.pde" (function "setupAudio()", first line, second parameter passed as a string being the name of the song, specifying ".wav" extension). Also, if you're going to use Visual Studio Code, create a directory called ".vscode" and put in the "task.json" file that you can find in the main directory.
