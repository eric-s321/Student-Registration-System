import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Created by Eric Scagnelli on 12/4/16.
 *
 * This class is the form that will be displayed for any operation requiring dept code and course#
 * User data is collected into the text fields.  When the OK button is pressed it's listener's
 * method will be called.
 */
public class PrereqForm extends JPanel{
    private JLabel deptCode;
    private JLabel courseNum;
    private JTextField deptCodeField;
    private JTextField courseNumField;
    private JButton okBtn;

    private PrereqFormListener prereqFormListener;

    public PrereqForm(){   //Create object for pre req form to collect info from user
        deptCode = new JLabel("Dept Code:          ");
        courseNum = new JLabel("Course Number: ");
        deptCodeField = new JTextField(6);
        courseNumField = new JTextField(6);
        okBtn = new JButton("OK");

        okBtn.addActionListener(new ActionListener() {
			//Call listeners method on button click to send information up to MainFrame.
            @Override
            public void actionPerformed(ActionEvent e) {
			   int courseNumInt = -1;		
			   if(isInteger(courseNumField.getText())){
			       courseNumInt = Integer.parseInt(courseNumField.getText()); 
			   }	
               if(!deptCodeField.getText().isEmpty() && !courseNumField.getText().isEmpty())
                    prereqFormListener.callPrereqs(deptCodeField.getText(), courseNumInt);
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

	//Clear all text fields to make form ready for next use
    public void clearTextFields(){
        deptCodeField.setText(null);
        courseNumField.setText(null);
    }

	public static boolean isInteger(String s) {
		if (s == null)
			return false;
		try { 
			Integer.parseInt(s); 
		} catch(NumberFormatException e) { 
			return false; 
		} catch(NullPointerException e) {
			return false;
		}
		// only got here if the string is an integer 
		return true;
	}

}

