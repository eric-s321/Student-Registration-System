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
                
                String studentClassInfo = tableGetter.getStudentClassInfo();
                System.out.println("The student class info is below: ");
                System.out.println(studentClassInfo);

                tableGetter.test();

                tableGetter.closeConnection();
                

                

        }



}