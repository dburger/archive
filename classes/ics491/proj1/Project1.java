import java.io.*;

public class Project1 {

    private Client clients[] = new Client[9];

    public static void main(String args[]) {
        Project1 proj = new Project1();
    }

    public Project1() {
        for (int i = 0; i < 9; i++) {
            clients[i] = new Client(i + "");
            clients[i].start();
        }
    }

    class Client extends Thread {

        public Client(String id) {
            super(id);
        }

        public void run() {
            double value;
            int msgNum = 0;
            String message, reply;
            while (msgNum < 10) {
		if ((value = Math.random()) < 0.1) {
                    msgNum++;
                    message = "Message " + msgNum + " from client " + getName();
                    System.out.println(getName() + ":Request write:-" + message);
                    Server.write(message);
                    System.out.println(getName() + ":Request write completed");
                } else {
                    System.out.println(getName() + ":Request read");
                    reply = Server.read();
                    System.out.println(getName() + ":Read - " + reply);
                }
            }

        }
    }

}           









