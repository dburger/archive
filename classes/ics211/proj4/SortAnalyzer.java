//****************************************************************************************
/*

Programmer:     David J. Burger
Project Number: 4
Course:         ICS 211
Filename:       SortAnalyzer.java

Program Description:  This program analyzes the number of comparisons used by
                      insertionSort and shellSort in sorting a user supplied set of data.
                      
class SortAnalyzer -

    main(String args[]) - The main entry point to the program.  This method will ask the
        user to supply a set of integer values seperated by spaces.  insertionSort and
        shellSort are then both ran on the array of entered values and the number of
        comparisons used is displayed.  To quit the program the user presses <enter> on a
        blank line.
    
    insertionSort(Comparable[] theArray, int n) - This method sorts theArray using the
        insertionSort algorithm.
    
    shellSort(Comparable[] theArray, int n) - This method sorts theArray using the
        shellSort algorithm.

*/
//****************************************************************************************
import java.io.*;
import java.util.StringTokenizer;

public class SortAnalyzer {

    public static int counter;

    //Purpose:  this is the main entry point of SortAnalyzer
    //Preconditions:  none
    //Postconditions:  the user supplied data is sorted by insertionSort and shellSort
    //    and the number of comparisons needed to sort the data is returned
    public static void main(String args[]) {
        BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
        String input;
        StringTokenizer st;
        Integer insertionSortValues[];
        Integer shellSortValues[];
        int nextValue;
        int i;        
        System.out.println("***********************************************");
        System.out.println("*                                             *");
        System.out.println("*               Sort Analyzer                 *");
        System.out.println("*                                             *");
        System.out.println("***********************************************\n");
        System.out.println("This program analyzes the number of comparisons");
        System.out.println("needed by insertionSort and shellSort to sort a");
        System.out.println("given set of data.\n");
        System.out.println("Please enter a set of integer values separated");
        System.out.println("by spaces.  To quit the program press <enter>");
        System.out.println("on a blank line.");
        try {
            while (!(input = stdin.readLine()).equals("")) {
                st = new StringTokenizer(input);
                insertionSortValues = new Integer[st.countTokens()];
                shellSortValues = new Integer[st.countTokens()];
                i = 0;
                while (st.hasMoreTokens()) {
                    nextValue = Integer.parseInt(st.nextToken());
                    insertionSortValues[i] = new Integer(nextValue);
                    shellSortValues[i++] = new Integer(nextValue);
                }
                counter = 0;
                insertionSort(insertionSortValues,insertionSortValues.length);
                System.out.println("Number of comparisons for insertionSort:  " + counter);
                counter = 0;
                shellSort(shellSortValues,shellSortValues.length);
                System.out.println("Number of comparisons for shellSort:  " + counter + "\n");
                System.out.println("Please enter a set of integer values separated");
                System.out.println("by spaces.  To quit the program press <enter>");
                System.out.println("on a blank line.");
            }
        } catch (IOException e) {
            System.out.println("An IOException occurred:  " + e.getMessage());
        }
    }

    //Purpose:  sorts the items in an array into ascending order
    //Preconditions:  theArray is an array of n items
    //Postconditions:  theArray is sorted into ascending order
    public static void insertionSort(Comparable[] theArray, int n) {
        for (int unsorted = 1; unsorted < n; ++unsorted) {
                //for the comparison unsorted < n
            counter++;
            Comparable nextItem = theArray[unsorted];
            int loc = unsorted;
            while ((loc > 0) && (theArray[loc-1].compareTo(nextItem) > 0)) {
                    //the two above comparisons
                counter +=2;
                theArray[loc] = theArray[loc-1];
                loc--;
            }  // end while
                //for the terminal comparison of the while loop
            counter++;
            theArray[loc] = nextItem;
        }  // end for
            //for the terminal comparison of the for loop
        counter++;
    }  // end insertionSort

    //Purpose:  sorts the items of an array into ascending order
    //Preconditions:  theArray is an array of n items
    //Postconditions:  theArray is sorted into ascending order
    public static void shellSort(Comparable[] theArray, int n) {
        int loc;
        Comparable nextItem;
        for (int h = n/2; h > 0; h = h/2) {
                //for the h > 0 comparison
            counter++;
            for (int unsorted = h; unsorted < n; ++unsorted) {
                    //for the unsorted < n comparsion
                counter++;
                nextItem = theArray[unsorted];
                loc = unsorted;
                while ((loc >= h) && (theArray[loc-h].compareTo(nextItem) > 0)) {
                        //for the two above comparisons
                    counter +=2;
                    theArray[loc] = theArray[loc-h];
                    loc = loc - h;
                }  // end while
                    //for the terminal while comparison
                counter++;
                theArray[loc] = nextItem;
            }  // end for unsorted
                //for the terminal for comparison
            counter++;
        }  // end fo h
            //for the terminal for comparison
        counter++;
    }  // end shellsort
}
