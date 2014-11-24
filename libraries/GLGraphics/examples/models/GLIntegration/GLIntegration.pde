// Example showing the integration of GLGraphics, proscene and 
// plain OpenGL. 

import processing.opengl.*;
import codeanticode.glgraphics.*;

// Proscene library for camera handling. Download from here:
// http://code.google.com/p/proscene/
import remixlab.proscene.*;

// This import is needed to use OpenGL directly.
import javax.media.opengl.*;

GLModel cube;
Scene scene;

void setup() {
  size(640, 480, GLConstants.GLGRAPHICS);
  
  scene = new Scene(this);
  scene.setRadius(200);
  scene.showAll();
  scene.setAxisIsDrawn(false);
  scene.setGridIsDrawn(false);  
  scene.setHelpIsDrawn(false);    
 
  cube = new GLModel(this, 8, QUADS, GLModel.STATIC);
  
  cube.beginUpdateVertices();
  // Face 1:
  cube.updateVertex(0, -100, -100, 100);
  cube.updateVertex(1, 100, -100, 100);
  cube.updateVertex(2, 100, 100, 100);
  cube.updateVertex(3, -100, 100, 100);
  // Face 2:
  cube.updateVertex(4, -100, -100, -100);
  cube.updateVertex(5, 100, -100, -100);
  cube.updateVertex(6, 100, 100, -100);
  cube.updateVertex(7, -100, 100, -100);
  cube.endUpdateVertices();
  
  cube.initColors();
  cube.beginUpdateColors();
  // Face 1:  
  cube.updateColor(0, 200, 50, 50, 100);
  cube.updateColor(1, 200, 50, 50, 100);
  cube.updateColor(2, 200, 50, 50, 100);
  cube.updateColor(3, 200, 50, 50, 100);
  // Face 2:  
  cube.updateColor(4, 50, 200, 50, 100);
  cube.updateColor(5, 50, 200, 50, 100);
  cube.updateColor(6, 50, 200, 50, 100);
  cube.updateColor(7, 50, 200, 50, 100);    
  cube.endUpdateColors();
}

void draw() {
  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();
  
  // We get the gl object contained in the GLGraphics renderer.
  GL gl = renderer.gl;

  // Now we can do direct calls to OpenGL:
  gl.glEnable(GL.GL_BLEND);
  gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE);
 
  // Disabling depth masking to properly render a semitransparent
  // object without using depth sorting.
  gl.glDepthMask(false);  
  renderer.model(cube);
  gl.glDepthMask(true);
  
  renderer.endGL();    
}
