import java.util.Set;
import java.util.HashSet;

public class Checkers {

    private String toSpec(int col, int row) {
        return String.format("%d,%d", col, row);
    }

    private boolean contains(String[] pieces, String checkSpec) {
        for (String spec : pieces) {
            if (checkSpec.equals(spec)) return true;
        }
        return false;
    }

    private int computeInternal(String startPos, String[] pieces,
            boolean prevJump) {
        String[] parts = startPos.split(",");
        int col = Integer.parseInt(parts[0]);
        int row = Integer.parseInt(parts[1]);

        if (row == 7) return 0;

        int left = Integer.MAX_VALUE;
        int right = Integer.MAX_VALUE;

        if (col > 0) {
            String leftSpec = toSpec(col - 1, row + 1);
            if (!contains(pieces, leftSpec)) {
                left = 1 + computeInternal(leftSpec, pieces, false);
            } else if (col > 1) {
                String leftJumpSpec = toSpec(col - 2, row + 2);
                if (!contains(pieces, leftJumpSpec)) {
                    left = ((prevJump) ? 0 : 1)
                            + computeInternal(leftJumpSpec, pieces, true);
                }
            }
        }

        if (col < 7) {
            String rightSpec = toSpec(col + 1, row + 1);
            if (!contains(pieces, rightSpec)) {
                right = 1 + computeInternal(rightSpec, pieces, false);
            } else if (col < 6) {
                String rightJumpSpec = toSpec(col + 2, row + 2);
                if (!contains(pieces, rightJumpSpec)) {
                    right = ((prevJump) ? 0 : 1)
                            + computeInternal(rightJumpSpec, pieces, true);
                }
            }
        }

        return Math.min(left, right);
    }

    public int compute(String startPos, String[] pieces) {
        int ret = computeInternal(startPos, pieces, false);
        return (ret == Integer.MAX_VALUE) ? -1 : ret;
    }

}
