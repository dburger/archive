import java.io.*;
//uncomment for StringTokenizer
//import java.util.*;

public class RecurrenceRelationTester {


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
                System.out.println("Result:  " + recurrenceRelation(nInput));
                System.out.println("-------------------------");
                System.out.print("Enter the value to evaluate:  ");
                sInput = stdin.readLine();
                nInput = Integer.parseInt(sInput);
            }
        } catch (IOException e) {
            System.out.println("IOException occurred");
        }
    }

    public static int recurrenceRelation(int n) {
        //Purpose:  This method computes the recurrence
        //    relation described on p 101 of our class
        //    book.
        //Preconditions:  n is an integer > 0 (value at
        //    0 was not defined)
        //Postconditions:  The value specified by the
        //    recurrence relation will be returned.
        int temp;
        int prevResults[] = new int[5];
        //the cases n < 6 are by definition
        if (n<6) {
            if (n<4)
                return 1;
            else if (n==4)
                return 3;
            else
                return 5;
        } else {
            //greater than 6, so we keep track of the
            //previous five in an area with
            //prevResults[0] being 5 previous values ago
            //and prevResults[4] being the last value
            prevResults[0] = 1;
            prevResults[1] = 1;
            prevResults[2] = 1;
            prevResults[3] = 3;
            prevResults[4] = 5;

            int i = 6;

            //now loop up to our value keeping track
            //of the previous 5
            while (i<=n) {
                temp = prevResults[0];
                for (int k=0;k<4;k++)
                    prevResults[k] = prevResults[k+1];
                prevResults[4] += 3*temp;
                i++;
            }
            return prevResults[4];
        }
    }
}