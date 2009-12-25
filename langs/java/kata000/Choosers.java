import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class Choosers {

    private static class Elbow {
        private static enum Next {L, R};

        private Next _next;
        Integer _left = null;
        Integer _right = null;

        public Elbow(String spec) {
            String[] parts = spec.split(" ");
            _next = Next.valueOf(parts[0]);
            if (!"X".equals(parts[1])) _left = new Integer(parts[1]);
            if (!"X".equals(parts[2])) _right = new Integer(parts[2]);
        }

        public void flip() {
            _next = (_next == Next.L) ? Next.R : Next.L;
        }

        public Integer next() {
            return (_next == Next.L) ? _left : _right;
        }

        public String toString() {
            String left = (_left == null) ? "X" : _left.toString();
            String right = (_right == null) ? "X" : _right.toString();
            return _next.toString() + ":" + left + ":" + right;
        }

    }

    public int length(String[] game, int start) {
        List<Elbow> elbows = new ArrayList<Elbow>();
        Set<String> visited = new HashSet<String>();
        for (String spec: game) {
            elbows.add(new Elbow(spec));
        }
        int choosers = 0;
        Integer pos = new Integer(start);
        while (pos != null) {
            Elbow elbow = elbows.get(pos.intValue());
            pos = elbow.next();
            String siggy = elbow.toString();
            if (visited.contains(siggy)) {
                return -1;
            } else {
                visited.add(elbow.toString());
            }
            elbow.flip();
            choosers++;
        }
        return choosers;
    }

    public static void main(String[] args) {
        Choosers c = new Choosers();
        System.out.println("found to be: "
                + c.length(new String[] {"L 0 0"}, 0));
    }

}
