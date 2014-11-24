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

import processing.opengl.*;
import codeanticode.glgraphics.*;
import de.bezier.data.sql.*;

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

float mapGeoLeft   = -740297;          // Longitude _ degrees west
float mapGeoRight  =  -738687;          // Longitude _ degrees east
float mapGeoTop    =   407918;         // Latitude _ degrees north.
float mapGeoBottom =   406698;         // Latitude _ degrees south.

float mapScreenWidth, mapScreenHeight;  // Dimension of map in pixels.


UnfoldingMap map;


Table table;

void setup() {
  size(600, 600);
  smooth();

  myControlX = new ControlP5(this);    ///  X position slider

  Slider X  = myControlX.addSlider("X", 0, 400, 0, width-150, height-80, 100, 10);


  myControlY = new ControlP5(this);    ///  Y position slider

  Slider Y  = myControlY.addSlider("Y", 0, 500, 0, width-150, height-60, 100, 10);

  myControlS = new ControlP5(this);    ///  S size slider


  Slider S  = myControlS.addSlider("S", 0, 100, 0, width-150, height-40, 100, 10);

  //
  size(800, 800, GLConstants.GLGRAPHICS);
  smooth();
  noLoop();
  //backgroundMap   = loadImage("nyc.png");
  mapScreenWidth  = width;
  mapScreenHeight = height;
 

  String mbtilesPath = "jdbc:sqlite:" + sketchPath("data/nyc.mbtiles");
  map = new UnfoldingMap(this, 0, 0,  width, height, new MBTilesMapProvider(mbtilesPath));
  MapUtils.createDefaultEventDispatcher(this, map);
  map.setZoomRange(12, 14);

  table = loadTable("1402_connection.csv", "header");

  println(table.getRowCount() + " total rows in table"); 

  for (TableRow row : table.rows ()) {

    int a = row.getInt("connections");
    String s = row.getString("start station name");
    String e = row.getString("end station name");

    println(s + " (" + e + ") has an ID of " + a);
  }

  //image(backgroundMap, 0, 0, mapScreenWidth, mapScreenHeight);
}

void draw() {
  map.draw();

  /*fill(255,0,120);
   for(int i = 4;i<40;i +=1){
   for(int j = 2;j<60;j+=1){
   a = dist(i*10,j*10,X,Y)/S; 
   ellipse(i*10,j*10,a,a);
   
   }
   }*/



  // fill(180,120,120);
  strokeWeight(0.5);

  for (TableRow row : table.rows ()) {

    float sla = row.getFloat("start station latitude");
    float slo = row.getFloat("start station longitude");
    float ela = row.getFloat("end station latitude");
    float elo = row.getFloat("end station longitude");
    int c = row.getInt("connections");
    String s = row.getString("start station name");
    String e = row.getString("end station name");



    PVector st = geoToPixel(new PVector(slo, sla));
    stroke(255, 0, 120);
    strokeWeight(.1);
    fill(255, 0, 120, 50);
    ellipse(st.x, st.y, c/10, c/10);
    PVector en = geoToPixel(new PVector(elo, ela));
    stroke(255, 0, 120);
    strokeWeight(.1);
    fill(0, 0, 255, 50);
    ellipse(en.x, en.y, c/10, c/10);
   if (c>16){strokeWeight(c/10);
   stroke(0, 15);
    line(st.x, st.y, en.x, en.y);} 
    
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

