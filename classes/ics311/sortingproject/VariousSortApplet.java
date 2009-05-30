import java.applet.*;
import java.awt.*;
import java.awt.event.*;
import java.util.Random;
import java.applet.AudioClip;


public class VariousSortApplet extends Applet implements ActionListener {
    Button cmdSort;
    Choice cboNumItems;
    Label hsResults1, hsResults2, qsResults1, qsResults2,
          msResults1, msResults2;
    AudioClip sound;

    public void init() {

        //COLORS
        setBackground(Color.magenta);
        Color titleColor  = new Color(255,200,00);   //title color, matches site
        Color outerColor  = new Color(102,204,255);  //outer table cells
        Color innerColor  = new Color(204,204,204);  //inner table cells

        GridBagLayout gl = new GridBagLayout();
        setLayout(gl);
        GridBagConstraints gb = new GridBagConstraints();

        // make sure cells are filled
        // ==========================
        gb.fill = GridBagConstraints.BOTH;
    
        // otherwise components huddle in centre
        // of component like a flock of sheep
        // =====================================
        gb.weightx = 1;
        gb.weighty = 1;

        //START - TITLE
        Label title = new Label("Various Sort Applet", Label.CENTER);
        title.setBackground(titleColor);
        title.setFont(new Font("Times",Font.BOLD,18));
        gb.gridx = 0;
        gb.gridy = 0;
        gb.gridheight = 1;
        gb.gridwidth = 4;
        gl.setConstraints(title,gb);
        add(title);
        //END - TITLE


        //START - OUTER TABLE CELLS - LABELS
        Label blank1 = new Label("Sort Method", Label.CENTER);
        blank1.setBackground(outerColor);
        gb.gridx = 0;
        gb.gridy = 1;
        gb.gridheight = 1;
        gb.gridwidth = 1;
        gl.setConstraints(blank1,gb);
        add(blank1);
    
        Label time1 = new Label("Random Data", Label.CENTER);
        time1.setBackground(outerColor);
        gb.gridx = 1;
        gb.gridy = 1;
        gb.gridheight = 1;
        gb.gridwidth = 1;
        gl.setConstraints(time1,gb);
        add(time1);
    
        Label time2 = new Label("Sorted Data", Label.CENTER);
        time2.setBackground(outerColor);
        gb.gridx = 2;
        gb.gridy = 1;
        gb.gridheight = 1;
        gb.gridwidth = 1;
        gl.setConstraints(time2,gb);
        add(time2);
    
        Label heapSort = new Label("heapSort", Label.CENTER);
        heapSort.setBackground(innerColor);
        gb.gridx = 0;
        gb.gridy = 2;
        gb.gridheight = 1;
        gb.gridwidth = 1;
        gl.setConstraints(heapSort,gb);
        add(heapSort);
    
        Label mergeSort = new Label("mergeSort", Label.CENTER);
        mergeSort.setBackground(innerColor);
        gb.gridx = 0;
        gb.gridy = 3;
        gb.gridheight = 1;
        gb.gridwidth = 1;
        gl.setConstraints(mergeSort,gb);
        add(mergeSort);
    
        Label quickSort = new Label("quickSort", Label.CENTER);
        quickSort.setBackground(innerColor);
        gb.gridx = 0;
        gb.gridy = 4;
        gb.gridheight = 1;
        gb.gridwidth = 1;
        gl.setConstraints(quickSort,gb);
        add(quickSort);
        //END - OUTER TABLE CELLS - LABELS


        //START - INNER TABLE CELLS - RESULTS
        hsResults1 = new Label("hsResults1", Label.CENTER);
        hsResults1.setBackground(innerColor);
        gb.gridx = 1;
        gb.gridy = 2;
        gb.gridheight = 1;
        gb.gridwidth = 1;
        gl.setConstraints(hsResults1,gb);
        add(hsResults1);
    
        hsResults2 = new Label("hsResults2", Label.CENTER);
        hsResults2.setBackground(innerColor);
        gb.gridx = 2;
        gb.gridy = 2;
        gb.gridheight = 1;
        gb.gridwidth = 1;
        gl.setConstraints(hsResults2,gb);
        add(hsResults2);
    
        msResults1 = new Label("msResults1", Label.CENTER);
        msResults1.setBackground(innerColor);
        gb.gridx = 1;
        gb.gridy = 3;
        gb.gridheight = 1;
        gb.gridwidth = 1;
        gl.setConstraints(msResults1,gb);
        add(msResults1);
    
        msResults2 = new Label("msResults2", Label.CENTER);
        msResults2.setBackground(innerColor);
        gb.gridx = 2;
        gb.gridy = 3;
        gb.gridheight = 1;
        gb.gridwidth = 1;
        gl.setConstraints(msResults2,gb);
        add(msResults2);
    
        qsResults1 = new Label("qsResults1", Label.CENTER);
        qsResults1.setBackground(innerColor);
        gb.gridx = 1;
        gb.gridy = 4;
        gb.gridheight = 1;
        gb.gridwidth = 1;
        gl.setConstraints(qsResults1,gb);
        add(qsResults1);
    
        qsResults2 = new Label("qsResults2", Label.CENTER);
        qsResults2.setBackground(innerColor);
        gb.gridx = 2;
        gb.gridy = 4;
        gb.gridheight = 1;
        gb.gridwidth = 1;
        gl.setConstraints(qsResults2,gb);
        add(qsResults2);
        //END - INNER TABLE CELLS - RESULTS

        gb.fill = GridBagConstraints.CENTER;

        Label lblNumElts = new Label("Number of Items:", Label.CENTER);
        gb.gridx = 0;
        gb.gridy = 5;
        gb.gridheight = 1;
        gb.gridwidth = 1;
        gl.setConstraints(lblNumElts,gb);
        add(lblNumElts);
        
        cboNumItems = new Choice();
        gb.gridx = 1;
        gb.gridy = 5;
        gb.gridheight = 1;
        gb.gridwidth = 1;
        gl.setConstraints(cboNumItems,gb);
        add(cboNumItems);
        cboNumItems.addItem("10");
        cboNumItems.addItem("100");
        cboNumItems.addItem("1000");
        cboNumItems.addItem("10000");
    
    
        cmdSort = new Button("Run Sorts");
        gb.gridx = 2;
        gb.gridy = 5;
        gb.gridheight = 1;
        gb.gridwidth = 1;
        gl.setConstraints(cmdSort,gb);
        add(cmdSort);
        cmdSort.addActionListener(this);
    
        sound = getAudioClip(getDocumentBase(),"sound16.au");
   
    }

    /**
    * Invoked when an action occurs.
    */
    public void actionPerformed(ActionEvent e) {
        if (e.getSource()==cmdSort)
            runSorts();
    }

    private void runSorts() {
        Color sortColor   = new Color(51,204,102);   //Sorting text Color
        Sequence heapSortSeq  = new LinkedSequence();
        Sequence mergeSortSeq = new LinkedSequence();
        Sequence quickSortSeq = new ArraySequence();
        IntegerComparator ic = new IntegerComparator();

        Random r = new Random();
        int numElements = Integer.parseInt(cboNumItems.getSelectedItem());
        for (int i=0;i<numElements;i++) {
            Integer iRand = new Integer((int)(r.nextDouble()*Integer.MAX_VALUE));
            heapSortSeq.insertFirst(iRand);
            mergeSortSeq.insertFirst(iRand);
            quickSortSeq.insertFirst(iRand);
        }

        SequenceHeapSort heapSort   = new SequenceHeapSort();
        SequenceMergeSort mergeSort = new SequenceMergeSort();
        SequenceQuickSort quickSort = new SequenceQuickSort();
        IntegerComparator IC = new IntegerComparator();

        hsResults1.setForeground(sortColor);
        hsResults1.setText("Sorting...");
        long l = System.currentTimeMillis();
        heapSort.sort(heapSortSeq, IC);
        hsResults1.setText((System.currentTimeMillis() - l) + "");
        sound.play();
        hsResults1.setForeground(Color.red);
        myWait();
        hsResults1.setForeground(Color.black);

        msResults1.setForeground(sortColor);
        msResults1.setText("Sorting...");
        l = System.currentTimeMillis();
        mergeSort.sort(mergeSortSeq, IC);
        msResults1.setText((System.currentTimeMillis() - l) + "");
        sound.play();
        msResults1.setForeground(Color.red);
        myWait();
        msResults1.setForeground(Color.black);

        qsResults1.setForeground(sortColor);
        qsResults1.setText("Sorting...");
        l = System.currentTimeMillis();
        quickSort.sort(quickSortSeq, IC);
        qsResults1.setText((System.currentTimeMillis() - l) + "");
        sound.play();
        qsResults1.setForeground(Color.red);
        myWait();
        qsResults1.setForeground(Color.black);

        hsResults2.setForeground(sortColor);
        hsResults2.setText("Sorting...");
        l = System.currentTimeMillis();
        heapSort.sort(heapSortSeq, IC);
        hsResults2.setText((System.currentTimeMillis() - l) + "");
        sound.play();
        hsResults2.setForeground(Color.red);
        myWait();
        hsResults2.setForeground(Color.black);

        msResults2.setForeground(sortColor);
        msResults2.setText("Sorting...");
        l = System.currentTimeMillis();
        mergeSort.sort(mergeSortSeq, IC);
        msResults2.setText((System.currentTimeMillis() - l) + "");
        sound.play();
        msResults2.setForeground(Color.red);
        myWait();
        msResults2.setForeground(Color.black);

        qsResults2.setForeground(sortColor);
        qsResults2.setText("Sorting...");
        l = System.currentTimeMillis();
        quickSort.sort(quickSortSeq, IC);
        qsResults2.setText((System.currentTimeMillis() - l) + "");
        sound.play();
        qsResults2.setForeground(Color.red);
        myWait();
        qsResults2.setForeground(Color.black);

    }

    private void myWait() {
        try {
            java.lang.Thread.sleep(1000);
        } catch(InterruptedException e) {
            ;
        }
    }

} //end class VariousSortApplet
