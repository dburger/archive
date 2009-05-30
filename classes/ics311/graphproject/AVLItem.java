public class AVLItem extends Item {

    int height;

    /**
     * constructor for AVLItem
     * 
     * @param k      the key for this AVLItem
     * @param e      the Object for this AVLItem
     * @param h      the height of this AVLItem
     */
    AVLItem(Object k, Object e,int h) {
        super(k,e);
        height = h;
    }

    /**
     * returns the height for this AVLItem
     * 
     * @return int = height of AVLItem
     */
    public int height() {
        return height;
    }

    /**
     * sets the height for this AVLItem
     * 
     * @param h      the height for this AVLItem
     * @return the previous height of this AVLItem
     */
    public int setHeight(int h) {
        int oldHeight = height;
        height = h;
        return oldHeight;
    }

}
