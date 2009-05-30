import java.io.*;

public class ABBTester {

    public static boolean isL(String str) {
        if (str.length()<3)
            return false;
        else if(str.length()==3)
            return (str.equals("ABB"));        
        else {
            if ((str.charAt(0)=='A') &&
                (str.substring(str.length()-2,str.length()).equals("BB")))
                return isL(str.substring(1,str.length()-2));                
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
