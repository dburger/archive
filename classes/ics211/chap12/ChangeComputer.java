import java.io.*;
import java.util.*;

public class ChangeComputer {


    public static void main(String args[]) {

        int nPaidDollars, nPaidCents, nPriceDollars, nPriceCents;

        try {
            BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
            System.out.println("Enter -1 to quit");
            System.out.print("Enter the price and paid in the form price$ priceC paid$ paidC:");
            StringTokenizer st = new StringTokenizer(stdin.readLine());
            nPriceDollars = Integer.parseInt(st.nextToken());
            while (nPriceDollars != -1) {
                nPriceCents = Integer.parseInt(st.nextToken());
                nPaidDollars = Integer.parseInt(st.nextToken());
                nPaidCents = Integer.parseInt(st.nextToken());
                System.out.println("Change: " + computeChange(nPriceDollars, nPriceCents, nPaidDollars, nPaidCents));
                System.out.println("-------------------------");
                System.out.print("Enter the price and paid in the form price$ priceC paid$ paidC:");
                st = new StringTokenizer(stdin.readLine());
                nPriceDollars = Integer.parseInt(st.nextToken());
            }
        } catch (IOException e) {
            System.out.println("IOException occurred");
        }
    }

    public static int computeChange(int priceDollars, int priceCents, int paidDollars, int paidCents) {
        //Purpose:  This function computes the change, in cents, due a customer.
        //Preconditions:  The caller of this method passes in the price of the item in priceDollars
        //    and priceCents as well as the amount paid by the customer in paidDollars and 
        //    paidCents where all parameters are valid integers >= 0.
        //Postconditions:  The function returns the change due in cents.  A negative value will
        //    indicate how much more money the customer still owes.

        int totalPriceCents = (priceDollars * 100) + priceCents;
        int totalPaidCents = (paidDollars * 100) + paidCents;

        return (totalPaidCents - totalPriceCents);
    }

}