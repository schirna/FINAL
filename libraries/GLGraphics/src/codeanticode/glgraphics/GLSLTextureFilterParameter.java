package codeanticode.glgraphics;

import processing.core.PApplet;

/**
 * This class stores the uniform parameter for a texture filter.
 */
public class GLSLTextureFilterParameter extends GLTextureFilterParameter {
  protected GLSLShaderUniform uniform;
  
  public GLSLTextureFilterParameter(PApplet parent, String name, String label,
      int type) {
    super(parent, name, label, type);
    uniform = new GLSLShaderUniform(parent, name, label, type);
  }  
  
  public GLSLTextureFilterParameter(PApplet parent, GLShader shader,
      String name, String label, int type) {
    super(parent, name, label, type);
    uniform = new GLSLShaderUniform(parent, shader, name, label, type);    
  }  
  
  public void setShader(GLShader shader) {
    uniform.setShader(shader);
  }

  /**
   * Returns true or false depending on whether this variable is available for use.
   * @return boolean
   */  
  public boolean available() {
    return uniform.available();
  }
  
  /**
   * Initializes this parameter..
   */
  public void init() {
    uniform.init();
  }

  /**
   * Sets the parameter value when the type is int.
   * 
   * @param value
   *          int
   */
  public void setValue(int value) {
    uniform.setValue(value);  
  }

  /**
   * Sets the parameter value when the type is float.
   * 
   * @param value
   *          float
   */
  public void setValue(float value) {
    uniform.setValue(value);  
  }

  /**
   * Sets the parameter value for any type. When the type is int or float, the
   * first element of the value array is considered.
   * 
   * @param value
   *          float[]
   */
  public void setValue(float[] value) {
    uniform.setValue(value);
  }

  /**
   * Sets the ith value for the parameter (only valid for vec or mat types).
   * 
   * @param int i
   * @param value
   *          float
   */
  public void setValue(int i, float value) {
    uniform.setValue(i, value);
  }

  public void setValue(int i, int j, float value) {
    uniform.setValue(i, j, value);
  }

  /**
   * Copies variable values to shader.
   */
  public void copyToShader() {
    uniform.copyToShader();  
  }

  /**
   * Returns parameter type.
   * 
   * @return int
   */
  int getType() {
    return uniform.getType();
  }

  /**
   * Returns parameter name.
   * 
   * @return String
   */
  public String getName() {
    return uniform.getName();  
  }

  /**
   * Returns parameter label.
   * 
   * @return String
   */
  public String getLabel() {
    return uniform.getLabel();
  }
}
