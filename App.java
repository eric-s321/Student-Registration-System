import javax.swing.*;

/**
 * Created by Eric Scagnelli on 12/2/16.
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
