/**
 * Created by Eric Scagnelli on 12/4/16.
 * This interface is the communicator between BNumClassIDForm and MainFrame
 * It will be defined in MainFrame allowing the data in BNumClassIDForm to be 
 * sent to other areas of the application.
 */
public interface BNumClassIDListener {

    public void sendBNumClassID(String bNum, String classid);
}

