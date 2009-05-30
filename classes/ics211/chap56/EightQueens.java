public class EightQueens {
    private boolean chessBoard[][];
    private final int COLS = 8;
    private final int ROWS = 8;

    EightQueens() {
        chessBoard = new boolean[COLS][ROWS];
    }

    public static void main(String args[]) {
        EightQueens app = new EightQueens();
        app.placeQueen(0);
        app.dump();
    }

    public boolean placeQueen(int col) {
        if (col==COLS) 
            return true;
        else {
            for (int row=0;row<ROWS;row++) {
                if (safePlace(col,row)) {
                    chessBoard[col][row]=true;
                    if (placeQueen(col+1))
                        return true;
                    else
                        chessBoard[col][row]=false;
                }
            }
            return false;
        }
    }

    public void dump() {
        for (int row=0;row<ROWS;row++) {
            for (int col=0;col<COLS;col++)
                if (chessBoard[col][row])
                    System.out.print('*');
                else
                    System.out.print('0');
            System.out.println();
        }
    }

    private boolean safePlace(int col, int row) {
        boolean isSafe=true;
        //check straight left
        for (int colLoop=col-1;colLoop>=0;colLoop--)
            if (chessBoard[colLoop][row]) isSafe=false;
        //check for diag up
        int colPos=col-1;
        int rowPos=row-1;
        while (colPos>=0 && rowPos>=0) {
            if (chessBoard[colPos][rowPos]) {
                isSafe=false;
                break;
            }
            colPos--;
            rowPos--;
        }
        //check for diag down
        colPos=col-1;
        rowPos=row+1;
        while (colPos>=0 && rowPos<ROWS) {
            if (chessBoard[colPos][rowPos]) {
                isSafe=false;
                break;
            }
            colPos--;
            rowPos++;
        }
        return isSafe;
    }

}
