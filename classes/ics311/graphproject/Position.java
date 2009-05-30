/**
 * Represents an abstract position object.  It is held
 * within a container, and holds an element.
 * It must retain references to both.
 * 
 * @author Bruce Harris
 * @version 1.0
 * @see Container
 */
public interface Position {

  /**
   * returns element stored at this position
   *
   * @return Object = element stored here
   */
  public Object element();


  /**
   * return the container holding this position
   * 
   * @return Container = container holding this position
   */
  public Container container();

}
