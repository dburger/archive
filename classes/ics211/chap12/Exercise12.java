public class Exercise12 {

    public static void main(String args[]) {

        recurse(5,3);

    }


    public static void recurse(int x, int y) {
      if (y > 0) {
        ++x;
        --y;
        System.out.println(x + " " + y);
        recurse(x, y);
        System.out.println(x + " " + y);
      }  //end if
    }  //end recurse
}