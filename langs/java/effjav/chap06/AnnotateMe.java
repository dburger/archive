import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import java.lang.reflect.Method;

// not public here because defined in AnnnotatMe.java
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
@interface Marked {}

/*
  this is an example of how a test framework could use annotations to mark
  test methods
*/

public class AnnotateMe {

    @Marked
    public void banker() {
        System.out.println("banker invoked");
    }

    public void manker() {
        System.out.println("manker invoked");
    }

    public static void main(String[] args) {
        AnnotateMe am = new AnnotateMe();
        Class clazz = am.getClass();
        for (Method m : clazz.getDeclaredMethods()) {
            if (m.isAnnotationPresent(Marked.class)) {
                try {
                    m.invoke(am);
                } catch (Exception exc) {
                    System.out.println("caught an exception");
                    exc.printStackTrace();
                }
            }
        }
    }

}
