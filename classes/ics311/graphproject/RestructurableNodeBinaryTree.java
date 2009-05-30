public class RestructurableNodeBinaryTree extends LinkedBinaryTree {

    /**
     * rebalances the tree according to AVL properties
     * 
     * @param p      grandchild of node z that has an AVL imbalance
     * @return restructuring of the subtree rooted at z with balance restored
     */
    public Position restructure(Position p) {
        //naming convention for nodes as given in
        //Goodrich and Tamassia and demonstrated on
        //p. 268
        Node x = (Node)p;
        Node y = x.getParent();
        Node z = y.getParent();
        Node a, b, c, t0, t1, t2, t3;

        if (z.getRight()==y && y.getRight()==x) {
            //a in Goodrich and Tamassia p. 270
            a = z;
            b = y;
            c = x;
            t0 = a.getLeft();
            t1 = b.getLeft();
            t2 = c.getLeft();
            t3 = c.getRight();
        } else if(z.getLeft()==y && y.getLeft()==x) {
            //b in Goodrich and Tamassia p. 270
            a = x;
            b = y;
            c = z;
            t0 = a.getLeft();
            t1 = a.getRight();
            t2 = b.getRight();
            t3 = c.getRight();
        } else if(z.getRight()==y && y.getLeft()==x) {
            //c in Goodrich and Tamassia p. 270
            a = z;
            b = x;
            c = y;
            t0 = a.getLeft();
            t1 = b.getLeft();
            t2 = b.getRight();
            t3 = c.getRight();
        } else {//if(z.getLeft()==y && y.getRight()==x) {
            //d in Goodrich and Tamassia p. 270
            a = y;
            b = x;
            c = z;
            t0 = a.getLeft();
            t1 = b.getLeft();
            t2 = b.getRight();
            t3 = c.getRight();
        }
        //if z was the root, b must become the root
        if (isRoot(z))
            setRoot(b);
        else  //set z's parent to point down at b
            if (z.getParent().getRight()==z)
                z.getParent().setRight(b);
            else
                z.getParent().setLeft(b);


        //if z was the root, then this is ok
        //will make parent of b null
        b.setParent(z.getParent());
        b.setLeft(a);
        b.setRight(c);
        a.setLeft(t0);
        a.setRight(t1);
        a.setParent(b);
        c.setLeft(t2);
        c.setRight(t3);
        c.setParent(b);
        t0.setParent(a);
        t1.setParent(a);
        t2.setParent(c);
        t3.setParent(c);

        return b;
    }
}