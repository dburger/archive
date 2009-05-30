import java.io.*;

public class ABCDTester {

    public static boolean isL(String str) {
        switch (str.length()) {
            case 0:
                return false;
            case 1:
                return (str.charAt(0)=='A' || str.charAt(0)=='B');
            default:
                if (str.charAt(0)=='C' || str.charAt(0)=='D')
                    return isL(str.substring(1));
                else
                    return false;
        }
    }
            
    public static void main(String args[]) {
        String sInput;
        try {
            BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
            System.out.println("Enter -1 to quit");
            System.out.print("Enter the value to evaluate:  ");
            //if you need multiple inputs probably use the string tokenizer
            //StringTokenizer st = new StringTokenizer(stdin.readLine());
            sInput = stdin.readLine();
            while (!sInput.equals("-1")) {
                System.out.println("Result:  " + isL(sInput));
                System.out.println("-------------------------");
                System.out.print("Enter the value to evaluate:  ");
                sInput = stdin.readLine();
            }
        } catch (IOException e) {
            System.out.println("IOException occurred");
        }


    }
}
