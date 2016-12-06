/**
 * Created by Eric Scagnelli on 12/4/16.
 * 
 * This interface is the communicator between ViewTablesForm and MainFrame.
 * It is implemented in MainFrame and called from ViewTablesForm so that the table selection 
 * in ViewTablesForm can be known MainFrame and the appropriate table can be displayed.
 */
public interface ViewTableListener {

    public void displayView(String viewToDisplay);

}

