import StackReferenceBased;

public class StackTester {

    public static void main(String args[]) {
        StackReferenceBased srb = new StackReferenceBased();
        srb.push("party");
        srb.push("all");
        srb.push("the");
        srb.push("time");
        System.out.println("displaying ADT based");
        srb.display();
        System.out.println("displaying ref based");
        srb.displayRefBased();
        System.out.println("isEmpty?" + srb.isEmpty());
    }

}
