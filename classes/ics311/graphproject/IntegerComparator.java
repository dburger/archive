public class IntegerComparator implements Comparator {

    /**
     * determines if Object a is less than Object b
     * 
     * @param a      first Object
     * @param b      second Object
     * @return boolean = true if a < b false otherwise
     */
    public boolean isLessThan(Object a, Object b) {
        //NOTE:   it should be this:
        //return ((Integer)a).compareTo((Integer)b) < 0;
        //but the Microsoft JVM has a problem with it
        return ((Integer)a).intValue() < ((Integer)b).intValue();
    }

    /**
     * determines if Object a is greater than or equal to Object b
     * 
     * @param a      first Object
     * @param b      second Object
     * @return boolean = true if a>= b, false otherwise
     */
    public boolean isGreaterThanOrEqualTo(Object a, Object b) {
        return isEqualTo(a,b) || isGreaterThan(a,b);
    }

    /**
     * determines if Object a is less than or equal to Object b
     * 
     * @param a      first Object
     * @param b      second Object
     * @return boolean = true if a <= b, false otherwise
     */
    public boolean isLessThanOrEqualTo(Object a, Object b) {
        return isEqualTo(a,b) || isLessThan(a,b);
    }

    /**
     * determines if Object a is a valid comparable object for the comparator
     * 
     * @param a      Object to determine if comparable
     * @return boolean = true if object is valid for comparator, false otherwise
     */
    public boolean isComparable(Object a) {
        return (a instanceof Integer);
    }

    /**
     * determines if Object a = Object b
     * 
     * @param a      first Object
     * @param b      second Object
     * @return boolean = true if a = b, false otherwise
     */
    public boolean isEqualTo(Object a, Object b) {
        //NOTE:   it should be this:
        //return ((Integer)a).equals((Integer)b);
        //but the Microsoft JVM has a problem with it
        return ((Integer)a).intValue() == ((Integer)b).intValue();
    }

    /**
     * determine if Object a is greater than Object b
     * 
     * @param a      first Object
     * @param b      second Object
     * @return boolean = true if a > b false otherwise
     */
    public boolean isGreaterThan(Object a, Object b) {
        //NOTE:   it should be this:
        //return ((Integer)a).compareTo((Integer)b) > 0;
        //but the Microsoft JVM has a problem with it
        return ((Integer)a).intValue() > ((Integer)b).intValue();
    }
}
