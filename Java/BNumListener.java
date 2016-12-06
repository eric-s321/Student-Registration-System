/**
 * Created by Eric Scagnelli on 12/4/16.
 * 
 * This class is the communicator between BNumForm and MainFrame. 
 * It will be defined within MainFrame and called from BNumForm so that the fields in 
 * BNumForm can be sent to other parts of the program.
 */
public interface BNumListener {
    public void useBNum(String bNum);
}

