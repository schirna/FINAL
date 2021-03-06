/**

 * This package provides classes to facilitate the handling of opengl textures, glsl shaders and 
 * off-screen rendering in Processing.
 * @author Andres Colubri
 * @version 0.9.4
 *
 * Copyright (c) 2008 Andres Colubri
 *
 * This source is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This code is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 * 
 * A copy of the GNU General Public License is available on the World
 * Wide Web at <http://www.gnu.org/copyleft/gpl.html>. You can also
 * obtain it by writing to the Free Software Foundation,
 * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

package codeanticode.glgraphics;

import java.nio.IntBuffer;

import javax.media.opengl.*;

import processing.core.PApplet;

/**
 * @invisible This class encapsulates a Framebuffer object (FBO) and some
 *            associated functionality.
 */
public class GLFramebufferObject {
  protected GL gl;
  protected int[] fbo = { 0 };
  protected int numDrawBuffersInUse;
  int[] colorDrawBuffers;
  int[] textureIDs;
  int[] textureTargets;
  
  GLFramebufferObject(GL gl, boolean screenFBO) {
    this.gl = gl;
    numDrawBuffersInUse = 0;
    if (screenFBO)
      fbo[0] = 0;
    else if (GLState.fbosAvailable)
      gl.glGenFramebuffersEXT(1, fbo, 0);
  }

  GLFramebufferObject(GL gl) {
    this.gl = gl;
    numDrawBuffersInUse = 0;
    if (GLState.fbosAvailable)
      gl.glGenFramebuffersEXT(1, fbo, 0);
  }

  protected void finalize() throws Throwable {
    if (fbo[0] != 0) {
      gl.glDeleteFramebuffersEXT(1, fbo, 0);
    }
    super.finalize();
  }

  public int getFramebufferID() {
    return fbo[0];
  }

  public void checkFBO() {
    if (!GLState.fbosAvailable)
      return;

    int stat = gl.glCheckFramebufferStatusEXT(GL.GL_FRAMEBUFFER_EXT);

    // Shouldn't this method should belong to this class instead to GLUtils.
    GLUtils.printFramebufferError(stat);
  }

  void setDrawBuffer(GLTexture tex) {
    setDrawBuffers(new GLTexture[] { tex }, 1);
  }

  void setDrawBuffers(GLTexture[] drawTextures) {
    setDrawBuffers(drawTextures, drawTextures.length);
  }

  void setDrawBuffers(GLTexture[] drawTextures, int n) {
    numDrawBuffersInUse = PApplet.min(n, drawTextures.length);

    colorDrawBuffers = new int[numDrawBuffersInUse];
    textureIDs = new int[numDrawBuffersInUse];
    textureTargets = new int[numDrawBuffersInUse];

    for (int i = 0; i < numDrawBuffersInUse; i++) {
      colorDrawBuffers[i] = GL.GL_COLOR_ATTACHMENT0_EXT + i;
      textureTargets[i] = drawTextures[i].getTextureTarget();
      textureIDs[i] = drawTextures[i].getTextureID();

      gl.glFramebufferTexture2DEXT(GL.GL_FRAMEBUFFER_EXT, colorDrawBuffers[i],
          textureTargets[i], textureIDs[i], 0);
    }

    checkFBO();

    gl.glDrawBuffers(numDrawBuffersInUse, IntBuffer.wrap(colorDrawBuffers));
  }

  void setDrawBuffer(int target, int texid) {
    setDrawBuffers(new int[] { target }, new int[] { texid }, 1);
  }

  void setDrawBuffers(int[] texTargets, int[] texIDs) {
    setDrawBuffers(texTargets, texIDs, PApplet.min(texTargets.length,
        texIDs.length));
  }

  void setDrawBuffers(int[] texTargets, int[] texIDs, int n) {
    numDrawBuffersInUse = PApplet.min(n, texTargets.length, texIDs.length);

    colorDrawBuffers = new int[numDrawBuffersInUse];
    textureIDs = new int[numDrawBuffersInUse];
    textureTargets = new int[numDrawBuffersInUse];

    for (int i = 0; i < numDrawBuffersInUse; i++) {
      colorDrawBuffers[i] = GL.GL_COLOR_ATTACHMENT0_EXT + i;
      textureTargets[i] = texTargets[i];
      textureIDs[i] = texIDs[i];

      gl.glFramebufferTexture2DEXT(GL.GL_FRAMEBUFFER_EXT, colorDrawBuffers[i],
          textureTargets[i], textureIDs[i], 0);
    }

    checkFBO();

    gl.glDrawBuffers(numDrawBuffersInUse, IntBuffer.wrap(colorDrawBuffers));
  }

  void bind() {
    gl.glBindFramebufferEXT(GL.GL_FRAMEBUFFER_EXT, fbo[0]);
  }
}
