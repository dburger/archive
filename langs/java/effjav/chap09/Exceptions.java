/*
  use runtime exceptions to indicate programming errors
    can be RuntimeException or Error but general convention to reserve
    Error for JVM errors
*/

class MyException extends RuntimeException {

    public MyException() {super();}

    // remember this bad boy for exception chaining
    public MyException(Throwable cause) {super(cause);}

}

/*
  also the trick of not using an exception but having a conditional
  if (something(allowed)) {
    something.boom(); ...
*/

public class Exceptions {

    public static void main(String[] args) {
        
    }

}


/*
  remember exceptions can store state that can be used later, such as
  lo, hi, and accessed on some kind of out of bounds exception
*/
