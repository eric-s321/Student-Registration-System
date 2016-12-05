import javax.swing.*;
import java.awt.*;

/**
 * Created by Eric Scagnelli on 12/4/16.
 */
public class DisplayPanel extends JPanel {

    private JTextArea textArea;

    public DisplayPanel(){
        textArea = new JTextArea();
        textArea.setEditable(false);
        setPreferredSize(new Dimension(650,600));
        setLayout(new BorderLayout());
        add(new JScrollPane(textArea), BorderLayout.CENTER);
    }

    public void displayText(String text){
        textArea.append(text);
    }

    public void clearText(){
        textArea.setText(null);
    }

}
