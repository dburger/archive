import java.io.*;
import java.util.*;

public class FloorTest {


    public static void main(String args[]) throws IOException {

        int x;
        BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
        StringTokenizer inputLine;
        //initialize
        int result = 0; // will equal floor of sqrt(x)
        int temp1 = 1;
        int temp2 = 1;
        
        //read input
        inputLine = new StringTokenizer(stdin.readLine());
        x = Integer.parseInt(inputLine.nextToken());

        //compute floor
        while (temp1 < x) {
            ++result;
            temp2 += 2;
            temp1 += temp2;
        }

        System.out.println("The floor of the square root of " + x + " is " + result);

    } // end main

}