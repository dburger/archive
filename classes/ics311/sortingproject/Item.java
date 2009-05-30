/**
 * The Item class defines an Object that combines
 * a key, element pair
 * 
 * @author digitalOverflow
 */
public class Item {

    
    private Object key, element;

    /**
     * constructor for an Item
     * 
     * @param k      the key for this Item
     * @param e      the Object for this item
     */
    protected Item(Object k, Object e) {
        key = k;
        element = e;
    }

    /**
     * returns the key for this Item
     * 
     * @return Object = key for this Item
     */
    public Object key() {
        return key;
    }

    /**
     * returns the element for this Item
     * 
     * @return Object = object held in this Item
     */
    public Object element() {
        return element;
    }

    /**
     * sets the key for this Item
     * 
     * @param k      the key for this Item
     */
    public void setKey(Object k) {
        key = k;
    }

    /**
     * sets the element for this Item
     * 
     * @param e      the element for this Item
     */
    public void setElement(Object e) {
        element = e;
    }
}
