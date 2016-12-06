import javax.swing.*;

/**
 * Created by Eric Scagnelli on 12/2/16.
 * Creates the MainFrame of the Application
 */
public class App {

    public static void main(String[] args){
        SwingUtilities.invokeLater(new Runnable(){
            public void run(){
                new MainFrame();
            }
        });

    }
}

