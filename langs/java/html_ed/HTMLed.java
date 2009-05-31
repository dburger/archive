import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import java.io.*;

class HTMLed extends JFrame implements ActionListener, WindowListener {

  JMenu mnuFile;
  JMenuItem mnuFileNew, mnuFileOpen, mnuFileSave, mnuFileSaveAs, mnuFileExit;
  JTextArea txtMain;

  boolean isDirty = false;
  String filename = "";
  String path = "";

  HTMLed(String title) {

    super(title);
    //initialize controls
    JMenuBar mnuMain = new JMenuBar();
    mnuFile = new JMenu("File");
    mnuMain.add(mnuFile);
    mnuFileNew = new JMenuItem("New");
    mnuFile.add(mnuFileNew);
    mnuFileOpen = new JMenuItem("Open");
    mnuFile.add(mnuFileOpen);
    mnuFileSave = new JMenuItem("Save");
    mnuFile.add(mnuFileSave);
    mnuFileSaveAs = new JMenuItem("Save As");
    mnuFile.add(mnuFileSaveAs);
    mnuFileExit = new JMenuItem("Exit");
    mnuFile.add(mnuFileExit);
    mnuFile.setMnemonic('F');
    mnuFileNew.setMnemonic('N');
    mnuFileOpen.setMnemonic('O');
    mnuFileSave.setMnemonic('S');
    mnuFileSaveAs.setMnemonic('A');
    mnuFileExit.setMnemonic('x');
    txtMain = new JTextArea();
    BorderLayout bo = new BorderLayout();
    JPanel pnlMain = new JPanel();
    this.setJMenuBar(mnuMain);
    pnlMain.setLayout(bo);
    pnlMain.add(txtMain, "Center");
    this.setContentPane(pnlMain);
    //this.pack();
    //set up events
    this.addWindowListener(this);
    mnuFileNew.addActionListener(this);
    mnuFileOpen.addActionListener(this);
    mnuFileSave.addActionListener(this);
    mnuFileSaveAs.addActionListener(this);
    mnuFileExit.addActionListener(this);
  }

  public static void main(String args[]) {

    HTMLed app = new HTMLed("HTMLed");
    app.setSize(400,400);
    app.setVisible(true);

  }

  public void actionPerformed(ActionEvent evt) {

      Object src = evt.getSource();
      if (src==mnuFileNew)
          if (isDirty)
              JOptionPane.showMessageDialog(this,"prompt for saving");
          else {
              txtMain.setText("");
              isDirty=false;
              filename = "";
              path = "";
          }
      else if (src==mnuFileOpen)
          openFile();
      else if (src==mnuFileSave)
          if (filename!="")
              saveFile(path, filename);
          else
              saveFile();
      else if (src==mnuFileSaveAs)
          saveFile();
      else if (src==mnuFileExit)
          System.exit(0);



  }

  public void windowClosing(WindowEvent e) {

    System.exit(0);

  }

  public void windowActivated(WindowEvent e) {}

  public void windowClosed(WindowEvent e) {}

  public void windowDeactivated(WindowEvent e) {}

  public void windowDeiconified(WindowEvent e) {}

  public void windowIconified(WindowEvent e) {}

  public void windowOpened(WindowEvent e) {}

  private void saveFile() {

      FileDialog fd = new FileDialog(this,"Choose File", FileDialog.SAVE);
      fd.show();
      String sFileName = fd.getFile();
      String sPath = fd.getDirectory();
      if (sFileName!=null)
          saveFile(sPath, sFileName);
  }

  private void saveFile(String sPath, String sFileName) {
      try {

          FileWriter fw = new FileWriter(sPath+sFileName);
          BufferedWriter bw = new BufferedWriter(fw);
          String sText = txtMain.getText();
          int nCharsWritten=sText.length();
          bw.write(txtMain.getText(),0,nCharsWritten);
          bw.close();
          fw.close();
          filename = sFileName;
          path = sPath;
      } catch (IOException e) {
          JOptionPane.showMessageDialog(this, "Error writing to file");
      }

  }

  private void openFile() {

      FileDialog fd = new FileDialog(this,"Choose File", FileDialog.LOAD);
      fd.show();
      String sFileName = fd.getFile();
      String sPath = fd.getDirectory();
      if (sFileName!=null)
          try {

              FileReader fr = new FileReader(sPath + sFileName);
              BufferedReader br = new BufferedReader(fr);
              boolean eof=false;
              String sText = new String();
              while (!eof) {
                  String line=br.readLine();
                  if (line==null)
                    eof=true;
                  else
                    sText=sText+line+"\n";
              }
              br.close();
              fr.close();
              txtMain.setText(sText);
              filename = sFileName;
              path = sPath;
          } catch (IOException e) {
              JOptionPane.showMessageDialog(this,"Error opening file.");      
          }
  }
}