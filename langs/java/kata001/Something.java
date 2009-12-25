public class Something {

    public static void visitNested(Tree t, Node n) {
        String result = t.toString() + " (";
        Enumeration e = n.enumeration();
        while (e.hasMoreElements()) {
            result += visitNested(t, e.nextElement());
            if (e.hasMoreElements()) result += ", ";
        }
        return result + " )";
    }

    public static void totalSize(Tree t, Node n) {
        Enumeration e = n.children().enumeration();
        int sum = 0;
        while (e.hasMoreElements()) {
            Node c = e.nextElement();
            sum += totalSize(t, c);
        }
        return sum + ((Directory)n).size();
    }

    public static void main(String[] args) {
    }

}
