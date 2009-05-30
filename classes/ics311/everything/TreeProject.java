import java.util.Random;

public class TreeProject {


    public static void main(String args[]) {

        Random r = new Random();
        IntegerComparator C = new IntegerComparator();
    
    
        LinkedSequence sortedSeq = new LinkedSequence();
        LinkedSequence unsortedSeq = new LinkedSequence();
    
        SimpleAVLTree sortedAVLTree = new SimpleAVLTree(C);
        SimpleBinarySearchTree sortedBSTTree = new SimpleBinarySearchTree(C);
        SimpleAVLTree unsortedAVLTree = new SimpleAVLTree(C);               
        SimpleBinarySearchTree unsortedBSTTree = new SimpleBinarySearchTree(C);
    
        for(int index=0; index < 10000; index++) {
            Integer i = new Integer(r.nextInt()*Integer.MAX_VALUE);
            sortedSeq.insertLast(i);
            unsortedSeq.insertLast(i);
        }
    
        bubbleSort2(sortedSeq);
        
        Object obj;
        Position pos = unsortedSeq.first(); 
        long l = System.currentTimeMillis();
        obj = pos.element();
        unsortedBSTTree.insertItem(obj, obj);
        while (pos!=unsortedSeq.last()) {
            pos = unsortedSeq.after(pos);
            obj = pos.element();
            unsortedBSTTree.insertItem(obj, obj);
        }
        System.out.println("Unsorted BST insert:  " + (System.currentTimeMillis() - l) + " milliseconds");
    
        pos = sortedSeq.first(); 
        l = System.currentTimeMillis();
        obj = pos.element();
        sortedBSTTree.insertItem(obj, obj);
        while (pos!=sortedSeq.last()) {
            pos = sortedSeq.after(pos);
            obj = pos.element();
            sortedBSTTree.insertItem(obj, obj);
        }
        System.out.println("Sorted BST insert:  " + (System.currentTimeMillis() - l) + " milliseconds");
    
        pos = unsortedSeq.first(); 
        l = System.currentTimeMillis();
        obj = pos.element();
        unsortedAVLTree.insertItem(obj, obj);
        while (pos!=unsortedSeq.last()) {
            pos = unsortedSeq.after(pos);
            obj = pos.element();
            unsortedAVLTree.insertItem(obj, obj);
        }
        System.out.println("Unsorted AVL insert:  " + (System.currentTimeMillis() - l) + " milliseconds");
    
        pos = sortedSeq.first(); 
        l = System.currentTimeMillis();
        obj = pos.element();
        sortedAVLTree.insertItem(obj, obj);
        while (pos!=sortedSeq.last()) {
            pos = sortedSeq.after(pos);
            obj = pos.element();
            sortedAVLTree.insertItem(obj, obj);
        }
        System.out.println("Sorted AVL insert:  " + (System.currentTimeMillis() - l) + " milliseconds");
    
        System.out.println("");
    
        pos = sortedSeq.first(); 
        l = System.currentTimeMillis();
        Object found = unsortedBSTTree.findElement(pos.element());
        if (found==unsortedBSTTree.NO_SUCH_KEY)
            System.out.println("problem");
        while(pos!=sortedSeq.last()) {
            pos = sortedSeq.after(pos);
            found = unsortedBSTTree.findElement(pos.element());
            if (found==unsortedBSTTree.NO_SUCH_KEY)
                System.out.println("problem");
        }
        System.out.println("Unsorted BST find:  " + (System.currentTimeMillis() - l) + " milliseconds");
    
        pos = sortedSeq.first(); 
        l = System.currentTimeMillis();
        found = sortedBSTTree.findElement(pos.element());
        if (found==sortedBSTTree.NO_SUCH_KEY)
            System.out.println("problem");
        while(pos!=sortedSeq.last()) {
            pos = sortedSeq.after(pos);
            found = sortedBSTTree.findElement(pos.element());
            if (found==sortedBSTTree.NO_SUCH_KEY)
                System.out.println("problem");
        }
        System.out.println("Sorted BST find:  " + (System.currentTimeMillis() - l) + " milliseconds");
    
        pos = sortedSeq.first(); 
        l = System.currentTimeMillis();
        found = unsortedAVLTree.findElement(pos.element());
        if (found==unsortedAVLTree.NO_SUCH_KEY)
            System.out.println("problem");
        while(pos!=sortedSeq.last()) {
            pos = sortedSeq.after(pos);
            found = unsortedAVLTree.findElement(pos.element());
            if (found==unsortedAVLTree.NO_SUCH_KEY)
                System.out.println("problem");
        }
        System.out.println("Unsorted AVL find:  " + (System.currentTimeMillis() - l) + " milliseconds");
    
        pos = sortedSeq.first(); 
        l = System.currentTimeMillis();
        found = sortedAVLTree.findElement(pos.element());
        if (found==sortedAVLTree.NO_SUCH_KEY)
            System.out.println("problem");
        while(pos!=sortedSeq.last()) {
            pos = sortedSeq.after(pos);
            found = sortedAVLTree.findElement(pos.element());
            if (found==sortedAVLTree.NO_SUCH_KEY)
                System.out.println("problem");
        }
        System.out.println("Sorted AVL find:  " + (System.currentTimeMillis() - l) + " milliseconds");
    
    }



    /**
     * positional based bubble sort
     * 
     * @param S      the Sequence to sort
     */
    public static void bubbleSort2(Sequence S) {
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
}
