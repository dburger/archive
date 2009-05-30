public class Exercise9 {

    private static int nCounter = 0;
    public static int mystery(int n) {
        return search(1,n,n);
    }

    private static int search(int first, int last, int n) {
        int returnValue;
        System.out.println("Enter: first = " + first + " last = " + last);
        int mid = (first + last) / 2;
        if ((mid * mid <=n) && (n < (mid + 1) * (mid + 1))) {
            returnValue = mid;
        }
        else if (mid * mid > n) {
            returnValue = search(first, mid - 1, n);
        }
        else {
            returnValue = search(mid + 1, last, n);
        }
        System.out.println("Leave: first = " + first + " last = " + last);
        return returnValue;
    }  //end search

    public static void main(String args[]) {
        System.out.println(mystery(30));
    }  //end main

}  //end Exercise9