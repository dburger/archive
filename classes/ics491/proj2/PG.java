import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
   /**********************************************************************
    * Test harness for ICS491 - Project 2 - Prime number pipeline        *
    * Requires two command line arguments :-                             *
    *     1. Upper limit of prime candidates tried.                      *
    *     2. Delay in milliseconds between each message pass.            *
    * Passes self reference and thread number to primes when creating    *
    * them.                                                              *
    * Three methods can be called from the prime threads :-              *
    *     1. setValue(int,int) - called once only to show new prime      *
    *     2. setCandidate(int,int) - to show receipt of candidate        *
    *     3. removeCandidate(int) - to expunge the candidate             *
    * Author: P. Martin                                                  *
    * Date:   9/29/02                                                    *
    **********************************************************************/  
public class PG extends JFrame {

  private JTextField [] primes = new JTextField[100];
  private JTextField [] tries  = new JTextField[100];
  private int interval;

  public PG(int delay){
    interval = delay;
    JPanel p = new JPanel();
    int k;
    p.setLayout(new GridLayout(10,20));
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 20; j++) {
        k = 20 * i + j;
        primes[k] = new JTextField(3);
        primes[k].setForeground(Color.red);
        primes[k].setEditable(false);
        p.add(primes[k]);
      }//end for j
      for (int j = 0; j < 20; j++) {
        k = 20 * i + j;
        tries[k] = new JTextField(3);
        tries[k].setEditable(false);
        p.add(tries[k]);
      }//end for j
    }//end for i
    getContentPane().add(p);
    setSize(600,300);
    setResizable(false);
    show();
  } //end PG

  public void processWindowEvent(WindowEvent we){
    if (we.getID() == WindowEvent.WINDOW_CLOSING)
      System.exit(0);
    else
      super.processWindowEvent(we);
  } //end processWindowEvent   

  public void setValue(int index, int val){
    if (index >= 0 && index < 100) primes[index].setText(val+"");
  } //end setValue

  public void setCandidate(int index, int val){
    if (index >= 0 && index < 100) tries[index].setText(val+"");
    try {
      Thread.sleep(interval);
    } //end try
    catch (Exception e) {
    }
  } //end setCandidate

  public void removeCandidate(int index){
    if (index >= 0 && index < 100) tries[index].setText("");
  } //end removeCandidate    

  public static void main(String[] args){
    int delay = 500;     //default interval between message passes
    int limit;
    if (args.length < 1) {
      System.err.println("Usage: java PG limit [interval]");
      System.exit(-1);
    } //end if
    limit = Integer.parseInt(args[0]);    
    if (args.length == 2) delay = Integer.parseInt(args[1]);
    PG pg = new PG(delay);
    Prime first = new Prime(2,pg,0);  //create first prime number thread   
    first.start();
    for (int i = 3; i <= limit; i++)
      first.pass(i);
    first.pass(-1);  //dispaly primes and close down    
  } //end main

} //end PG
