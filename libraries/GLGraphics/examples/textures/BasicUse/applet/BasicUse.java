import processing.core.*; 
import processing.xml.*; 

import processing.opengl.*; 
import codeanticode.glgraphics.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class BasicUse extends PApplet {

// Basic example of GLTexture and GLTextureFilter.
// By Andres Colubri




public void setup()
{

    size(640, 480, GLConstants.GLGRAPHICS);
//    size(640, 480, OPENGL);    

}

public void draw()
{
    background(0); 
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#DFDFDF", "BasicUse" });
  }
}
