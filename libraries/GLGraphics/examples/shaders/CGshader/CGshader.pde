// Example of Cg shader with GLGraphics.
// It requires the Cg toolkit from NVidia installed on the system:
// http://developer.nvidia.com/object/cg_toolkit.html
// Adapted from Vitamin's shaderlib:
// http://www.pixelnerve.com/processing/libraries/shaderlib/
// More online resources about Cg:
// http://nehe.gamedev.net/data/lessons/lesson.asp?lesson=47
// http://arxiv.org/abs/cs/0302013

import processing.opengl.*;
import codeanticode.glgraphics.*;

GLModel torus;
GLCgShader shader;
float angle;

void setup() {
  size(800, 600, GLConstants.GLGRAPHICS);
  
  torus = createTorus(100, 50, 20, 100, 200, 0, 150, 255, "dark3.jpg");
  
  // Loading diffuse lighting shader.
  shader = new GLCgShader(this, "diffusevert.cg", "diffusefrag.cg");
}

void draw() {
  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();
  
  background(0);  

  lights();
  pointLight(250, 250, 250, 0, 600, 400);  

  // Centering the model in the screen.
  translate(width/2, height/2, 0);  
  
  angle += 0.01;
  rotateY(angle);

  shader.start(); // Enabling shader.
  
  // The parameters of the Cg shader can be set with the methods setTexParameter, 
  // setIntParameter, setFloatParameter, etc., but first the program containing the
  // paramter (either fragment, geometry or fragment) needs to be specified.
  shader.setProgram(GLConstants.FRAGMENT_PROGRAM);
  shader.setTexParameter("decalMap", 0);  
  
  // Also, the modelview-projection matrix from OpenGL must be passed explicitly
  // to the shader using the setModelviewProjectionMatrix() method:
  shader.setProgram(GLConstants.VERTEX_PROGRAM); // The modelview-projection parameter is in the vertex program.
  shader.setModelviewProjectionMatrix("worldViewProj");
  
  // This shader also needs the position of the light in the scene to calculate
  // the diffuse color of the pixels.
  shader.setVecParameter("lightPos", 0, 600, 400);
  
  // Any geometry drawn between the shader's stop() and end() will be 
  // processed by the shader.
  renderer.model(torus);
  
  shader.stop(); // Disabling shader.

  renderer.endGL();  
}