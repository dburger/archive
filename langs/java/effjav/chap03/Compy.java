public class Compy implements Comparable<Compy> {

    private int _val;

    public Compy(int val) {_val = val;}

    @Override
    public int compareTo(Compy other) {
        return _val - other._val;
    }

    public static void main(String[] args) {
        Compy c1 = new Compy(1);
        Compy c2 = new Compy(2);
        System.out.println("comparing " + c1.compareTo(c2));
    }

}
