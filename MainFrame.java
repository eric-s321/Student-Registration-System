import java.awt.*;
import javax.swing.JFrame;
import java.util.Scanner;
import java.io.Console;

/**
 * Created by Eric Scagnelli on 12/4/16.
 */
public class MainFrame extends JFrame {

        private TableGetter tableGetter;
        private DisplayPanel displayPanel;
        private MainMenu mainMenu;

        public MainFrame() {
            Scanner scanner = new Scanner(System.in);
            System.out.print("Username: ");
            String username = scanner.next();

            Console console = System.console();
            System.out.print("Password: ");
            char[] passString = console.readPassword();
            String password = new String(passString );

            tableGetter = new TableGetter(username,password);
            setLayout(new BorderLayout());
            displayPanel = new DisplayPanel();
            mainMenu = new MainMenu();


            mainMenu.sendBNumClassIDListener(new BNumClassIDListener() {
                @Override
                public void sendBNumClassID(String bNum, String classid) {
                                        displayPanel.clearText();
                    if(mainMenu.enrollStudentSelected()){
                        System.out.println("Enroll Students Listener. " + bNum + " " + classid);
                                                if(bNum != null && classid != null){
                                                        String results = tableGetter.enrollStudent(bNum,classid);
                                                        displayPanel.displayText(results);
                                                }
                    }
                    else if (mainMenu.dropClassSelected()){
                        System.out.println("Drop Class Listener. " + bNum + " " + classid);
                                                if(bNum != null && classid != null){
                                                        String results = tableGetter.dropClass(bNum, classid);
                                                        displayPanel.displayText(results);
                                                }
                    }
                }
            });

            mainMenu.sendClassIDListener(new ClassIDFormListener() {  //Define what the classID listener will do here, so we can interact with display panel
                @Override
                public void sendClassID(String classid) {
                                        displayPanel.clearText();
                    System.out.println("Class ID Listener.  Class id is: " + classid);
                                        if(classid != null){
                                                String results = tableGetter.getClassEnrollmentInfo(classid);
                                                displayPanel.displayText(results);
                                        }
                }
            });

            mainMenu.sendViewTableListener(new ViewTableListener() {  //Tell table view listener what actions to take while in scope of display panel
                @Override
                public void displayView(String viewToDisplay) {
                    //Code to call appropriate method and send text to Display panels append text;
//                    System.out.println("Display View was called!");
//                   System.out.println("View to display is: " + viewToDisplay);
                    displayPanel.clearText();
                    if(viewToDisplay != null){
                        String results = null;
                        if(viewToDisplay.equals("Students")){
                            results = tableGetter.getStudents();
                        }
                        else if(viewToDisplay.equals("Courses")){
                            results = tableGetter.getCourses();
                        }
                        else if(viewToDisplay.equals("Course Credit")){
                            results = tableGetter.getCourseCredit();
                        }
                        else if(viewToDisplay.equals("Classes")){
                            results = tableGetter.getClasses();
                        }
                        else if(viewToDisplay.equals("Enrollments")){
                            results = tableGetter.getEnrollments();
                        }
                        else if(viewToDisplay.equals("Grades")){
                            results = tableGetter.getGrades();
                        }
                        else if(viewToDisplay.equals("Prerequisites")){
                            results = tableGetter.getPrereqs();
                        }
                        else if(viewToDisplay.equals("Logs")){
                            results = tableGetter.getLogs();
                        }
                        if(results != null){
                            displayPanel.displayText(results);
                        }
                    }

                }
            });

            mainMenu.sendBNumListener(new BNumListener() {
                @Override
                public void useBNum(String bNum) {   //This is called when a B# is submitted for find student courses
                                        displayPanel.clearText();
                    if(mainMenu.studentsClassesSelected()) {
                        System.out.println("In Display students classes code");
                        System.out.println("B# is: " + bNum);
                                                if(bNum != null){
                                                        String results = tableGetter.getStudentClassInfo(bNum);
                                                        displayPanel.displayText(results);
                                                }
                    }
                    else if(mainMenu.deleteStudentSelected()){
                        System.out.println("In Delete student. B Num is " + bNum);
                                                if(bNum != null){
                                                        String results = tableGetter.deleteStudent(bNum);
                                                        displayPanel.displayText(results);
                                                }
                    }
                }
            });

            mainMenu.sendPrereqListener(new PrereqFormListener() {
                @Override
                public void callPrereqs(String deptCode, int courseNum) {
                                        displayPanel.clearText();
                    System.out.println("Preq info: " + deptCode + " " + courseNum);
                                        if(deptCode!= null){
                                                String results = tableGetter.getNeedAsPrereq(deptCode, courseNum);
                                                displayPanel.displayText(results);
                                        }
                }
            });

            // add panel components
            add(displayPanel, BorderLayout.EAST);
            add(mainMenu, BorderLayout.WEST);

            setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            setMinimumSize(new Dimension(500, 450));
            setSize(1200, 700);
            setVisible(true);
        }
}

