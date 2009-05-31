import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.net.*;
import java.util.TreeMap;
import java.io.*;
import java.util.BitSet;

/**
 * UI for the Spider class that can spider web pages based
 * on a domain match storing the email addresses as it
 * goes.
 * 
 * @author David J. Burger
 * @version 1.0
 * @since 06/19/01
 */
class SpamMaster extends JFrame implements ActionListener, Status {
  
  JTextField txtStartPage, txtHostMatch, txtOutputFile, txtHostLimit,
      txtSpiderFile, txtLastHarvestFile;
  JCheckBox chkResumePrevious, chkDisplayFeedback;
  JTextArea txtFeedback;
  JButton cmdStart, cmdPause, cmdExit, cmdAddType, cmdRemoveType;
  JList lstExcludedFileTypes;
  DefaultListModel lstModel;

  EmailSpider spid;
  String lastStatus;

  private final int TEXT_WIDTH = 20;

  /**
   * Constructor for SpamMaster window creation.
   * 
   * @param title  the title to display in the window.
   */
  SpamMaster(String title) {
    super(title);
    //long method that draws the UI elements
    SetUpUI();
  }

  /**
   * The entry point for this class.  Loads the UI.
   * 
   * @param args   Command line parameters...not being used.
   */
  public static void main(String args[]) {
      //these should be moved to a configuration file
      HarvestedURL.addNoFollow(".gif");
      HarvestedURL.addNoFollow(".jpeg");
      HarvestedURL.addNoFollow(".jpg");
      HarvestedURL.addNoFollow(".png");
      HarvestedURL.addNoFollow(".css");
      HarvestedURL.addNoFollow(".ram");
      HarvestedURL.addNoFollow(".avi");
      HarvestedURL.addNoFollow(".mov");
      HarvestedURL.addNoFollow(".wav");
      HarvestedURL.addNoFollow(".txt");
      HarvestedURL.addNoFollow(".bmp");
      HarvestedURL.addNoFollow(".xls");
      HarvestedURL.addNoFollow(".doc");
      HarvestedURL.addNoFollow(".ppt");
      HarvestedURL.addNoFollow(".sit");
      HarvestedURL.addNoFollow(".exe");
      HarvestedURL.addNoFollow(".pdf");
      HarvestedURL.addNoFollow(".rtf");
      HarvestedURL.addNoFollow(".zip");
      HarvestedURL.addNoFollow(".mpg");
      HarvestedURL.addNoFollow(".cab");
      HarvestedURL.addNoFollow(".mid");
      HarvestedURL.addNoFollow(".rm");
      //this comes from a trap I found
      HarvestedURL.addNoFollow(".nomail");

      SpamMaster app = new SpamMaster("Spam Master");
      app.pack();
      app.show();    
  }

  /**
   * The UI event method catcher for this UI.
   * 
   * @param evt    the event object sent for a UI event.
   */
  public void actionPerformed(ActionEvent evt) {

    Object src = evt.getSource();

    if (src==cmdExit)
        System.exit(0);
    else if (src==cmdStart) {
        if (cmdStart.getText().equals("Start")) {
            if (startSpider()) {
                cmdStart.setText("Stop");
                cmdPause.setEnabled(true);
	    }
        } else {
            //stop the thread
	    spid.setStopped(true);
            cmdStart.setText("Start");
	    cmdPause.setEnabled(false);
	    //could have been paused and thus the button said Resume
	    //therefore we change the text to Pause
            cmdPause.setText("Pause");
        }
    } else if (src==cmdPause) {
        if (cmdPause.getText().equals("Pause")) {
	    //pause the thread
	    spid.setPaused(true);
	    cmdPause.setText("Resume");
            cmdStart.setEnabled(false);
        } else {
            //resume the thread
            spid.setPaused(false);
            cmdPause.setText("Pause");
            cmdStart.setEnabled(true);
        }
    } else if (src==cmdAddType)
        addType();
    else if (src==cmdRemoveType)
        removeType();
    else if (src==chkDisplayFeedback) {
        if (chkDisplayFeedback.isSelected())
            txtFeedback.append(lastStatus + '\n');
    }
  }

  /**
   * This method starts the Spider process.
   */
  private boolean startSpider() {
      int nHostLimit = 0;
      BitSet fileBits = new BitSet(3);
      nHostLimit = Integer.parseInt(txtHostLimit.getText());
      File f = new File(txtOutputFile.getText());
      if (f.exists()) fileBits.set(2);
      f = new File(txtSpiderFile.getText());
      if (f.exists()) fileBits.set(1);
      f = new File(txtLastHarvestFile.getText());
      if (f.exists()) fileBits.set(0);
      if (chkResumePrevious.isSelected()) {
          if (fileBits.toString().equals("{0, 1, 2}")) {
              spid = new EmailSpider(txtStartPage.getText(),txtHostMatch.getText(),txtOutputFile.getText(),txtSpiderFile.getText(),txtLastHarvestFile.getText(),nHostLimit,this,true);
              spid.start();
              return true;
          } else {
              String sMissingFiles = new String();
              if (!fileBits.get(2)) sMissingFiles = txtOutputFile.getText() + "\n";
              if (!fileBits.get(1)) sMissingFiles += txtSpiderFile.getText() + "\n";
              if (!fileBits.get(0)) sMissingFiles += txtLastHarvestFile.getText() + "\n";
              JOptionPane.showMessageDialog(this, sMissingFiles + "does not exist.  Unable to resume previous run.","Resume Error",JOptionPane.ERROR_MESSAGE);
              return false;
          }
      } else {
          if (fileBits.toString().equals("{}")) {
              spid = new EmailSpider(txtStartPage.getText(),txtHostMatch.getText(),txtOutputFile.getText(),txtSpiderFile.getText(),txtLastHarvestFile.getText(),nHostLimit,this,false);
              spid.start();
              return true;
          } else {
              String sExistingFiles = new String();
              if (fileBits.get(2)) sExistingFiles = txtOutputFile.getText() + "\n";
              if (fileBits.get(1)) sExistingFiles += txtSpiderFile.getText() + "\n";
              if (fileBits.get(0)) sExistingFiles += txtLastHarvestFile.getText() + "\n";
              JOptionPane.showMessageDialog(this, sExistingFiles + "already exist.  Unable to start run.","Spider Error",JOptionPane.ERROR_MESSAGE);
              return false;
          }

      }


  }

  /**
   * Removes the selected type for the list of file extensions
   * not to follow when spidering.
   */
  private void removeType() {
      int index = lstExcludedFileTypes.getSelectedIndex();
      if (index!=-1) {
          HarvestedURL.removeNoFollow(lstModel.get(index).toString());
          lstModel.remove(index);
      }
      if (index<lstModel.size())
          lstExcludedFileTypes.setSelectedIndex(index);
  }

  /**
   * Adds a type file extension not to follow during spidering.
   */
  private void addType() {
      String sType = JOptionPane.showInputDialog(this,"Enter new type","Add Type",JOptionPane.QUESTION_MESSAGE);
      if (sType!=null)
          if (sType.length()>0) {
              if (HarvestedURL.addNoFollow(sType)) {
                  //add to the gui
                  //performance overkill for practice
                  int min = 0;
                  int max = lstModel.size()-1;
                  int mid = 0;
                  //can't be equal otherwise wouldn't have been added
                  while (min<=max) {
                      mid = (min + max) / 2;
                      if (lstModel.get(mid).toString().compareTo(sType)<0)
                          min = mid + 1;
                      else
                          max = mid - 1;
                  }
                  lstModel.add(min,sType);
                  lstExcludedFileTypes.setSelectedIndex(mid+1);
              }
          }
  }

  /**
   * The method called by the Spider class when there is a
   * status change.
   * 
   * @param sStatus The string representing the status.
   */
  public void status(String sStatus) {
      if (chkDisplayFeedback.isSelected())
          txtFeedback.append(sStatus + "\n");
      lastStatus = sStatus;
  }

  /**
   * This long method draws the UI elements.
   */
  private void SetUpUI() {

      /*
      try {
          UIManager.setLookAndFeel(UIManager.getCrossPlatformLookAndFeelClassName());
	  UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
      } catch (Exception e) {
	  //oh well, let the look and feel choose itself
      }
      */


      //the left panel will be a tabbed pane
      JTabbedPane pnlLeft = new JTabbedPane(JTabbedPane.TOP);

      //used in pnlTab0 of the tabbed pane
      GridBagLayout gb = new GridBagLayout();
      GridBagConstraints gbc = new GridBagConstraints();

      //the tab that contains overall settings
      JPanel pnlTab0 = new JPanel(gb);
      pnlLeft.add("settings",pnlTab0);
      //the tab that contains exclusion types
      JPanel pnlTab1 = new JPanel(new BorderLayout());
      pnlLeft.add("exclusions",pnlTab1);

      pnlLeft.setSelectedIndex(0);

      //the right panel will contain a running feedback of the spider process
      JPanel pnlRight = new JPanel(new BorderLayout());

      //the horizontal split to contain left and right panels
      JSplitPane split = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT,pnlLeft,pnlRight);
      split.setOneTouchExpandable(true);

      //adding the split to the frame
      this.getContentPane().setLayout(new BorderLayout());
      this.getContentPane().add(BorderLayout.CENTER, split);

      //now setting up pnlTab0
      JLabel lblStartPage = new JLabel("Start page:");
      gbc.gridx = 0;
      gbc.gridy = 0;
      gbc.gridwidth = 1;
      gbc.gridheight = 1;
      gbc.weightx = 100;
      gbc.weighty = 0;
      gbc.fill = GridBagConstraints.NONE;
      gbc.anchor = GridBagConstraints.WEST;
      gb.setConstraints(lblStartPage,gbc);
      pnlTab0.add(lblStartPage);

      txtStartPage = new JTextField(TEXT_WIDTH);
      gbc.gridx = 0;
      gbc.gridy = 1;
      gbc.gridwidth = 1;
      gbc.gridheight = 1;
      gbc.weighty = 0;
      gbc.fill = GridBagConstraints.HORIZONTAL;
      gbc.anchor = GridBagConstraints.WEST;
      gb.setConstraints(txtStartPage,gbc);
      pnlTab0.add(txtStartPage);

      JLabel lblHostMatch = new JLabel("Host match:");
      gbc.gridx = 0;
      gbc.gridy = 2;
      gbc.gridwidth = 1;
      gbc.gridheight = 1;
      gbc.weighty = 0;
      gbc.fill = GridBagConstraints.NONE;
      gbc.anchor = GridBagConstraints.WEST;
      gb.setConstraints(lblHostMatch,gbc);
      pnlTab0.add(lblHostMatch);

      txtHostMatch = new JTextField(TEXT_WIDTH);
      gbc.gridx = 0;
      gbc.gridy = 3;
      gbc.gridwidth = 1;
      gbc.gridheight = 1;
      gbc.weighty = 0;
      gbc.fill = GridBagConstraints.HORIZONTAL;
      gbc.anchor = GridBagConstraints.WEST;
      gb.setConstraints(txtHostMatch,gbc);
      pnlTab0.add(txtHostMatch);

      JLabel lblOutputFile = new JLabel("Output file:");
      gbc.gridx = 0;
      gbc.gridy = 4;
      gbc.gridwidth = 1;
      gbc.gridheight = 1;
      gbc.weighty = 0;
      gbc.fill = GridBagConstraints.NONE;
      gbc.anchor = GridBagConstraints.WEST;
      gb.setConstraints(lblOutputFile,gbc);
      pnlTab0.add(lblOutputFile);

      txtOutputFile = new JTextField(TEXT_WIDTH);
      gbc.gridx = 0;
      gbc.gridy = 5;
      gbc.gridwidth = 1;
      gbc.gridheight = 1;
      gbc.weighty = 0;
      gbc.fill = GridBagConstraints.HORIZONTAL;
      gbc.anchor = GridBagConstraints.WEST;
      gb.setConstraints(txtOutputFile,gbc);
      pnlTab0.add(txtOutputFile);

      JLabel lblSpiderFile = new JLabel("Spider file:");
      gbc.gridx = 0;
      gbc.gridy = 6;
      gbc.gridwidth = 1;
      gbc.gridheight = 1;
      gbc.weighty = 0;
      gbc.fill = GridBagConstraints.NONE;
      gbc.anchor = GridBagConstraints.WEST;
      gb.setConstraints(lblSpiderFile,gbc);
      pnlTab0.add(lblSpiderFile);

      txtSpiderFile = new JTextField(TEXT_WIDTH);
      gbc.gridx = 0;
      gbc.gridy = 7;
      gbc.gridwidth = 1;
      gbc.gridheight = 1;
      gbc.weighty = 0;
      gbc.fill = GridBagConstraints.HORIZONTAL;
      gbc.anchor = GridBagConstraints.WEST;
      gb.setConstraints(txtSpiderFile,gbc);
      pnlTab0.add(txtSpiderFile);

      JLabel lblLastHarvestFile = new JLabel("Last Harvest file:");
      gbc.gridx = 0;
      gbc.gridy = 8;
      gbc.gridwidth = 1;
      gbc.gridheight = 1;
      gbc.weighty = 0;
      gbc.fill = GridBagConstraints.NONE;
      gbc.anchor = GridBagConstraints.WEST;
      gb.setConstraints(lblLastHarvestFile,gbc);
      pnlTab0.add(lblLastHarvestFile);

      txtLastHarvestFile = new JTextField(TEXT_WIDTH);
      gbc.gridx = 0;
      gbc.gridy = 9;
      gbc.gridwidth = 1;
      gbc.gridheight = 1;
      gbc.weighty = 0;
      gbc.fill = GridBagConstraints.HORIZONTAL;
      gbc.anchor = GridBagConstraints.WEST;
      gb.setConstraints(txtLastHarvestFile,gbc);
      pnlTab0.add(txtLastHarvestFile);

      chkResumePrevious = new JCheckBox("Resume Previous");
      gbc.gridx = 0;
      gbc.gridy = 10;
      gbc.gridwidth = 1;
      gbc.gridheight = 1;
      gbc.weighty = 0;
      gbc.fill = GridBagConstraints.NONE;
      gbc.anchor = GridBagConstraints.WEST;
      gb.setConstraints(chkResumePrevious,gbc);
      pnlTab0.add(chkResumePrevious);

      JLabel lblHostLimit = new JLabel("Host limit:");
      gbc.gridx = 0;
      gbc.gridy = 11;
      gbc.gridwidth = 1;
      gbc.gridheight = 1;
      gbc.weighty = 0;
      gbc.fill = GridBagConstraints.NONE;
      gbc.anchor = GridBagConstraints.WEST;
      gb.setConstraints(lblHostLimit,gbc);
      pnlTab0.add(lblHostLimit);

      txtHostLimit = new JTextField("0",TEXT_WIDTH);
      gbc.gridx = 0;
      gbc.gridy = 12;
      gbc.gridwidth = 1;
      gbc.gridheight = 1;
      gbc.weighty = 0;
      gbc.fill = GridBagConstraints.HORIZONTAL;
      gbc.anchor = GridBagConstraints.WEST;
      gb.setConstraints(txtHostLimit,gbc);
      pnlTab0.add(txtHostLimit);

      chkDisplayFeedback = new JCheckBox("Display Feedback", true);
      gbc.gridx = 0;
      gbc.gridy = 13;
      gbc.gridwidth = 1;
      gbc.gridheight = 1;
      gbc.weighty = 0;
      gbc.fill = GridBagConstraints.NONE;
      gbc.anchor = GridBagConstraints.WEST;
      gb.setConstraints(chkDisplayFeedback,gbc);
      chkDisplayFeedback.addActionListener(this);
      pnlTab0.add(chkDisplayFeedback);

      JLabel lblSpacer = new JLabel();
      gbc.gridx = 0;
      gbc.gridy = 14;
      gbc.gridwidth = 1;
      gbc.gridheight = 1;
      gbc.weighty = 1;
      gbc.fill = GridBagConstraints.NONE;
      gbc.anchor = GridBagConstraints.WEST;
      gb.setConstraints(lblSpacer,gbc);
      pnlTab0.add(lblSpacer);
      //end of setting up pnlTab0

      //setting up pnlTab1
      //first the list model for the list box
      lstModel = new DefaultListModel();

      Object noFollows[] = HarvestedURL.noFollowArray();
      for (int i=0;i<noFollows.length;i++)
          lstModel.addElement(noFollows[i].toString());

      lstExcludedFileTypes = new JList(lstModel);
      JScrollPane sp = new JScrollPane(lstExcludedFileTypes);
      pnlTab1.add(BorderLayout.CENTER,sp);

      //a panel at the bottom for add and remove type buttons
      JPanel pnlTab1Bottom = new JPanel();

      cmdAddType = new JButton("Add Type");
      cmdAddType.addActionListener(this);
      pnlTab1Bottom.add(cmdAddType);

      cmdRemoveType = new JButton("Remove Type");
      cmdRemoveType.addActionListener(this);
      pnlTab1Bottom.add(cmdRemoveType);

      pnlTab1.add(BorderLayout.SOUTH,pnlTab1Bottom);
      //end setting up pnlTab1

      //setting up pnlRight to hold the feedback text box
      txtFeedback = new JTextArea(10,0);
      txtFeedback.setFont(new Font("Courier",0,11));
      sp = new JScrollPane(txtFeedback);
      pnlRight.add(BorderLayout.CENTER,sp);
      //end setting up pnlRight

      //and a panel at the bottom for start, exit buttons
      JPanel pnlBottom = new JPanel();
      this.getContentPane().add(pnlBottom,BorderLayout.SOUTH);

      cmdStart = new JButton("Start");
      cmdStart.addActionListener(this);
      pnlBottom.add(cmdStart);

      cmdPause = new JButton("Pause");
      cmdPause.setEnabled(false);
      cmdPause.addActionListener(this);
      pnlBottom.add(cmdPause);

      cmdExit = new JButton("Exit");
      cmdExit.addActionListener(this);
      pnlBottom.add(cmdExit);

      //finally a window listener for pressing the X
      this.addWindowListener(new WindowAdapter() {
              /**
               * Invoked when a window is in the process of being closed.
               * The close operation can be overridden at this point.
               */
	      public void windowClosing(WindowEvent e) {
		  System.exit(0);
	      }
	      });
  }
}
