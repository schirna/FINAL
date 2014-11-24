// Example of GLSL shader implementing fish eye lenses.
// Reference:
// http://pixelsorcery.wordpress.com/2010/07/13/fisheye-vertex-shader/

import processing.opengl.*;
import codeanticode.glgraphics.*;

// It uses proscene for camera handling. Download from here:
// http://code.google.com/p/proscene/
import remixlab.proscene.*;

GLModel torus;
GLTexture tex;
GLSLShader shader;
float angle;
Scene scene;
boolean shaderEnabled = true;

void setup() {
  size(800, 600, GLConstants.GLGRAPHICS);

  torus = createTorus(100, 50, 20, 100, 150, 150, 150, 200, "");  
  
  scene = new Scene(this);
  scene.setRadius(500);
  scene.showAll();
  scene.setAxisIsDrawn(false);
  scene.setGridIsDrawn(false);  
  scene.setHelpIsDrawn(false);  
  scene.disableKeyboardHandling();
  
  shader = new GLSLShader(this, "fishvert.glsl", "fishfrag.glsl");
}

void draw() {
  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();
  
  background(0);  

  lights(); 

  // The light is drawn after applying the translation and
  // rotation trasnformations, so it always shines on the
  // same side of the torus.
  pointLight(250, 250, 250, 0, 1000, 400);   

  if (shaderEnabled) {
    shader.start(); // Enabling shader.
    shader.setVecUniform("camera_pos", 0, 0, 0);
  }
  
  for (int i = -5; i < 5; i++)
    for (int j = -5; j < 5; j++) {    
      pushMatrix();
      translate(i * 300, j * 300, 0);
      renderer.model(torus);
      popMatrix();
    }
  
  if (shaderEnabled) {
    shader.stop(); // Disabling shader.
  }

  renderer.endGL();  
}

void keyPressed() {
  shaderEnabled = !shaderEnabled;
}

