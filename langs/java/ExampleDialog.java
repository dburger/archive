import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.BorderLayout;
import java.awt.FlowLayout;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

public class ExampleDialog extends JDialog {

  public static final int CANCEL = 0;
  public static final int OK = 1;

  private int modalResult = ExampleDialog.CANCEL;

  private JTextField nameTextField = null;

  public ExampleDialog(JFrame parent, String title) {
    super(parent, title, true);
    initComponents(parent);
    pack();
    setResizable(false);
    setLocationRelativeTo(parent);
    this.nameTextField.requestFocus();
  }

  public int showNameChooser() {
    show();
    return this.modalResult;
  }

  private void initComponents(JFrame parent) {
    /*
    Note that by default we have:

    setDefaultCloseOperation(JDialog.HIDE_ON_CLOSE);

    it can also be set to JDialog.DO_NOTHING_ON_CLOSE
                      and JDialog.DISPOSE_ON_CLOSE

    This is usually what you want unless you want to do some special processing
    when they try to close using the window controls.  If you do want special
    processing then you will have adjust the setDefaultCloseOperation
    accordingly and also add the following to catch the close:

    addWindowListener(new WindowAdapter() {
        public void windowClosing(WindowEvent evt) {
          whatever();
        }
    });
    */

    JPanel southPanel = new JPanel();
    southPanel.setLayout(new FlowLayout(FlowLayout.RIGHT));

    JButton okButton = new JButton();
    okButton.setMnemonic('O');
    okButton.setText("OK");
    okButton.addActionListener(new ActionListener() {
        public void actionPerformed(ActionEvent evt) {
          okButtonClicked(evt);
        }
    });
    southPanel.add(okButton);

    JButton cancelButton = new JButton();
    cancelButton.setMnemonic('C');
    cancelButton.setText("Cancel");
    cancelButton.addActionListener(new ActionListener() {
        public void actionPerformed(ActionEvent evt) {
          closeDialog();
        }
    });
    southPanel.add(cancelButton);

    getContentPane().add(southPanel, BorderLayout.SOUTH);

    JPanel centerPanel = new JPanel();

    JLabel nameLabel = new JLabel("Name:");
    centerPanel.add(nameLabel);

    nameTextField = new JTextField(20);
    centerPanel.add(nameTextField);

    getContentPane().add(centerPanel, BorderLayout.CENTER);

  }

  private void okButtonClicked(ActionEvent evt) {
    this.modalResult = ExampleDialog.OK;
    closeDialog();
  }

  private void closeDialog() {
    setVisible(false);
    dispose();
  }

  public String getName() {
    return this.nameTextField.getText();
  }

  public static void main(String args[]) {
    ExampleDialog ed = new ExampleDialog(new JFrame(), "Example Dialog");
    int res = ed.showNameChooser();
    if (res == ExampleDialog.OK) {
      System.out.println(ed.getName());
    } else {
      System.out.println("canceled");
    }
  }

}
