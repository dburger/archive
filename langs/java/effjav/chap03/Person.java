/*
  contract for equals
    reflexive, symmetric, transitive, liskov sub. princ., consistency
  override hashCode if override equals, otherwise no play nice with Maps / Sets

  how to:
    use == to test if this
    use instanceof to check correct type
    cast to correct type
    check significant fields


  hashCode
    must consistently return same value
    equal hashCodes for equal objects
*/

public class Person {

    private final String _ssn;

    public Person(String ssn) {
        _ssn = ssn;
    }

    @Override
    public boolean equals(Object other) {
        if (other == this) return true;
        if (!(other instanceof Person)) return false;
        // alternative class based ??? Bloch does not like.
        // if (other == null) return false;
        // if (other.getClass() != getClass()) return false;
        Person otherPerson = (Person)other;
        return _ssn.equals(otherPerson._ssn);
    }

    @Override
    public int hashCode() {
        return _ssn.hashCode();
    }

    public static void main(String[] args) {
        Person p1 = new Person("111");
        Person p2 = new Person("222");
        System.out.println("equals " + p1.equals(p2));
        Person p3 = new Person("111");
        System.out.println("equals " + p1.equals(p3));
        System.out.println(p1.hashCode());
        System.out.println(p2.hashCode());
        System.out.println(p3.hashCode());
    }

}
