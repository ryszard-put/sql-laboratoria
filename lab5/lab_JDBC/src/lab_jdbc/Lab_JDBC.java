package lab_jdbc;

import javax.swing.plaf.nimbus.State;
import java.sql.*;
import java.util.Properties;
import java.util.Arrays;
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
// zadanie 2
//        try(
//            Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
//            ResultSet rs = stmt.executeQuery(
//            """
//            select nazwisko, placa_pod + coalesce(placa_dod, 0) as pensja
//            from pracownicy p inner join etaty e on p.etat = e.nazwa
//            where p.etat = 'ASYSTENT'
//            order by 2 desc
//            """)
//        ) {
//            rs.afterLast();
//            rs.previous();
//            System.out.printf("%s %.2f%n", rs.getString(1), rs.getFloat(2));
//            rs.previous();
//            rs.previous();
//            System.out.printf("%s %.2f%n", rs.getString(1), rs.getFloat(2));
//            rs.beforeFirst();
//            rs.next();
//            rs.next();
//            System.out.printf("%s %.2f%n", rs.getString(1), rs.getFloat(2));
//
//        } catch(SQLException ex) {
//            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());
//        }
// zadanie 3

//        int [] zwolnienia={150, 200, 230};
//        String [] zatrudnienia={"Kandefer", "Rygiel", "Boczar"};
//        try(Statement stmt = conn.createStatement()){
//            int changes = stmt.executeUpdate("DELETE FROM pracownicy WHERE id_prac IN (" +
//                    String.join(",", Arrays.stream(zwolnienia).mapToObj(String::valueOf).toArray(String[]::new)) + ")");
//            System.out.println("Usunięto " + changes + " rekordów");
//            changes = 0;
//            for(String nazwisko : zatrudnienia){
//                changes += stmt.executeUpdate("INSERT INTO pracownicy (id_prac, nazwisko) VALUES (prac_seq.nextval, '" + nazwisko + "')");
//            }
//            System.out.println("Wstawiono " + changes + " rekordy");
//        }  catch(SQLException ex) {
//            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());
//        }
// zadanie 4
//        try {
//            conn.setAutoCommit(false);
//            System.out.println("Wyłączono automatyczne zatwierdzanie transakcji");
//        } catch (SQLException ex) {
//            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());
//        }
//        try{
//            Statement stmt = conn.createStatement();
//            ResultSet rs1 = stmt.executeQuery("SELECT nazwa FROM etaty");
//            System.out.println("Etaty przed zmianą");
//            while(rs1.next()) {
//                System.out.println(rs1.getString(1));
//            }
//            rs1.close();
//
//            stmt.executeUpdate("INSERT INTO etaty (nazwa) VALUES ('NOWY ETAT')");
//            System.out.println("Wstawienie nowego etatu");
//            ResultSet rs2 = stmt.executeQuery("SELECT nazwa FROM etaty");
//            System.out.println("Etaty po zmianie");
//            while(rs2.next()) {
//                System.out.println(rs2.getString(1));
//            }
//            rs2.close();
//
//            conn.rollback();
//            System.out.println("Wycofanie transakcji");
//
//            ResultSet rs3 = stmt.executeQuery("SELECT nazwa FROM etaty");
//            System.out.println("Etaty po wycofaniu transakcji");
//            while(rs3.next()) {
//                System.out.println(rs3.getString(1));
//            }
//            rs3.close();
//
//            stmt.executeUpdate("INSERT INTO etaty (nazwa) VALUES ('NOWY ETAT')");
//            System.out.println("Wstawienie nowego etatu");
//
//            conn.commit();
//            System.out.println("Zatwierdzono transakcje");
//
//            ResultSet rs4 = stmt.executeQuery("SELECT nazwa FROM etaty");
//            System.out.println("Etaty po zatwierdzeniu transakcji");
//            while(rs4.next()) {
//                System.out.println(rs4.getString(1));
//            }
//            rs4.close();
//
//            stmt.close();
//
//        } catch(SQLException ex){
//            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());
//        }
// zadanie 5
//        String [] nazwiska={"Woźniak", "Dąbrowski", "Kozłowski"};
//        int [] place={1300, 1700, 1500};
//        String [] etaty={"ASYSTENT", "PROFESOR", "ADIUNKT"};
//
//        try{
//            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO pracownicy (id_prac, nazwisko, etat, placa_pod) VALUES (prac_seq.nextval,?,?,?)");
//            for(int i = 0; i < nazwiska.length; ++i){
//                pstmt.setString(1, nazwiska[i]);
//                pstmt.setString(2, etaty[i]);
//                pstmt.setInt(3, place[i]);
//                int changes = pstmt.executeUpdate();
//                System.out.println("Wstawiono pracownika " + nazwiska[i]);
//            }
//            pstmt.close();
//        } catch(SQLException ex){
//            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());
//        }
// zadanie 6
//        try{
//            conn.setAutoCommit(false);
//            Statement stmt = conn.createStatement();
//            long start = System.nanoTime();
//
//            for(int i = 0; i < 2000; ++i){
//                stmt.executeUpdate("INSERT INTO pracownicy (id_prac, nazwisko) VALUES (prac_seq.nextval, 'NOWY PRACOWNIK')");
//            }
//
//            long czas = System.nanoTime() - start;
//            System.out.println("Czas sekwencyjnego wykonania: " + czas + "ns");
//
//            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO pracownicy (id_prac, nazwisko) VALUES (prac_seq.nextval, 'NOWY PRACOWNIK')");
//
//            start = System.nanoTime();
//
//            for(int i = 0; i < 2000; ++i){
//                pstmt.addBatch();
//            }
//            pstmt.executeBatch();
//
//            czas = System.nanoTime() - start;
//            System.out.println("Czas wsadowego wykonania: " + czas + "ns");
//
//            conn.rollback();
//            stmt.close();
//            pstmt.close();
//        } catch(SQLException ex){
//            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());
//        }
        // 20s vs 0.04s
// zadanie 7
        try{
            CallableStatement stmt = conn.prepareCall("{? = call TransformujNazwisko(?,?)}");
            stmt.setInt(2, 110);
            stmt.registerOutParameter(1, Types.INTEGER);
            stmt.registerOutParameter(3, Types.VARCHAR);

            stmt.execute();
            int status = stmt.getInt(1);
            String nazwisko = stmt.getString(3);
            System.out.println("Status: " + status);
            System.out.println("Nazwisko: " + nazwisko);
        } catch(SQLException ex){
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
