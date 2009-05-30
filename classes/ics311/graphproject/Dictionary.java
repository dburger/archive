public interface Dictionary {

    /**
     * returns the number of Items
     * 
     * @return int = number of Items
     */
    public int size();

    /**
     * returns true if empty, false otherwise
     * 
     * @return boolean = true if empty false otherwise
     */
    public boolean isEmpty();

    /**
     * returns the element for the Item with key k or NO_SUCH_KEY if doesn't exist
     * 
     * @param k      the key of the Item to locate
     * @return Object = element with key k or NO_SUCH_KEY if doesn't exist
     */
    public Object findElement(Object k);

    /**
     * returns an Enumeration of all Items with key k
     * 
     * @param k      the key of the Items to return an Enumeration of
     * @return Enumeration = elements with key k
     */
    //public Enumeration findAllElements(Object k);

    /**
     * insert an element with key k and element e
     * 
     * @param k      key for item
     * @param e      object for item
     */
    public void insertItem(Object k,Object e);

    /**
     * removes the Item with key k
     * 
     * @param k      key of item to remove
     * @return Object = element of Item removed or NO_SUCH_KEY if doesn't exist
     */
    public Object remove(Object k);

    /**
     * removes all items with key k
     * 
     * @param k      the key of the items to remove
     * @return Enumeration = enumeration of items removed
     */
    //public Enumeration removeAll(Object k);

}
