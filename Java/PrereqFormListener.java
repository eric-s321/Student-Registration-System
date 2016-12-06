/**
 * Created by Eric Scagnelli on 12/4/16.
 *
 * This interface is the communicator between PrereqForm and MainFrame. 
 * It is defined in MainFrame but called from PrereqForm so that the data from PrereqForm can be 
 * sent to other parts of the application
 */
public interface PrereqFormListener {
    public void callPrereqs(String deptCode, int courseNum);
}

