public interface Comparator {

    /**
     * determines if Object a is less than Object b
     * 
     * @param a      first Object
     * @param b      second Object
     * @return boolean = true if a < b false otherwise
     */
    public boolean isLessThan(Object a, Object b);

    /**
     * determines if Object a is less than or equal to Object b
     * 
     * @param a      first Object
     * @param b      second Object
     * @return boolean = true if a <= b, false otherwise
     */
    public boolean isLessThanOrEqualTo(Object a, Object b);

    /**
     * determines if Object a = Object b
     * 
     * @param a      first Object
     * @param b      second Object
     * @return boolean = true if a = b, false otherwise
     */
    public boolean isEqualTo(Object a, Object b);

    /**
     * determine if Object a is greater than Object b
     * 
     * @param a      first Object
     * @param b      second Object
     * @return boolean = true if a > b false otherwise
     */
    public boolean isGreaterThan(Object a, Object b);

    /**
     * determines if Object a is greater than or equal to Object b
     * 
     * @param a      first Object
     * @param b      second Object
     * @return boolean = true if a>= b, false otherwise
     */
    public boolean isGreaterThanOrEqualTo(Object a, Object b);

    /**
     * determines if Object a is a valid comparable object for the comparator
     * 
     * @param a      Object to determine if comparable
     * @return boolean = true if object is valid for comparator, false otherwise
     */
    public boolean isComparable(Object a);

}
