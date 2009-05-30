import java.io.*;
//uncomment for StringTokenizer
//import java.util.*;

public class mTester {


    public static void main(String args[]) {

        int nInput;
        String sInput;

        try {
            BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
            System.out.println("Enter -1 to quit");
            System.out.print("Enter the value to evaluate:  ");
            //if you need multiple inputs probably use the string tokenizer
            //StringTokenizer st = new StringTokenizer(stdin.readLine());
            sInput = stdin.readLine();
            nInput = Integer.parseInt(sInput);
            while (nInput != -1) {
                System.out.println("Result:  " + m(nInput));
                System.out.println("-------------------------");
                System.out.print("Enter the value to evaluate:  ");
                sInput = stdin.readLine();
                nInput = Integer.parseInt(sInput);
            }
        } catch (IOException e) {
            System.out.println("IOException occurred");
        }
    }

    public static int m(int x) {
        if (x<3)
            return 0;
        else
            return 1 + m(x-1) + m(x-3);
    }

}