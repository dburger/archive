import java.io.*;
import java.util.*;

public class PowerFunctionTester {

    private static int mnMultiplicationsCounter = 0;
    private static int mnRecursionsCounter = 0;

    public static void main(String args[]) {

        int nFunctionChoice;
        long x;
        long n;

        try {
            BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
            System.out.println("Power Function Tester");
            System.out.println("Enter -1 to quit");
            System.out.println("Function (1,2, or 3) the base and the exponent separated by spaces:");
            StringTokenizer st = new StringTokenizer(stdin.readLine());
            nFunctionChoice = Integer.parseInt(st.nextToken());
            while (nFunctionChoice != -1) {
                x = Long.parseLong(st.nextToken());
                n = Long.parseLong(st.nextToken());
                if (nFunctionChoice==1)
                    System.out.println("Result from power1:  " + power1(x,n));
                else if (nFunctionChoice==2)
                    System.out.println("Result from power2:  " + power2(x,n));
                else if (nFunctionChoice==3)
                    System.out.println("Result from power3:  " + power3(x,n));
                else
                    System.out.println("Invalid function choice.");
                System.out.println("nMultiplicationsCounter:  " + mnMultiplicationsCounter);
                //reduce the nRecursionsCounter by one because the first call is not recursive
                System.out.println("nRecursionsCounter:  " + --mnRecursionsCounter);
                mnMultiplicationsCounter = 0;
                mnRecursionsCounter = 0;
                System.out.println("-------------------------");
                System.out.println("Function (1,2, or 3) the base and the exponent separated by spaces:");
                st = new StringTokenizer(stdin.readLine());
                nFunctionChoice = Integer.parseInt(st.nextToken());
            }
        } catch (IOException e) {
            System.out.println("IOException occurred");
        }
    }

    public static long power1(long x, long n) {
        mnRecursionsCounter++;
        int result = 1;
        for (int i=1;i<=n;i++) {
             result *= x;
             mnMultiplicationsCounter++;
        }
        return result;
    }

    public static long power2(long x, long n) {
        mnRecursionsCounter++;
        if (n==0) {
            return 1;
        } else {
            mnMultiplicationsCounter++;
            return x * power2(x, n-1);
        }
    }

    public static long power3(long x, long n) {
        mnRecursionsCounter++;
        if (n==0) {
            return 1;
        } else if ((n % 2)==0) {
            mnMultiplicationsCounter++;
            return power3(x, n/2) * power3(x, n/2);
        } else {
            mnMultiplicationsCounter += 2;
            return x * power3(x, n/2) * power3(x, n/2);
        }
    }
}