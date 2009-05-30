public class Server {

    private static String message;
    private static ReadWriteLock rwlock = new ReadWriteLock();

    public static void write(String message) {
        Server.rwlock.acquireWriteLock();
        Server.message = message;
        Server.rwlock.releaseWriteLock();
    }

    public static String read() {
        String temp;
        Server.rwlock.acquireReadLock();
        temp = Server.message;
        for (int i = 1; i < 600; i++) System.out.print("r");
        Server.rwlock.releaseReadLock();
        return temp;
    }

}
