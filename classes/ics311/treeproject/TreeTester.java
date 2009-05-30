import java.applet.*;
import java.awt.*;
import java.awt.event.*;
import java.util.Random;

public class TreeTester extends Applet implements ActionListener {

    private final int MIN_INT = 0;
    private final int MAX_INT = 10000;

    private LinkedSequence unsortedSeq;
    private LinkedSequence sortedSeq;

    IntegerComparator C = new IntegerComparator();

    CheckboxGroup cbgTreeType = new CheckboxGroup();
    CheckboxGroup cbgInsertType = new CheckboxGroup();
    CheckboxGroup cbgSearchType = new CheckboxGroup();

    Checkbox cbAVLTree = new Checkbox("AVLTree",cbgTreeType,true);
    Checkbox cbBSTTree = new Checkbox("BSTTree",cbgTreeType,false);

    Checkbox cbSorted = new Checkbox("Sorted Data",cbgInsertType,true);
    Checkbox cbUnsorted = new Checkbox("Unsorted Data",cbgInsertType,false);

    Label lblNumberOfIntegers = new Label("Number of integers to sort:");

    TextField txtNumberOfIntegers = new TextField("1000",10);

    Button cmdInsert = new Button("TimeInsert");
    Button cmdSearch = new Button("TimeSearch");
    Button cmdGenerateNewData = new Button("Generate New Data");
    Label lblStatus = new Label("               IDLE               ");


    /**
     * initialization for applet, sets up the ui
     */
    public void init() {
        add(cbAVLTree);
        add(cbBSTTree);
        add(new Label("-------------------------------"));
        add(cbSorted);
        add(cbUnsorted);
        add(lblNumberOfIntegers);
        add(txtNumberOfIntegers);
        add(cmdInsert);
        add(cmdSearch);
        add(cmdGenerateNewData);
        cmdInsert.setEnabled(false);
        cmdSearch.setEnabled(false);
        cmdInsert.addActionListener(this);
        cmdSearch.addActionListener(this);
        cmdGenerateNewData.addActionListener(this);
        lblStatus.setAlignment(Label.CENTER);
        add(lblStatus);
    }


    /**
     * Invoked when an action occurs.
     */
    public void actionPerformed(ActionEvent e) {
        if (e.getSource()==cmdInsert)
            runInsert();
        else if (e.getSource()==cmdSearch)
            runSearch();
        else if (e.getSource()==cmdGenerateNewData)
            generateNewData();
    }

    /**
     * runs the insertion of items
     */
    private void runInsert() {
        SimpleBinarySearchTree T;
        Sequence S;
        if (cbBSTTree.getState()==true)
            T = new SimpleBinarySearchTree(C);
        else //if(cbAVLTree.getState()==true)
            T = new SimpleAVLTree(C);

        try {
            int numElements = Integer.parseInt(txtNumberOfIntegers.getText());
            if (numElements<MIN_INT || numElements>MAX_INT)
                throw new NumberFormatException();
            else {
                if (cbSorted.getState()==true) {    //generate sorted numbers
                    S = sortedSeq;
                } //end if
                else {
                    S = unsortedSeq;
                } //end else

                lblStatus.setText("INSERTING");
                long l = System.currentTimeMillis();
                Position pos = S.first();
                for (int i=0;i<numElements;i++) {
                    Object obj = pos.element();
                    T.insertItem(obj, obj);
                    pos = S.after(pos);
                }
                lblStatus.setText((System.currentTimeMillis() - l) + " milliseconds");
            }
        } catch (NumberFormatException e) {
            lblStatus.setText("ILLEGAL INPUT (0-10000)");
        }
    } //end runInsert

    /**
     * runs the search for items
     */
    private void runSearch() {
        SimpleBinarySearchTree T;
        Sequence S;
        if (cbAVLTree.getState()==true)
            T = new SimpleAVLTree(C);
        else //if(cbBSTTree.getState()==true)
            T = new SimpleBinarySearchTree(C);

        try {
            int numElements = Integer.parseInt(txtNumberOfIntegers.getText());
            if (numElements<MIN_INT || numElements>MAX_INT)
                throw new NumberFormatException();
            else {
                if (cbSorted.getState()==true) {    //generate sorted numbers
                    S = sortedSeq;
                } //end if
                else {
                    S = unsortedSeq;
                } //end else

                lblStatus.setText("INSERTING");
                Position pos = S.first();
                for (int i=0;i<numElements;i++) {
                    Object obj = pos.element();
                    T.insertItem(obj, obj);
                    pos = S.after(pos);
                }

                lblStatus.setText("SEARCHING");
                long l = System.currentTimeMillis();
                pos = S.first();
                for (int i=0;i<numElements;i++) {
                    Object found = T.findElement(pos.element());
                    pos = S.after(pos);
                }
                lblStatus.setText((System.currentTimeMillis() - l) + " milliseconds");
            }
        } catch (NumberFormatException e) {
            lblStatus.setText("ILLEGAL INPUT (0-10000)");
        }
    } //end runSearch

    private void generateNewData() {
        cmdInsert.setEnabled(false);
        cmdSearch.setEnabled(false);
        cmdGenerateNewData.setEnabled(false);
        unsortedSeq = new LinkedSequence();
        sortedSeq = new LinkedSequence();
        Random r = new Random();;
        lblStatus.setText("         Generating Data          ");
        for (int numElements=0;numElements<MAX_INT;numElements++) {    //generate the random numbers
            Integer newInteger = new Integer((int)(MAX_INT*r.nextDouble()));
            unsortedSeq.insertLast(newInteger);
            sortedSeq.insertLast(newInteger);
        }  //end for
        bubbleSort2(sortedSeq);
        cmdInsert.setEnabled(true);
        cmdSearch.setEnabled(true);
        cmdGenerateNewData.setEnabled(true);
        lblStatus.setText("               IDLE               ");
    }

    /**
     * positional based bubble sort
     * 
     * @param S      the Sequence to sort
     */
    private void bubbleSort2(Sequence S) {
        int n = S.size();
        Position prec, succ;

        for (int i=0;i<n;i++) {
            prec = S.first();
            for (int j=0;j<n-i;j++) {
                succ = S.after(prec);
                if (((Integer)prec.element()).intValue() > ((Integer)succ.element()).intValue())
                    S.swap(prec,succ);
                else
                    prec = succ;
            }
        }
    }

} //end Class TreeTester

