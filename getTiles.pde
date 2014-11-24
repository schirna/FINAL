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
