import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Created by Eric Scagnelli on 12/4/16.
 */
public class ViewTablesForm extends JPanel {
    private JList tableList;
    private JButton viewBtn;
    private ViewTableListener viewTableListener;

    public ViewTablesForm(){
        tableList = new JList();
        viewBtn = new JButton("View");

        DefaultListModel tableModel = new DefaultListModel();
        tableModel.addElement("Students");
        tableModel.addElement("Courses");
        tableModel.addElement("Course Credit");
        tableModel.addElement("Classes");
        tableModel.addElement("Enrollments");
        tableModel.addElement("Grades");
        tableModel.addElement("Prerequisites");
        tableModel.addElement("Logs");

        tableList.setModel(tableModel);
        tableList.setPreferredSize(new Dimension(200,350));
        tableList.setBorder(BorderFactory.createEtchedBorder());

        viewBtn.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                viewTableListener.displayView((String) tableList.getSelectedValue());
            }
        });

        setLayout(new GridBagLayout());

        GridBagConstraints gc = new GridBagConstraints();
        gc.gridx = 0;
        gc.gridy = 0;
        gc.weightx = 10;
        gc.weighty = 10;
        gc.fill = GridBagConstraints.NONE;
        gc.anchor = GridBagConstraints.LINE_END;
        gc.insets = new Insets(0,0,0,0);

        add(tableList, gc);

        gc.gridy = 1;
        gc.weighty = 1;
        gc.weightx = 1;

        add(viewBtn,gc);

    }

    public void setViewTableListener(ViewTableListener listener){
        this.viewTableListener = listener;
    }

}
