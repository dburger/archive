import java.io.*;
import java.util.*;

public class AckerTester {


    public static void main(String args[]) {

        int m;
        int n;

        try {
            BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
            System.out.println("Enter -1 to quit");
            System.out.print("Enter the values to evaluate separated by a space:  ");
            StringTokenizer st = new StringTokenizer(stdin.readLine());
            m = Integer.parseInt(st.nextToken());
            while (m != -1) {
                n = Integer.parseInt(st.nextToken());
                System.out.println("Result:  " + acker(m,n));
                System.out.println("-------------------------");
                System.out.print("Enter the values to evaluate separated by a space:  ");
                st = new StringTokenizer(stdin.readLine());
                m = Integer.parseInt(st.nextToken());
            }
        } catch (IOException e) {
            System.out.println("IOException occurred");
        }
    }

    public static int acker(int m, int n) {
        //Purpose:  To compute Ackermann's function.
        //Preconditions:  m and n are passed to the
        //    function with m and n being integers >= 0
        //Postconditions:  The value of the Ackermann
        //    function with respect to m and n is returned.
        if (m==0)
            return n+1;
        else if(n==0)
            return acker(m-1,1);
        else
            return acker(m-1,acker(m,n-1));
    }


}