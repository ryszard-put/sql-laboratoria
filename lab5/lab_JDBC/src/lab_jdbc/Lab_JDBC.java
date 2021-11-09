package lab_jdbc;

import java.sql.*;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Ryszard
 */
public class Lab_JDBC {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        System.out.println("KURWA");
        Connection conn = null;
        String connectionString =
        "jdbc:oracle:thin:@//admlab2.cs.put.poznan.pl:1521/"+
        "dblab02_students.cs.put.poznan.pl";
        Properties connectionProps = new Properties();
        connectionProps.put("user", "INF145407");
        connectionProps.put("password", "inf145407");
        
        try {
            conn = DriverManager.getConnection(connectionString,
            connectionProps);
            System.out.println("Połączono z bazą danych");
        } catch (SQLException ex) {
            Logger.getLogger(Lab_JDBC.class.getName()).log(Level.SEVERE,
            "Nie udało się połączyć z bazą danych", ex);
            System.exit(-1);
        }
        
//        try (
//            Statement stmt = conn.createStatement();
//            ResultSet rs = stmt.executeQuery(
//                "select id_prac, RPAD(nazwisko, 15, ' ' ), placa_pod " +
//                "from pracownicy"
//            );
//        ) {
//            while(rs.next()){
//                System.out.println(
//                    String.format(
//                        "%d %s %.2f",
//                        rs.getInt(1), rs.getString(2), rs.getFloat(3)
//                    )
//                );
//            }
//        } catch(SQLException ex) {
//            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());
//        }
        
        // Zadanie 1
//        System.out.println("Zadanie 1");
//        try (
//            Statement stmt1 = conn.createStatement();
//            ResultSet rs1 = stmt1.executeQuery(
//                "select count(*) AS liczba_pracownikow " +
//                "from pracownicy"
//            );
//            Statement stmt2 = conn.createStatement();
//            ResultSet rs2 = stmt2.executeQuery(
//                "select count(*) AS liczba_pracownikow, nazwa " +
//                "from pracownicy join zespoly using(id_zesp) " +
//                "group by nazwa"
//            );
//        ) {
//            while(rs1.next()){
//                System.out.println(
//                    String.format(
//                        "Zatrudniono %d pracowników, w tym:",
//                        rs1.getInt(1)
//                    )
//                );
//            }
//            while(rs2.next()){
//                System.out.println(
//                    String.format(
//                        "%d w zespole %s",
//                        rs2.getInt(1),
//                        rs2.getString(2)
//                    )
//                );
//            }
//        } catch(SQLException ex) {
//            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());
//        }
        try(
            Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = stmt.executeQuery(
            """
            select nazwisko, placa_pod + coalesce(placa_dod, 0) as pensja
            from pracownicy p inner join etaty e on p.etat = e.nazwa
            where p.etat = 'ASYSTENT'
            order by 2 desc
            """)
        ) {
            rs.afterLast();
            rs.previous();
            System.out.printf("%s %.2f%n", rs.getString(1), rs.getFloat(2));
            rs.previous();
            rs.previous();
            System.out.printf("%s %.2f%n", rs.getString(1), rs.getFloat(2));
            rs.beforeFirst();
            rs.next();
            rs.next();
            System.out.printf("%s %.2f%n", rs.getString(1), rs.getFloat(2));
            
        } catch(SQLException ex) {
            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());
        }

        
        try {
            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(Lab_JDBC.class.getName()).log(Level.SEVERE, null, ex);
        }
        System.out.println("Zamknięto połączenie z bazą danych");
    }
    
}
