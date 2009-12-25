/*
  provide serialization machinery for free
  ironclad against multiple instatiation
*/

enum Singy {

    INSTANCE;

    public void doit() {
        System.out.println("doint it");
    }

}

public class EnumSingleton {

    public static void main(String[] args) {
        Singy.INSTANCE.doit();
    }

}
