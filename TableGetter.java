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

            Console console = System.console();
            System.out.print("Password: ");
            char[] passString = console.readPassword();
            String password = new String(passString );

                conn = ds.getConnection(username, password);
                System.out.println("Welcome! \n");
                }
                
                catch (SQLException ex) { System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());}
                catch (Exception e) {System.out.println ("\n*** other Exception caught ***\n");}        
        }       
        

        public void test(){
            try{
                //set up call for stored function
            CallableStatement cs = conn.prepareCall("begin ? := srs_java.test_func(); end;");

                        cs.registerOutParameter(1, java.sql.Types.VARCHAR);
                        
            //execute pl/sql function and retrieve result set
            cs.execute();

            String result = cs.getString(1); 

                        System.out.println(result);
            cs.close();
            }
        catch (SQLException ex) { System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());}
            catch (Exception e) {System.out.println ("\n*** other Exception caught ***\n");}    
        }
        
        public String getStudentClassInfo(){
                try{
//                      String sid = new String("B001");
                //set up call for stored function
                        CallableStatement cs = conn.prepareCall("begin ? := srs_java.find_student_class_helper(?); end;");
                        String results = new String();  
                        
                        Scanner scanner = new Scanner(System.in);
            System.out.print("B#:  ");
            String BNum = scanner.next();

            cs.registerOutParameter(1, java.sql.Types.VARCHAR);
                        cs.setString(2, BNum);
                        
            //execute find student class help and find out if the input was valid
            cs.execute();
                        String errors = cs.getString(1);
                        if (errors != null){    //A problem was found with the input
                                System.out.println("ERROR " + errors);
                        } 
                        else{  //Input is valid, retrieve results
                                CallableStatement cs1 = conn.prepareCall("begin ? := srs_java.find_student_class_info(?); end;");
                                cs1.registerOutParameter(1, OracleTypes.CURSOR);        
                                cs1.setString(2,BNum);

                                cs1.execute();
                    ResultSet rs = (ResultSet) cs1.getObject(1);

                        //store result of find_student_class_info in string to be passed back to caller
                                while (rs.next()) {
                                        for (int i = 1; i <=8; i++)
                                                results += rs.getString(i) + "\t";
                                        results += "\n";
                                }
                                cs1.close();
                                rs.close();
                        }
                        cs.close();
                        return results;
            }
        catch (SQLException ex) { System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());}
            catch (Exception e) {System.out.println ("\n*** other Exception caught ***\n");}    
            return null;
        }
        
        public String getStudents(){
                try{
                //set up call for stored function
                        CallableStatement cs = conn.prepareCall("begin ? := srs_java.show_students(); end;");

            cs.registerOutParameter(1, OracleTypes.CURSOR);
                        
            //execute pl/sql function and retrieve result set
            cs.execute();
            ResultSet rs = (ResultSet) cs.getObject(1);

            String results = new String();
            //store result of show_students in string to be passed back to caller
            while (rs.next()) {
                    for (int i = 1; i <=8; i++)
                                        results += rs.getString(i) + "\t";
                results += "\n";
                        }

                        cs.close();
                        rs.close();
                        return results;
            }
        catch (SQLException ex) { System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());}
            catch (Exception e) {System.out.println ("\n*** other Exception caught ***\n");}    
            return null;
        } 
        
        public String getLogs(){
                try{
                //set up call for stored function
                        CallableStatement cs = conn.prepareCall("begin ? := srs_java.show_logs(); end;");

            cs.registerOutParameter(1, OracleTypes.CURSOR);
                        
            //execute pl/sql function and retrieve result set
            cs.execute();
            ResultSet rs = (ResultSet) cs.getObject(1);

            String results = new String();
            //store result of show_students in string to be passed back to caller
            while (rs.next()) {
                    for (int i = 1; i <=6; i++)
                                        results += rs.getString(i) + "\t";
                results += "\n";
            }

                        cs.close();
                        rs.close();
                        return results;
            }
        catch (SQLException ex) { System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());}
            catch (Exception e) {System.out.println ("\n*** other Exception caught ***\n");}    
            return null;
        }
        
        public String getCourses(){
                try{
                //set up call for stored function
                        CallableStatement cs = conn.prepareCall("begin ? := srs_java.show_courses(); end;");

            cs.registerOutParameter(1, OracleTypes.CURSOR);
                        
            //execute pl/sql function and retrieve result set
            cs.execute();
            ResultSet rs = (ResultSet) cs.getObject(1);

            String results = new String();
            //store result of show_courses in string to be passed back to caller
            while (rs.next()) {
                    for (int i = 1; i <=3; i++)
                                        results += rs.getString(i) + "\t";
                results += "\n";
            }

                        cs.close();
                        rs.close();
                        return results;
            }
        catch (SQLException ex) { System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());}
            catch (Exception e) {System.out.println ("\n*** other Exception caught ***\n");}    
            return null;
        }
        public String getCourseCredit(){
                try{
                //set up call for stored function
                        CallableStatement cs = conn.prepareCall("begin ? := srs_java.show_course_credit(); end;");

            cs.registerOutParameter(1, OracleTypes.CURSOR);
                        
            //execute pl/sql function and retrieve result set
            cs.execute();
            ResultSet rs = (ResultSet) cs.getObject(1);

            String results = new String();
            //store result of show_course_credit in string to be passed back to caller
            while (rs.next()) {
                    for (int i = 1; i <=2; i++)
                                        results += rs.getString(i) + "\t";
                results += "\n";
            }

                        cs.close();
                        rs.close();
                        return results;
            }
        catch (SQLException ex) { System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());}
            catch (Exception e) {System.out.println ("\n*** other Exception caught ***\n");}    
            return null;
        }
        public String getClasses(){
                try{
                //set up call for stored function
                        CallableStatement cs = conn.prepareCall("begin ? := srs_java.show_classes(); end;");

            cs.registerOutParameter(1, OracleTypes.CURSOR);
                        
            //execute pl/sql function and retrieve result set
            cs.execute();
            ResultSet rs = (ResultSet) cs.getObject(1);

            String results = new String();
            //store result of show_classes in string to be passed back to caller
            while (rs.next()) {
                    for (int i = 1; i <=8; i++)
                                        results += rs.getString(i) + "\t";
                results += "\n";
            }

                        cs.close();
                        rs.close();
                        return results;
            }
        catch (SQLException ex) { System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());}
            catch (Exception e) {System.out.println ("\n*** other Exception caught ***\n");}    
            return null;
        }
        public String getEnrollments(){
                try{
                //set up call for stored function
                        CallableStatement cs = conn.prepareCall("begin ? := srs_java.show_enrollments(); end;");

            cs.registerOutParameter(1, OracleTypes.CURSOR);
                        
            //execute pl/sql function and retrieve result set
            cs.execute();
            ResultSet rs = (ResultSet) cs.getObject(1);

            String results = new String();
            //store result of show_enrolments in string to be passed back to caller
            while (rs.next()) {
                    for (int i = 1; i <=3; i++)
                                        results += rs.getString(i) + "\t";
                results += "\n";
            }

                        cs.close();
                        rs.close();
                        return results;
            }
        catch (SQLException ex) { System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());}
            catch (Exception e) {System.out.println ("\n*** other Exception caught ***\n");}    
            return null;
        }
        public String getGrades(){
                try{
                //set up call for stored function
                        CallableStatement cs = conn.prepareCall("begin ? := srs_java.show_grades(); end;");

            cs.registerOutParameter(1, OracleTypes.CURSOR);
                        
            //execute pl/sql function and retrieve result set
            cs.execute();
            ResultSet rs = (ResultSet) cs.getObject(1);

            String results = new String();
            //store result of show_grades in string to be passed back to caller
            while (rs.next()) {
                    for (int i = 1; i <=2; i++)
                                        results += rs.getString(i) + "\t";
                results += "\n";
            }

                        cs.close();
                        rs.close();
                        return results;
            }
        catch (SQLException ex) { System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());}
            catch (Exception e) {System.out.println ("\n*** other Exception caught ***\n");}    
            return null;
        }
        public String getPrereqs(){
                try{
                //set up call for stored function
                        CallableStatement cs = conn.prepareCall("begin ? := srs_java.show_prerequisites(); end;");

            cs.registerOutParameter(1, OracleTypes.CURSOR);
                        
            //execute pl/sql function and retrieve result set
            cs.execute();
            ResultSet rs = (ResultSet) cs.getObject(1);

            String results = new String();
            //store result of show_prerequisites in string to be passed back to caller
            while (rs.next()) {
                    for (int i = 1; i <=4; i++)
                                        results += rs.getString(i) + "\t";
                results += "\n";
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
