public class TestDriver{

        public static void main(String args[]){
                TableGetter tableGetter = new TableGetter();
                String students = tableGetter.getStudents();
//              tableGetter.closeConnection();
                System.out.println("The student information is below: ");
                System.out.println(students);

        }



}