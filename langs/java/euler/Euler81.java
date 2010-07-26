import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.concurrent.ExecutionException;

/**
 * Project euler problem 81.  Demonstrates dynamic programming.
 * http://projecteuler.net/index.php?section=problems&id=81
 */
public class Euler81 {

  /** Memoizer used to store results in an array so don't compute twice. */
  private static void initMemoizer(int[][] m) {
    for (int r = 0; r < m.length; r++) {
      for (int c = 0; c < m[r].length; c++) {
        m[r][c] = -1;
      }
    }
  }

  /** Loads the array, the first row of rows,cols has already been consumed. */
  private static void loadArray(Scanner scanner, int[][] a) {
    String line;
    String[] parts;
    int row = 0;
    while (scanner.hasNext()) {
      line = scanner.next();
      parts = line.split(",");
      for (int col = 0; col < parts.length; col++) {
        a[row][col] = Integer.parseInt(parts[col]);
      }
      row++;
    }
  }

  /** Calculate the min for x, y. */
  private static int calculate(int[][] a, int [][] m, int row, int col) {
    if (m[row][col] != -1) {
      return m[row][col];
    }
    if (row == 0 && col == 0) {
      m[row][col] = a[row][col];
    } else if (row == 0) {
      m[row][col] = a[row][col] + calculate(a, m, row, col - 1);
    } else if (col == 0) {
      m[row][col] = a[row][col] + calculate(a, m, row - 1, col);
    } else {
      m[row][col] = a[row][col]
          + Math.min(calculate(a, m, row - 1, col), calculate(a, m, row, col - 1));
    }
    return m[row][col];
  }

  /**
   * Pass filename to operate on.  File should be in the form:
   * rows,cols
   * num,num,num,num...
   * num,num,num,num...
   * ...
   *
   * @param args
   * @throws ExecutionException
   * @throws InterruptedException
   * @throws FileNotFoundException
   */
  public static void main(String[] args) throws ExecutionException,
      InterruptedException, FileNotFoundException {
    Scanner scanner = new Scanner(new File(args[0])).useDelimiter("\n");
    String line = scanner.next();
    // first line should be rows,cols
    String[] parts = line.split(",");
    int rows = Integer.parseInt(parts[0]);
    int cols = Integer.parseInt(parts[1]);
    int[][] a = new int[rows][cols];
    int[][] m = new int[rows][cols];
    initMemoizer(m);
    loadArray(scanner, a);
    long now = System.currentTimeMillis();
    System.out.println("Value is: " + calculate(a, m, rows - 1, cols - 1));
    System.out.println(System.currentTimeMillis() - now + " millis");
  }
}
