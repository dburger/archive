import java.applet.*;
import java.awt.*;
import java.awt.event.*;
import java.util.Random;

public class SequenceTester extends Applet implements ActionListener {

    private static int MIN_INT = 0;
    private static int MAX_INT = 32000;

    CheckboxGroup cbgSequenceType = new CheckboxGroup();
    CheckboxGroup cbgSortType = new CheckboxGroup();

    Checkbox cbArraySequence = new Checkbox("ArraySequence",cbgSequenceType,true);
    Checkbox cbLinkedSequence = new Checkbox("LinkedSequence",cbgSequenceType,false);

    Checkbox cbBubbleSort1 = new Checkbox("bubbleSort1(rank)",cbgSortType,true);
    Checkbox cbBubbleSort2 = new Checkbox("bubbleSort2(positional)",cbgSortType,false);

    Label lblNumberOfIntegers = new Label("Number of integers to sort:");

    TextField txtNumberOfIntegers = new TextField("1000",10);

    Button cmdSort = new Button("Sort");
    Label lblStatus = new Label("               IDLE               ");


    /**
     * initialization for applet, sets up the ui
     */
    public void init() {
        add(cbArraySequence);
        add(cbLinkedSequence);
        add(new Label("-------------------------------"));
        add(cbBubbleSort1);
        add(cbBubbleSort2);
        add(lblNumberOfIntegers);
        add(txtNumberOfIntegers);
        add(cmdSort);
        cmdSort.addActionListener(this);
        lblStatus.setAlignment(Label.CENTER);
        add(lblStatus);
    }

    /**
     * programming to the java 1.02 event standard for
     * backward compatibility with older browsers
     * 
     * @param evt    event object passed by jvm
     * @param obj    object that initiated event passed by jvm
     * @return true if event is handled, false otherwise
     */
    //public boolean action(Event evt, Object obj) {
    //    if (evt.target==cmdSort) {
    //    }
    //    return false;
    //}

    /**
     * Invoked when an action occurs.
     */
    public void actionPerformed(ActionEvent e) {
        if (e.getSource()==cmdSort)
            runSort();
    }

    /**
     * runs the sort
     */
    private void runSort() {
        Sequence S;
        if (cbArraySequence.getState()==true)
            S = new ArraySequence();
        else
            S = new LinkedSequence();

        Random r = new Random();

        try {
            int numIntegers = Integer.parseInt(txtNumberOfIntegers.getText());
            if (numIntegers<MIN_INT || numIntegers>MAX_INT)
                throw new NumberFormatException();
            else {
                //generate the random numbers
                for (;numIntegers>0;numIntegers--) {
                    Integer newInteger = new Integer((int)(MAX_INT*r.nextDouble()));
                    S.insertLast(newInteger);
                }

                lblStatus.setText("WORKING");
                if (cbBubbleSort1.getState()==true) {
                    long l = System.currentTimeMillis();
                    bubbleSort1(S);
                    lblStatus.setText((System.currentTimeMillis() - l) + " milliseconds");
                } else {
                    long l = System.currentTimeMillis();
                    bubbleSort2(S);
                    lblStatus.setText((System.currentTimeMillis() - l) + " milliseconds");
                }
            }
        } catch (NumberFormatException e) {
            lblStatus.setText("ILLEGAL INPUT (0-30000)");
        }
    }

    /**
     * rank based bubble sort
     * 
     * @param S      the Sequence to sort
     */
//    public static void bubbleSort1(Sequence S) {
//        Integer p1, p2;
//        int n = S.size();
//        boolean madeSwaps = true;
//        for (int i=0;i<n-1 && madeSwaps==true;i++)
//            madeSwaps = false;
//            for (int j=1;j<n-1;j++) {
//                if (((Integer)S.atRank(j-1).element()).intValue() > ((Integer)S.atRank(j).element()).intValue()) {
//                    S.swap(S.atRank(j-1),S.atRank(j));
//                    madeSwaps = true;
//                }
//            }
//    }

    public static void bubbleSort1(Sequence S) {
        Integer p1, p2;
        int n = S.size();
        Position prec, succ;
        boolean madeSwaps = true;
        for (int i=0;i<n && madeSwaps;i++) {
            madeSwaps = false;
            for (int j=1;j<n-i;j++) {
                prec = S.atRank(j-1);
                succ = S.atRank(j);
                if (((Integer)prec.element()).intValue() > ((Integer)succ.element()).intValue()) {
                    S.swap(prec, succ);
                    madeSwaps = true;
                }

            }
        }
    }


    /**
     * positional based bubble sort
     * 
     * @param S      the Sequence to sort
     */
    public static void bubbleSort2(Sequence S) {
        int n = S.size();
        Position prec, succ;
        boolean madeSwaps = true;
        for (int i=0;i<n && madeSwaps==true;i++) {
            madeSwaps = false;
            prec = S.first();
            for (int j=0;j<n-i;j++) {
                succ = S.after(prec);
                if (((Integer)prec.element()).intValue() > ((Integer)succ.element()).intValue()) {
                    S.swap(prec,succ);
                    madeSwaps = true;
                } else
                    prec = succ;
            }
        }
    }


}
