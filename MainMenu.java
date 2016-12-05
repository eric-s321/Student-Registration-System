import javax.swing.*;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import java.awt.*;

/**
 * Created by Eric Scagnelli on 12/4/16.
 */
public class MainMenu extends JPanel {

    private JList actionList;
    private ViewTablesForm viewTablesForm;
    private JPanel emptyPanel;
    private BNumForm bNumForm;
    private PrereqForm prereqForm;
    private ClassIDForm classIDForm;
    private BNumClassIDForm bNumClassIDForm;

    public MainMenu (){
        setPreferredSize(new Dimension(500,700));

        actionList = new JList();
        viewTablesForm = new ViewTablesForm();
        emptyPanel = new JPanel();
        bNumForm = new BNumForm();
        prereqForm = new PrereqForm();
        classIDForm = new ClassIDForm();
        bNumClassIDForm = new BNumClassIDForm();

        DefaultListModel actionModel = new DefaultListModel();
        actionModel.addElement("View Tables");
        actionModel.addElement("Find Students Classes");
        actionModel.addElement("Prerequisite Information");
        actionModel.addElement("View Class Enrollment");
        actionModel.addElement("Enroll Student");
        actionModel.addElement("Drop Class");
        actionModel.addElement("Delete Student");

        actionList.setModel(actionModel);
        actionList.setBorder(BorderFactory.createEtchedBorder());
        actionList.addListSelectionListener(new ListSelectionListener() {
            @Override
            public void valueChanged(ListSelectionEvent e) {   //Called when the action list selection has changed, change visibility of second panel accordingly
                if(!e.getValueIsAdjusting()) {
                    String actionSelected = (String) actionList.getSelectedValue();
                    System.out.println(actionSelected + " is selected");
                    if (actionSelected != null){
                        emptyPanel.setVisible(false);
                        if(actionSelected.equals("View Tables")){
                            viewTablesForm.setVisible(true);
                            bNumForm.setVisible(false);
                            prereqForm.setVisible(false);
                            classIDForm.setVisible(false);
                            bNumClassIDForm.setVisible(false);
                        }
                        else if (actionSelected.equals("Find Students Classes")){
                            bNumForm.clearTextField();      //Empty text field before displaying it
                            viewTablesForm.setVisible(false);
                            bNumForm.setVisible(true);
                            prereqForm.setVisible(false);
                            classIDForm.setVisible(false);
                            bNumClassIDForm.setVisible(false);
                        }
                        else if (actionSelected.equals("Prerequisite Information")){
                            prereqForm.clearTextFields();
                            viewTablesForm.setVisible(false);
                            bNumForm.setVisible(false);
                            prereqForm.setVisible(true);
                            classIDForm.setVisible(false);
                            bNumClassIDForm.setVisible(false);
                        }
                        else if (actionSelected.equals("View Class Enrollment")){
                            classIDForm.clearTextField();
                            viewTablesForm.setVisible(false);
                            bNumForm.setVisible(false);
                            prereqForm.setVisible(false);
                            classIDForm.setVisible(true);
                            bNumClassIDForm.setVisible(false);
                        }
                        else if (actionSelected.equals("Enroll Student")){
                            bNumClassIDForm.clearTextFields();
                            viewTablesForm.setVisible(false);
                            bNumForm.setVisible(false);
                            prereqForm.setVisible(false);
                            classIDForm.setVisible(false);
                            bNumClassIDForm.setVisible(true);
                        }
                        else if (actionSelected.equals("Drop Class")){
                            bNumClassIDForm.clearTextFields();
                            viewTablesForm.setVisible(false);
                            bNumForm.setVisible(false);
                            prereqForm.setVisible(false);
                            classIDForm.setVisible(false);
                            bNumClassIDForm.setVisible(true);
                        }
                        else if (actionSelected.equals("Delete Student")){
                            bNumForm.clearTextField();
                            viewTablesForm.setVisible(false);
                            bNumForm.setVisible(true);
                            prereqForm.setVisible(false);
                            classIDForm.setVisible(false);
                            bNumClassIDForm.setVisible(false);
                        }
                    }
                }
            }
        });

        //Set sizes of panels
        Dimension formSize = new Dimension(200,350);
        actionList.setPreferredSize(new Dimension(200,350));
        viewTablesForm.setPreferredSize(new Dimension(200,400));
        emptyPanel.setPreferredSize(formSize);
        bNumForm.setPreferredSize(formSize);
        prereqForm.setPreferredSize(formSize);
        classIDForm.setPreferredSize(formSize);
        bNumClassIDForm.setPreferredSize(formSize);

        //Set visibility
        actionList.setVisible(true);
        emptyPanel.setVisible(true);
        viewTablesForm.setVisible(false);
        bNumForm.setVisible(false);
        prereqForm.setVisible(false);
        classIDForm.setVisible(false);
        bNumClassIDForm.setVisible(false);

        createLayout();

    }

    public void sendViewTableListener(ViewTableListener listener){
        viewTablesForm.setViewTableListener(listener);
    }

    public void sendBNumListener(BNumListener listener){
        bNumForm.setBNumListener(listener);
    }

    public void sendPrereqListener(PrereqFormListener listener){
        prereqForm.setPrereqFormListener(listener);
    }

    public void sendClassIDListener(ClassIDFormListener listener){
        classIDForm.setCLassIDListener(listener);
    }

    public void sendBNumClassIDListener(BNumClassIDListener listener){
        bNumClassIDForm.setBNumClassIDListener(listener);
    }


    //since some forms can be used more then once, use these methods in main frame to decide which pl/sql function to call
    public boolean studentsClassesSelected(){
        return (String)actionList.getSelectedValue() == "Find Students Classes";
    }
    public boolean deleteStudentSelected(){
        return (String)actionList.getSelectedValue() == "Delete Student";
    }
    public boolean enrollStudentSelected(){
        return (String)actionList.getSelectedValue() == "Enroll Student";
    }
    public boolean dropClassSelected(){
        return (String)actionList.getSelectedValue() == "Drop Class";
    }



    public void createLayout(){
        setLayout(new GridBagLayout());

        GridBagConstraints gc = new GridBagConstraints();
        gc.gridx = 0;
        gc.gridy = 0;
        gc.weightx = 1;
        gc.weighty = 1;
        gc.fill = GridBagConstraints.NONE;
        gc.anchor = GridBagConstraints.LINE_END;
        gc.insets = new Insets(0,0,0,0);

        add(actionList, gc);

        gc.gridx = 1;
        //top, left, bottom, right
        gc.insets = new Insets(37,0,0,0);
        add(viewTablesForm,gc);     //Put all form panels in same spot, only show one at a time

        gc.insets = new Insets(0,0,0,0);
        add(emptyPanel,gc);
        add(bNumForm,gc);
        add(prereqForm,gc);
        add(classIDForm,gc);
        add(bNumClassIDForm,gc);
    }
}
