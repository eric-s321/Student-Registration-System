import java.util.Scanner;


public class Driver{

        public static void main(String args[]){
                TableGetter tableGetter = new TableGetter();
                String students = tableGetter.getStudents();
                System.out.println("The student information is below: ");
                System.out.println(students);

                String courses = tableGetter.getCourses();
                System.out.println("The course info is below ");
                System.out.println(courses);

                String courseCredit = tableGetter.getCourses();
                System.out.println("The course credit info is below: ");
                System.out.println(courseCredit);

                String classes = tableGetter.getClasses();
                System.out.println("The class info is below: ");
                System.out.println(classes);

                String enrollments = tableGetter.getEnrollments();
                System.out.println("The enrollments info is below: ");
                System.out.println(enrollments);

                String grades = tableGetter.getGrades();
                System.out.println("The grade info is below: ");
                System.out.println(grades);

                String prereqs = tableGetter.getPrereqs();
                System.out.println("The prereq info is below: ");
                System.out.println(prereqs);
                
                String logs = tableGetter.getLogs();
                System.out.println("The log info is below: ");
                System.out.println(logs);
                
//              String studentClassInfo = tableGetter.getStudentClassInfo();
//              System.out.println("The student class info is below: ");
//              System.out.println(studentClassInfo);
                
        Scanner scanner = new Scanner(System.in);

//        System.out.print("Dept Code:  ");
//       String deptCode = scanner.next();
//              System.out.print("Course#: ");
//              String courseNum = scanner.next();
//              String needAsPrereq = tableGetter.getNeedAsPrereq(deptCode,Integer.parseInt(courseNum));
//              System.out.println(needAsPrereq);
//              tableGetter.test();

//              System.out.print("Class id: ");
//              String classid = scanner.next();
//              String classInfo = tableGetter.getClassEnrollmentInfo(classid);
//              System.out.println(classInfo);
                
//              System.out.print("B#: ");
//              String BNum = scanner.next();
//              System.out.print("Class id: ");
//              String classid = scanner.next();
//              String enrollmentResults = tableGetter.enrollStudent(BNum,classid); 
//              if (enrollmentResults.equals("Student successfully enrolled.")){
//                      System.out.println (enrollmentResults);
//              }
//              else{
//                      System.out.println("The following issue(s) were found: ");
//                      System.out.println(enrollmentResults);
//              }       

//              System.out.print("B#: ");
//              String BNum = scanner.next();
//              System.out.print("Class id: ");
//              String classid = scanner.next();
//              String dropClassResults = tableGetter.dropClass(BNum,classid); 
//              if (dropClassResults.equals("Student successfully dropped the class.")){
//                      System.out.println (dropClassResults);
//              }
//              else{
//                      System.out.println("The following issue(s) were found: ");
//                      System.out.println(dropClassResults);
//              }       
                
                System.out.println("B#: ");
                String BNum = scanner.next();
                String deleteStudentResults = tableGetter.deleteStudent(BNum);
                if(deleteStudentResults.equals("The student has been deleted.")){
                        System.out.println(deleteStudentResults);
                }
                else{
                        System.out.println("The following issue(s) were found: ");
                        System.out.println(deleteStudentResults);
                }

                tableGetter.closeConnection();
                

                

        }



}
