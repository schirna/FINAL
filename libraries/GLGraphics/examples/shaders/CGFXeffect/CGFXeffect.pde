// Example of CgFX effect with GLGraphics.
// It requires the Cg toolkit from NVidia installed on the system:
// http://developer.nvidia.com/object/cg_toolkit.html
//
// Adapted from Vitamin's shaderlib:
// http://www.pixelnerve.com/processing/libraries/shaderlib/
//
// More online resources about CgFX:
// http://http.developer.nvidia.com/CgTutorial/cg_tutorial_appendix_c.html
// FX composer is a visual editor for CgFX effects.
// http://developer.nvidia.com/object/fx_composer_home.html
// And here a library of CgFX effects:
// http://developer.download.nvidia.com/shaderlibrary/webpages/cgfx_shaders.html
//
// Note: Not really tested, right now I don't have the PC hardware to test this example,
// and for some unknown reason it crashes on OSX. It seems that running CgFX effects
// from plain openGL (or from jogl for that matter) is tricky:
// http://buza.mitplw.com/blog/?p=194

import processing.opengl.*;
import codeanticode.glgraphics.*;

GLModel torus;
GLTexture tex;
GLCgFXEffect fx;
float angle;
float timer;

void setup() {
  size(800, 600, GLConstants.GLGRAPHICS);
  
  tex = new GLTexture(this, "dark3.jpg");
  torus = createTorus(100, 50, 20, 100, 200, 0, 150, 255, tex);
  
  // CgFX effect implementing vertex animation using Perlin noise.
  fx = new GLCgFXEffect(this, "vbomb.cgfx");
  
  // Simpler CgFX effects if you want to try out:
  //fx = new GLCgFXEffect(this, "simple_texture.cgfx"); 
  //fx = new GLCgFXEffect(this, "simple_notexture.cgfx");  
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

  fx.start(); // Enabling CgFX effect.
  
  // Setting the parameters of the effect:
  fx.setModelviewMatrix("gWvpXf");
  fx.setTexParameter("gGradeTex", tex);  
  fx.setFloatParameter("gTimer", timer);    
    
  // Setting the parameters of the effect:
  //fx.setTexParameter("ColorSampler", tex);
  //fx.setModelviewProjectionMatrixBySemantic("WORLDVIEWPROJECTION", GLConstants.IDENTITY_MATRIX);
  //fx.setModelviewMatrixBySemantic("MODELVIEWMATRIX", GLConstants.IDENTITY_MATRIX);

  // Setting technique and pass.  
  fx.setTechnique("Main");
  
  boolean pass = fx.selectFirstPass();
  while (pass) {
    fx.setSelectedPass();
  
    // Any geometry drawn between the effect's stop() and end() will be 
    // processed by the effect.
    renderer.model(torus);
  
    fx.resetSelectedPass();
    pass = fx.selectNextPass();
  }
  
  fx.stop(); // Disabling CgFX effect.
  timer += 0.003;
  renderer.endGL();  
}