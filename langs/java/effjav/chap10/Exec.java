import java.util.concurrent.Executors;
import java.util.concurrent.ExecutorService;
/*
  should now think in terms of Runnable and Callable submitted to
  executors - the basic unit IS NO LONGER A THREAD
*/


public class Exec {

    public static void main(String[] args) {
        // ExecutorService executor = Executors.newFixedThreadPool(4);
        ExecutorService executor = Executors.newSingleThreadExecutor();
        executor.execute(new Runnable() {
                public void run() {
                    System.out.println("i'm running ok");
                }
            });
        executor.shutdown();
    }

}
