import java.util.LinkedList;
import java.util.Queue;
import java.util.Stack;

public class Node {

    private Node _left;
    private Node _right;
    private int _value;

    public Node(Node left, Node right, int value) {
        _left = left;
        _right = right;
        _value = value;
    }

    public Node getLeft() {return _left;}
    public Node getRight() {return _right;}
    public int getValue() {return _value;}

    public static void rpreorder(Node n) {
        if (n == null) return;
        System.out.println(n.getValue());
        rpreorder(n.getLeft());
        rpreorder(n.getRight());
    }

    public static void ipreorder(Node n) {
        Queue q = new LinkedList();
        q.add(n);
        while (!q.isEmpty()) {
            n = (Node)q.remove();
            System.out.println(n.getValue());
            Node left = n.getLeft();
            Node right = n.getRight();
            if (left != null) q.add(left);
            if (right != null) q.add(right);
        }
    }

    public static void ispreorder(Node n) {
        Stack s = new Stack();
        s.push(n);
        while (!s.isEmpty()) {
            n = (Node)s.pop();
            System.out.println(n.getValue());
            Node right = n.getRight();
            Node left = n.getLeft();
            if (right != null) s.push(right);
            if (left != null) s.push(left);
        }
    }

    public static Node deepestAncestor(Node n, int a, int b) {
        if (n.getValue() < a && n.getValue() < b) {
            return deepestAncestor(n.getRight(), a, b);
        } else if (n.getValue() > a && n.getValue() > b) {
            return deepestAncestor(n.getLeft(), a, b);
        } else {
            return n;
        }
    }

    public static void main(String[] args) {
        Node left = new Node(
                new Node(null, null, 25),
                new Node(null, null, 75), 50);
        Node right = new Node(
                new Node(new Node(null, null, 110), null, 125),
                new Node(null, null, 175), 150);
        Node root = new Node(left, right, 100);
        // ispreorder(root);
        System.out.println(deepestAncestor(root, 110, 175).getValue());
    }

}
