import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Created by Eric Scagnelli on 12/4/16.
 */
public class PrereqForm extends JPanel{
    private JLabel deptCode;
    private JLabel courseNum;
    private JTextField deptCodeField;
    private JTextField courseNumField;
    private JButton okBtn;

    private PrereqFormListener prereqFormListener;

    public PrereqForm(){   //Create object for pre req form to collect info from user
        deptCode = new JLabel("Dept Code:         ");
        courseNum = new JLabel("Course Number: ");
        deptCodeField = new JTextField(6);
        courseNumField = new JTextField(6);
        okBtn = new JButton("OK");

        okBtn.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
               if(!deptCodeField.getText().isEmpty() && !courseNumField.getText().isEmpty())
                    prereqFormListener.callPrereqs(deptCodeField.getText(), Integer.parseInt(courseNumField.getText()));
            }
        });

        GridBagConstraints gc = new GridBagConstraints();       //put labesl and text fields into panel
        gc.gridx = 0;
        gc.gridy = 0;
        gc.weightx = 1;
        gc.weighty = 1;
        gc.fill = GridBagConstraints.NONE;
        gc.anchor = GridBagConstraints.LINE_END;
        gc.insets = new Insets(0,0,0,0);

        add(deptCode, gc);

        gc.gridx = 1;
        add(deptCodeField, gc);

        gc.gridy = 1;
        gc.gridx = 0;
        add(courseNum,gc);

        gc.gridx++;
        add(courseNumField,gc);

        gc.gridy = 2;
        add(okBtn,gc);
    }

    public void setPrereqFormListener(PrereqFormListener listener){
        prereqFormListener = listener;
    }

    public void clearTextFields(){
        deptCodeField.setText(null);
        courseNumField.setText(null);
    }

}
