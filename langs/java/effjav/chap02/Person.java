// demonstrates some builder

public class Person {

    private final String _name;
    private final int _age;
    private final String _preference;
    private final int _eta;

    public static class Builder {

        // required
        private final String _name;
        private final int _age;

        // optional
        private String _preference = "none";
        private int _eta;

        public Builder(String name, int age) {
            _name = name;
            _age = age;
        }

        public Builder preference(String preference) {
            _preference = preference;
            return this;
        }

        public Builder eta(int eta) {
            _eta = eta;
            return this;
        }

        public Person build() {
            return new Person(this);
        }

    }

    public Person(Builder builder) {
        _name = builder._name;
        _age = builder._age;
        _preference = builder._preference;
        _eta = builder._eta;
    }

    public void sayHello() {
        System.out.println("hello my name is " + _name
                + " my age is " + _age
                + " my preference is " + _preference
                + " my eta is " + _eta);
    }

    public static void main(String[] args) {
        Person.Builder b = new Person.Builder("bob", 80);
        Person p = b.preference("women").eta(5).build();
        p.sayHello();
    }

}
