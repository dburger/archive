import java.util.concurrent.TimeUnit;

public class Volatile {

    // volatile insures that multiple threads see the correct same value
    // could have alternatively used synchronized setters and getters around
    // the value
    private static volatile boolean _stopRequested = false;

    public static void main(String[] args) throws InterruptedException {
        Thread backgroundThread = new Thread(new Runnable() {
                public void run() {
                    int i = 0;
                    while (!_stopRequested) i++;
                    System.out.println("getting out of here with " + i);
                }
            });
        backgroundThread.start();
        // what is this TimeUnit stuff ???
        TimeUnit.SECONDS.sleep(10);
        _stopRequested = true;
    }
}
