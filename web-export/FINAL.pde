import de.fhpotsdam.unfolding.mapdisplay.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.tiles.*;
import de.fhpotsdam.unfolding.interactions.*;
import de.fhpotsdam.unfolding.ui.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.core.*;
import de.fhpotsdam.unfolding.mapdisplay.shaders.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.texture.*;
import de.fhpotsdam.unfolding.events.*;
import de.fhpotsdam.utils.*;
import de.fhpotsdam.unfolding.providers.*;

//www.openprocessing.org/sketch/52706

import controlP5.*;
ControlP5 myControlX;  //// attractor point X position control
ControlP5 myControlY;  //// attractor point Y position control
ControlP5 myControlS;  //// division constant for distance control
 
 
public float X;
public float Y;
public float S;
public float a;

PImage backgroundMap;

/*float mapGeoLeft   = -125.22;          // Longitude 125 degrees west
float mapGeoRight  =  153.44;          // Longitude 153 degrees east
float mapGeoTop    =   71.89;          // Latitude 72 degrees north.
float mapGeoBottom =  -56.11;          // Latitude 56 degrees south.*/

float mapGeoLeft   = -740321;          // Longitude 125 degrees west
float mapGeoRight  =  -738717;          // Longitude 153 degrees east
float mapGeoTop    =   407961;         // Latitude 72 degrees north.
float mapGeoBottom =   406744;         // Latitude 56 degrees south.
                         
float mapScreenWidth,mapScreenHeight;  // Dimension of map in pixels.
 

de.fhpotsdam.unfolding.Map map;

Table table;




void setup(){
size(600,600);
smooth();
 
myControlX = new ControlP5(this);    ///  X position slider
 
Slider X  = myControlX.addSlider("X",0,400,0,width-150,height-80,100,10);
 
 
myControlY = new ControlP5(this);    ///  Y position slider
 
Slider Y  = myControlY.addSlider("Y",0,500,0,width-150,height-60,100,10);
 
myControlS = new ControlP5(this);    ///  S size slider
 
 
Slider S  = myControlS.addSlider("S",0,100,0,width-150,height-40,100,10);



//
size(800,800);
  smooth();
  noLoop();
  backgroundMap   = loadImage("nyc.png");
  mapScreenWidth  = width;
  mapScreenHeight = height;
  
  String mbtilesPath = "jdbc:sqlite:" + sketchPath("./data/NYC_citibike_97ffee.mbtiles");
  map = new de.fhpotsdam.unfolding.Map(this, 0, 0, width, height, new MBTilesMapProvider(mbtilesPath));
  MapUtils.createDefaultEventDispatcher(this, map);
  map.setZoomRange(2, 8);
  
  table = loadTable("1402_connection.csv", "header");

  println(table.getRowCount() + " total rows in table"); 

  for (TableRow row : table.rows()) {
    
    int a = row.getInt("connections");
    String s = row.getString("start station name");
    String e = row.getString("end station name");
    
    println(s + " (" + e + ") has an ID of " + a);
  }
  
   image(backgroundMap,0,0,mapScreenWidth,mapScreenHeight);
}
 
void draw(){
//background(0);
//map.draw();
 
/*fill(255,0,120);
for(int i = 4;i<40;i +=1){
for(int j = 2;j<60;j+=1){
a = dist(i*10,j*10,X,Y)/S; 
  ellipse(i*10,j*10,a,a);
 
}
}*/
 

  
 // fill(180,120,120);
  strokeWeight(0.5);
  
  for (TableRow row : table.rows()) {
    
    float sla = row.getFloat("start station latitude");
    float slo = row.getFloat("start station longitude");
    float ela = row.getFloat("end station latitude");
    float elo = row.getFloat("end station longitude");
    int c = row.getInt("connections");
    String s = row.getString("start station name");
    String e = row.getString("end station name");
    
  

PVector p = geoToPixel(new PVector(slo,sla));
  noStroke();
  fill(255,0,120);
  ellipse(p.x,p.y,3,3);
p = geoToPixel(new PVector(elo,ela));
  noStroke();
  fill(255,0,120);
  ellipse(p.x,p.y,3,3);
  
 
  
  
  }
}

// Converts screen coordinates into geographical coordinates. 
// Useful for interpreting mouse position.
public PVector pixelToGeo(PVector screenLocation)
{
    return new PVector(mapGeoLeft + (mapGeoRight-mapGeoLeft)*(screenLocation.x)/mapScreenWidth,
                       mapGeoTop - (mapGeoTop-mapGeoBottom)*(screenLocation.y)/mapScreenHeight);
}

// Converts geographical coordinates into screen coordinates.
// Useful for drawing geographically referenced items on screen.
public PVector geoToPixel(PVector geoLocation)
{
    return new PVector(mapScreenWidth*(geoLocation.x-mapGeoLeft)/(mapGeoRight-mapGeoLeft),
                       mapScreenHeight - mapScreenHeight*(geoLocation.y-mapGeoBottom)/(mapGeoTop-mapGeoBottom));
}

/*import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.imageio.ImageIO;

import processing.core.PConstants;
import processing.core.PImage;

/**
 * Loads map tile images from a MBTiles SQLite database.
 * 
 * You need to provide the jdbcConnectionString to connect to the database file. e.g.
 * "./data/my-map.mbtiles"
 * 
 * This class is part of the <a href="http://code.google.com/p/unfolding/">Unfolding</a> map
 * library. See <a href="http://tillnagel.com/2011/06/tilemill-for-processing/">TileMill for
 * Processing</a> for more information.
 */
/*public class MBTilesLoaderUtils {


  protected PImage getAsImage(byte[] bytes) {
    try {
      ByteArrayInputStream bis = new ByteArrayInputStream(bytes);
      BufferedImage bimg = ImageIO.read(bis);
      PImage img = new PImage(bimg.getWidth(), bimg.getHeight(), PConstants.ARGB);
      bimg.getRGB(0, 0, img.width, img.height, img.pixels, 0, img.width);
      img.updatePixels();
      return img;
    } catch (Exception e) {
      System.err.println("Can't create image from buffer");
      e.printStackTrace();
    }
    return null;
  }

}*/

