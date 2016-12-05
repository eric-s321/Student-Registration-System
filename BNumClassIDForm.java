import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Created by Eric Scagnelli on 12/4/16.
 */
public class BNumClassIDForm extends JPanel {

    private JLabel bNum;
    private JLabel classid;
    private JTextField bNumField;
    private JTextField classIDField;
    private JButton okBtn;
    private BNumClassIDListener bNumClassIDListener;

    public BNumClassIDForm(){
        bNum = new JLabel("B#:          ");
        classid = new JLabel("Class ID: ");
        bNumField = new JTextField(10);
        classIDField = new JTextField(10);
        okBtn = new JButton("OK");
        okBtn.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                if(!bNumField.getText().isEmpty() && !classIDField.getText().isEmpty()){
                    bNumClassIDListener.sendBNumClassID(bNumField.getText(), classIDField.getText());
                }
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

        add(bNum, gc);

        gc.gridx = 1;
        add(bNumField, gc);

        gc.gridy = 1;
        gc.gridx = 0;
        add(classid,gc);

        gc.gridx++;
        add(classIDField,gc);

        gc.gridy = 2;
        add(okBtn,gc);
    }


    public void setBNumClassIDListener(BNumClassIDListener listener){
        bNumClassIDListener = listener;
    }

    public void clearTextFields(){
        bNumField.setText(null);
        classIDField.setText(null);
    }



}
