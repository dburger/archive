import java.io.*;
import java.util.*;

public class IntegerBackwards {


    public static void main(String args[]) {

        String sInput;
        int nInput;
        try {

            BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
            System.out.println("Enter -1 to quit");
            System.out.print("Enter an integer:  ");
            sInput = stdin.readLine();
            while (!sInput.equals("-1")) {
                nInput = Integer.parseInt(sInput);
                System.out.print("The integer backwards is:  ");
                writeIntegerBackwards(nInput);
                //System.out.println(Acker(1,2));
                System.out.println();
                System.out.print("Enter an integer:  ");
                sInput = stdin.readLine();
            }
        } catch (IOException e) {
            System.out.println("IOException occurred");
        }
    }

    public static void writeIntegerBackwards(int n) {
        //Purpose:  The purpose of this method is to write a positive integer backwards.
        //Preconditions:  The method is passed a valid integer >= 0.
        //Postconditions:  The integer is written out backwards.
        if (n<10)
            System.out.println(n);
        else {
            //find out what the right most digit is
            int rightDigit = (n % 10);
            //write that digit out to the screen
            System.out.print(rightDigit);
            //and now call the function again with the right most digit chopped off
            writeIntegerBackwards(n / 10);
        }
    }

    public static void writeIntegerBackwardsHard(int n) {

        if (n < 10) {
            System.out.print(n);
        } else {
            int i = -1;

            while (Math.pow(10,i+1) < n) {
                i++;
            }

            int nLeadingDigit = n / (int)Math.pow(10,i);

            writeIntegerBackwards(n - (int)(nLeadingDigit * Math.pow(10,i)));
            System.out.print(nLeadingDigit);
        }
    }

    public static void writeIntegerBackwardsEasy(int n) {
        //Purpose:  This method writes an integer backwards.
        //Precondition:  n, and integer >=0 is passed to
        //    this method.
        //Postcondition:  The integer is outputted to the
        //    to the screen with digits in reverse order.
        if (n < 10) {
            System.out.println(n);
        } else {
            String s = String.valueOf(n);
            System.out.print(s.charAt(s.length() -1));
            //call recursively with the last digit chopped off
            writeIntegerBackwardsEasy(Integer.parseInt(s.substring(0,s.length() - 1)));
        }
    }

}