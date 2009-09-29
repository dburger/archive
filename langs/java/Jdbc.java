import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class Jdbc {

    public static void main(String[] args) {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/auth",
                "root", "root");
        String sql = "SELECT password FROM user WHERE email='" + emailAddr
                + "';";
        Statement stmt = conn.createStatement();
        stmt.execute(sql);
        // stmt.getUpdateCount(); for exec style queries
        ResultSet rs = stmt.getResultSet();
        String password = rs.first() ? rs.getString(1) : null;
        stmt.close();
        conn.close();
    }

}
