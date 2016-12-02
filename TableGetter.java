import java.sql.*;
import oracle.jdbc.*;
import java.math.*;
import java.io.*;
import java.awt.*;
import oracle.jdbc.pool.OracleDataSource;
import java.util.Scanner;
import java.io.Console;


public class TableGetter {

        private OracleDataSource ds;
        private Connection conn;        
        
        public TableGetter (){
                try{
                        //Connecting to Oracle server
                        ds = new oracle.jdbc.pool.OracleDataSource();
                        ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:acad111");

                        Scanner scanner = new Scanner(System.in);
                        System.out.print("Username: ");
                        String username = scanner.next();
//                      System.out.print("Password: ");
//                      String password = scanner.next();

                        Console console = System.console();
                        System.out.print("Password: ");
                        char[] passString = console.readPassword();
                        String password = new String(passString );

                        conn = ds.getConnection(username, password);
                }
                
                catch (SQLException ex) { System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());}
                catch (Exception e) {System.out.println ("\n*** other Exception caught ***\n");}        


        }       


        public String getStudents(){
            try{
                System.out.println("Welcome! \n\n");

                //set up call for stored function
                CallableStatement cs = conn.prepareCall("begin ? := srs.show_students(); end;");

                cs.registerOutParameter(1, OracleTypes.CURSOR);
                        
                //execute pl/sql function and retrieve result set
                cs.execute();
                ResultSet rs = (ResultSet) cs.getObject(1);

                String results = new String();
                //print out results
                while (rs.next()) {
                        for (int i = 1; i <=6; i++)
                                results += rs.getString(i) + "\t";
                        //      System.out.print(rs.getString(i) + "\t");
                        results += "\n";
                //      System.out.println();
                }


                cs.close();
                rs.close();
                return results;
            }
            catch (SQLException ex) { System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());}
            catch (Exception e) {System.out.println ("\n*** other Exception caught ***\n");}    
            return null;
        } 
        
        public void closeConnection(){
            try{
                conn.close();
            }
            catch (SQLException ex) { System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());}
        }
        



}
