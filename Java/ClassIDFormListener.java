/**
 * Created by Eric Scagnelli on 12/4/16.
 * This interface is the communicator between ClassIDForm and MainFrame. 
 * It will be defined in MainFrame and called from ClassIDForm so that the data from ClassIDForm
 * can be sent to other portions of the application.
 */
public interface ClassIDFormListener {
    public void sendClassID(String classid);
}

