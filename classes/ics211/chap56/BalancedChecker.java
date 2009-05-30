import StackReferenceBased;
import java.io.*;

public class BalancedChecker {
    
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
                System.out.println("Result:  " + isBalanced(sInput));
                System.out.println("-------------------------");
                System.out.print("Enter the value to evaluate:  ");
                sInput = stdin.readLine();
            }
        } catch (IOException e) {
            System.out.println("IOException occurred");
        }
    }

    //Purpose:  to determine if a string has balanced braces with
    //    the delimiters (), [], and {}.
    //Preconditions:  a String s is passed to the method.
    //Postconditions:  if the String s is balanced true is returned
    //    otherwise, false is returned.
    public static boolean isBalanced(String s) {
        Character ch;
        Character topChar;
        StackReferenceBased stack = new StackReferenceBased();
        boolean balancedSoFar = true;
        int i = 0;
        while (balancedSoFar && i < s.length()) {
            ch = new Character(s.charAt(i));
            i++;
            if (ch.charValue()=='{' || ch.charValue()=='(' || ch.charValue()=='[')
                stack.push(ch);
            else if (ch.charValue()=='}')
                if (!stack.isEmpty()) {
                    topChar = (Character)stack.pop();
                    if (topChar.charValue()!='{')
                        balancedSoFar = false;
                } else
                    balancedSoFar = false;
            else if (ch.charValue()==')')
                if (!stack.isEmpty()) {
                    topChar = (Character)stack.pop();
                    if (topChar.charValue()!='(')
                        balancedSoFar = false;
                } else
                    balancedSoFar = false;
            else if (ch.charValue()==']')
                if (!stack.isEmpty()) {
                    topChar = (Character)stack.pop();
                    if (topChar.charValue()!='[')
                        balancedSoFar = false;
                } else
                    balancedSoFar = false;
        }
        return (balancedSoFar && stack.isEmpty());
    }
}
