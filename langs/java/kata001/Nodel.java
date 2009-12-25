public class Node<T> {

    private T _content;
    private Node _left;
    private Node _right;

    public Node() {}

    public Node(T content, Node left, Node right) {
        _left = left;
        _right = right;
    }

    public Object setContent(T content) {
        T old = _content;
        _content = content;
        return old;
    }

    public Node setLeft(Node left) {
        Node old = _left;
        _left = left;
        return old;
    }

    public Node setRight(Node right) {
        Node old = _right;
        _right = right;
        return old;
    }

    public Object getContent() {return _content;}

    public Node getLeft() {return _left;}

    public Node getRight() {return _right;}

    public void preOrder(Node node) {
        System.out.println(node.getContent());
        preOrder(node.getLeft());
        preOrder(node.getRight());
    }

    public void inOrder(Node node) {
        if (node == null) return;
        inOrder(node.getLeft());
        System.out.println(node.getContent());
        inOrder(node.getRight());
    }

    public void postOrder(Node node) {
        postOrder(node.getLeft());
        postOrder(node.getRight());
        System.out.println(node.getContent());
    }

    public static void main(String[] args) {
        Node<String> root = new Node<String>();
        Node node = new Node();
    }

}
