import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Created by Eric Scagnelli on 12/3/16.
 * 
 * This class is the form that will be displayed for any operation requiring only a B# 
 * User data is collected into the text field.  When the OK button is pressed it's listener's
 * method will be called.  
 */
public class BNumForm extends JPanel {
    private JLabel bNumLabel;
    private JTextField textField;
    private JButton btn;
    private BNumListener bNumListener;

    public BNumForm(){
        bNumLabel = new JLabel("B#: ");
        textField = new JTextField(10);
        btn = new JButton("OK");

        btn.addActionListener(new ActionListener() {
			//Caller listeners method on button press to send BNum up to MainFrame
            @Override
            public void actionPerformed(ActionEvent e) {  //Call listener method to send information up to mainframe
                if(!textField.getText().isEmpty())
                    bNumListener.useBNum(textField.getText());
            }
        });

        setLayout(new GridBagLayout());

        GridBagConstraints gc = new GridBagConstraints();   //Lay out labels and text fields
        gc.gridx = 0;
        gc.gridy = 0;
        gc.weightx = 10;
        gc.weighty = 10;
        gc.fill = GridBagConstraints.NONE;
        gc.anchor = GridBagConstraints.LINE_END;
        gc.insets = new Insets(0,0,0,0);

        add(bNumLabel, gc);

        gc.gridx = 1;
        add(textField);

        gc.gridy = 1;
        gc.gridx = 1;
        gc.weighty = 1;
        gc.weightx = 1;

        add(btn,gc);
    }

    public void setBNumListener(BNumListener listener){
        bNumListener = listener;
    }

	//Clear all text fields so they can be used again
    public void clearTextField(){
        textField.setText(null);
    }






}

