public class Singleton {

/*
  could front with a getter
  could lazy fronted with a getter
  if serializable need to tweak the readResolve
*/

    public static final Singleton INSTANCE = new Singleton();

    private Singleton() {};

    public void doit() {
        System.out.println("doing");
    }

    public static void main(String[] args) {
        Singleton.INSTANCE.doit();
    }

}
