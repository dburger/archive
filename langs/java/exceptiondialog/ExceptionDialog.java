import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.Component;
import java.awt.Dialog;
import java.awt.Frame;
import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.StringSelection;
import java.awt.datatransfer.Transferable;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowEvent;
import java.awt.event.WindowAdapter;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.io.PrintStream;
import javax.swing.Icon;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;
import javax.swing.JTextArea;

/**
 * A tabbed dialog box that presents a <code>JOptionPane</code> on one tab and
 * detailed <code>Exception</code> information on another tab.  Usage is
 * similar to <code>JOptionPane</code> with the addition of an
 * <code>Exception</code> parameter.
 * Example usage:
<pre>
// say you have just caught exception e, and you want to give them the
// options of yes, no, or cancel
ExceptionDialog ed =
  new ExceptionDialog(parent, "The Title", "This is the message.",
    JOptionPane.ERROR_MESSAGE, JOptionPane.YES_NO_CANCEL_OPTION, e);
ed.show();
switch (ed.getValue()) {
  case ExceptionDialog.YES_OPTION:
  ...
}
</pre>
 *
 * @author David J. Burger
 */
public class ExceptionDialog extends JDialog {

  /** Value returned with the user selects the yes option. */
  public static final int YES_OPTION = JOptionPane.YES_OPTION;
  /** Value returned with the user selects the no option. */
  public static final int NO_OPTION = JOptionPane.NO_OPTION;
  /** Value returned with the user selects the cancel option. */
  public static final int CANCEL_OPTION = JOptionPane.CANCEL_OPTION;
  /** Value returned with the user selects the ok option. */
  public static final int OK_OPTION = JOptionPane.OK_OPTION;
  /** Value returned with the user closes the window without selecting. */
  public static final int CLOSED_OPTION = JOptionPane.CLOSED_OPTION;

  /** Indicates a dialog box with default buttons. */
  public static final int DEFAULT_OPTION = JOptionPane.DEFAULT_OPTION;
  /** Indicates a dialog box with yes and no buttons. */
  public static final int YES_NO_OPTION = JOptionPane.YES_NO_OPTION;
  /** Indicates a dialog box with yes, no, and cancel buttons. */
  public static final int YES_NO_CANCEL_OPTION =
    JOptionPane.YES_NO_CANCEL_OPTION;
  /** Indicates a dialog box with ok and cancel buttons. */
  public static final int OK_CANCEL_OPTION = JOptionPane.OK_CANCEL_OPTION;

  /** Parent used for centering this dialog. */
  private Component parentComponent = null;

  /** The option pane to be displayed on the first tab. */
  private JOptionPane optionPane = null;

  /** Exception that is the reason for this dialog. */
  private Exception cause = null;

  /**
   * The exception information, message + stack trace, to be included on
   * the second tab.
   */
  private String exceptionDetail = null;

  /** The result of this dialog box which the user can retrive. */
  private int value;

  // JDialog has constructors for Frame and Dialog instead of a unified set
  // of constructors for a parent class like Component, so we have many!!

  /**
   * Creates a modal dialog with the given parent <code>Frame</code>, title,
   * and cause.
   *
   * @param parentFrame the parent of this dialog, for centering
   * @param title title for this dialog box
   * @param cause <code>Exception</code> this dialog is being displayed for
   */
  protected ExceptionDialog(Frame parentFrame, String title, Exception cause) {
    super(parentFrame, title, true);
    this.parentComponent = parentFrame;
    this.cause = cause;
  }

  /**
   * Creates a modal dialog with the given parent <code>Dialog</code>, title,
   * and cause.
   *
   * @param parentDialog the parent of this dialog, for centering
   * @param title title for this dialog box
   * @param cause <code>Exception</code> this dialog is being displayed for
   */
  protected ExceptionDialog(Dialog parentDialog, String title,
    Exception cause) {
    super(parentDialog, title, true);
    this.parentComponent = parentDialog;
    this.cause = cause;
  }

  /**
   * Creates a modal dialog with the given parent <code>Frame</code>, title,
   * message, and cause.
   *
   * @param parentFrame the parent of this dialog, for centering
   * @param title title for this dialog box
   * @param message message to display in the option pane
   * @param cause <code>Exception</code> this dialog is being displayed for
   */
  public ExceptionDialog(Frame parentFrame, String title, Object message,
    Exception cause) {
    this(parentFrame, title, cause);
    this.optionPane = new JOptionPane(message);
    initComponents();
  }

  /**
   * Creates a modal dialog with the given parent <code>Dialog</code>, title,
   * message, and cause.
   *
   * @param parentDialog the parent of this dialog, for centering
   * @param title title for this dialog box
   * @param message message to display in the option pane
   * @param cause <code>Exception</code> this dialog is being displayed for
   */
  public ExceptionDialog(Dialog parentDialog, String title, Object message,
    Exception cause) {
    this(parentDialog, title, cause);
    this.optionPane = new JOptionPane(message);
    initComponents();
  }

  /**
   * Creates a modal dialog with the given parent <code>Frame</code>, title,
   * message, and cause.
   *
   * @param parentFrame the parent of this dialog, for centering
   * @param title title for this dialog box
   * @param message message to display in the option pane
   * @param messageType defines the style of the message
   * @param cause <code>Exception</code> this dialog is being displayed for
   */
  public ExceptionDialog(Frame parentFrame, String title, Object message,
    int messageType, Exception cause) {
    this(parentFrame, title, cause);
    this.optionPane = new JOptionPane(message, messageType);
    initComponents();
  }

  /**
   * Creates a modal dialog with the given parent <code>Dialog</code>, title,
   * message, and cause.
   *
   * @param parentDialog the parent of this dialog, for centering
   * @param title title for this dialog box
   * @param message message to display in the option pane
   * @param messageType defines the style of the message
   * @param cause <code>Exception</code> this dialog is being displayed for
   */
  public ExceptionDialog(Dialog parentDialog, String title, Object message,
    int messageType, Exception cause) {
    this(parentDialog, title, cause);
    this.optionPane = new JOptionPane(message, messageType);
    initComponents();
  }

  /**
   * Creates a modal dialog with the given parent <code>Frame</code>, title,
   * message, and cause.
   *
   * @param parentFrame the parent of this dialog, for centering
   * @param title title for this dialog box
   * @param message message to display in the option pane
   * @param messageType defines the style of the message
   * @param optionType defines the set of buttons that appear
   * @param cause <code>Exception</code> this dialog is being displayed for
   */
  public ExceptionDialog(Frame parentFrame, String title, Object message,
    int messageType, int optionType, Exception cause) {
    this(parentFrame, title, cause);
    this.optionPane = new JOptionPane(message, messageType, optionType);
    initComponents();
  }

  /**
   * Creates a modal dialog with the given parent <code>Dialog</code>, title,
   * message, and cause.
   *
   * @param parentDialog the parent of this dialog, for centering
   * @param title title for this dialog box
   * @param message message to display in the option pane
   * @param messageType defines the style of the message
   * @param optionType defines the set of buttons that appear
   * @param cause <code>Exception</code> this dialog is being displayed for
   */
  public ExceptionDialog(Dialog parentDialog, String title, Object message,
    int messageType, int optionType, Exception cause) {
    this(parentDialog, title, cause);
    this.optionPane = new JOptionPane(message, messageType, optionType);
    initComponents();
  }

  /**
   * Creates a modal dialog with the given parent <code>Frame</code>, title,
   * message, and cause.
   *
   * @param parentFrame the parent of this dialog, for centering
   * @param title title for this dialog box
   * @param message message to display in the option pane
   * @param messageType defines the style of the message
   * @param optionType defines the set of buttons that appear
   * @param icon the icon to display
   * @param cause <code>Exception</code> this dialog is being displayed for
   */
  public ExceptionDialog(Frame parentFrame, String title, Object message,
    int messageType, int optionType, Icon icon, Exception cause) {
    this(parentFrame, title, cause);
    this.optionPane = new JOptionPane(message, messageType, optionType, icon);
    initComponents();
  }

  /**
   * Creates a modal dialog with the given parent <code>Dialog</code>, title,
   * message, and cause.
   *
   * @param parentDialog the parent of this dialog, for centering
   * @param title title for this dialog box
   * @param message message to display in the option pane
   * @param messageType defines the style of the message
   * @param optionType defines the set of buttons that appear
   * @param icon the icon to display
   * @param cause <code>Exception</code> this dialog is being displayed for
   */
  public ExceptionDialog(Dialog parentDialog, String title, Object message,
    int messageType, int optionType, Icon icon, Exception cause) {
    this(parentDialog, title, cause);
    this.optionPane = new JOptionPane(message, messageType, optionType, icon);
    initComponents();
  }

  /**
   * Creates a modal dialog with the given parent <code>Frame</code>, title,
   * message, and cause.
   *
   * @param parentFrame the parent of this dialog, for centering
   * @param title title for this dialog box
   * @param message message to display in the option pane
   * @param messageType defines the style of the message
   * @param optionType defines the set of buttons that appear
   * @param icon the icon to display
   * @param options array of objects representing the possible choices
   * @param cause <code>Exception</code> this dialog is being displayed for
   */
  public ExceptionDialog(Frame parentFrame, String title, Object message,
    int messageType, int optionType, Icon icon, Object[] options,
    Exception cause) {
    this(parentFrame, title, cause);
    this.optionPane =
      new JOptionPane(message, messageType, optionType, icon, options);
    initComponents();
  }

  /**
   * Creates a modal dialog with the given parent <code>Dialog</code>, title,
   * message, and cause.
   *
   * @param parentDialog the parent of this dialog, for centering
   * @param title title for this dialog box
   * @param message message to display in the option pane
   * @param messageType defines the style of the message
   * @param optionType defines the set of buttons that appear
   * @param icon the icon to display
   * @param options array of objects representing the possible choices
   * @param cause <code>Exception</code> this dialog is being displayed for
   */
  public ExceptionDialog(Dialog parentDialog, String title, Object message,
    int messageType, int optionType, Icon icon, Object[] options,
    Exception cause) {
    this(parentDialog, title, cause);
    this.optionPane =
      new JOptionPane(message, messageType, optionType, icon, options);
    initComponents();
  }

  /**
   * Creates a modal dialog with the given parent <code>Frame</code>, title,
   * message, and cause.
   *
   * @param parentFrame the parent of this dialog, for centering
   * @param title title for this dialog box
   * @param message message to display in the option pane
   * @param messageType defines the style of the message
   * @param optionType defines the set of buttons that appear
   * @param icon the icon to display
   * @param options array of objects representing the possible choices
   * @param initialValue default selection
   * @param cause <code>Exception</code> this dialog is being displayed for
   */
  public ExceptionDialog(Frame parentFrame, String title, Object message,
    int messageType, int optionType, Icon icon, Object[] options,
    Object initialValue, Exception cause) {
    this(parentFrame, title, cause);
    this.optionPane =
      new JOptionPane(message, messageType, optionType, icon, options,
        initialValue);
    initComponents();
  }

  /**
   * Creates a modal dialog with the given parent <code>Dialog</code>, title,
   * message, and cause.
   *
   * @param parentDialog the parent of this dialog, for centering
   * @param title title for this dialog box
   * @param message message to display in the option pane
   * @param messageType defines the style of the message
   * @param optionType defines the set of buttons that appear
   * @param icon the icon to display
   * @param options array of objects representing the possible choices
   * @param initialValue default selection
   * @param cause <code>Exception</code> this dialog is being displayed for
   */
  public ExceptionDialog(Dialog parentDialog, String title, Object message,
    int messageType, int optionType, Icon icon, Object[] options,
    Object initialValue, Exception cause) {
    this(parentDialog, title, cause);
    this.optionPane =
      new JOptionPane(message, messageType, optionType, icon, options,
        initialValue);
    initComponents();
  }

  /**
   * Initializes the components that are rendered in this dialog.
   */
  private void initComponents() {
    StringBuffer buffer = new StringBuffer();
    this.cause.printStackTrace(
      new PrintStream(new StringBufferOutputStream(buffer)));
    this.exceptionDetail = buffer.toString();

    this.optionPane.addPropertyChangeListener(new PropertyChangeListener() {
        public void propertyChange(PropertyChangeEvent evt) {
          optionPanePropertyChange(evt);
        }
    });

    JTextArea textArea =
      new JTextArea(this.exceptionDetail);
    textArea.setEditable(false);

    JButton copyButton = new JButton("Copy to Clipboard");
    copyButton.addActionListener(new ActionListener() {
      public void actionPerformed(ActionEvent evt) {
        copyButtonActionPerformed(evt);
      }
    });

    JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT));
    buttonPanel.add(copyButton);

    JPanel detailPanel = new JPanel(new BorderLayout());
    detailPanel.add(new JScrollPane(textArea), BorderLayout.CENTER);
    detailPanel.add(buttonPanel, BorderLayout.SOUTH);

    JTabbedPane tabbedPane = new JTabbedPane();
    tabbedPane.add("Message", this.optionPane);
    getContentPane().add(tabbedPane);
    // pack() before adding detail so that dialgo is sized for the option pane
    pack();
    tabbedPane.add("Detail", detailPanel);

    setDefaultCloseOperation(JDialog.DO_NOTHING_ON_CLOSE);
    addWindowListener(new WindowAdapter() {
      public void windowClosing(WindowEvent evt) {
        dialogClosing(evt);
      }
    });

    setLocationRelativeTo(parentComponent);
  }

  public void dialogClosing(WindowEvent evt) {
    this.value = JOptionPane.CLOSED_OPTION;
    hide();
  }

  /**
   * Callback for the option pane's <code>PropertyChangeEvent</code>.
   *
   * @param evt <code>PropertyChangeEvent</code> causing the callback
   */
  public void optionPanePropertyChange(PropertyChangeEvent evt) {
    if (isVisible() && evt.getSource() == this.optionPane) {
      // ignore reseting the value
      if (this.optionPane.getValue() == JOptionPane.UNINITIALIZED_VALUE) {
        return;
      }
      this.value = ((Integer)this.optionPane.getValue()).intValue();
      // reset if they decide to disply again
      this.optionPane.setValue(JOptionPane.UNINITIALIZED_VALUE);
      hide();
    }
  }

  /**
   * Callback for the copy to clipboard button's <code>ActionEvent</code>.
   *
   * @param evt <code>ActionEvent</code> causing the callback
   */
  public void copyButtonActionPerformed(ActionEvent evt) {
    Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
    StringSelection data = new StringSelection(this.exceptionDetail);
    // the StringSelection class also implements ClipboardOwner doing nothing
    // on the lostOwnership callback
    clipboard.setContents(data, data);
  }

  /**
   * Returns the result of displaying the dialog, as per JOptionPane
   * interaction.
   *
   * @return the result of displaying the dialog
   */
  public int getValue() {
    return this.value;
  }

  public static void main(String[] args) {
    ExceptionDialog ed =
      new ExceptionDialog((Frame)null, "The Title", "This is the message.",
        JOptionPane.ERROR_MESSAGE, JOptionPane.YES_NO_CANCEL_OPTION,
        new Exception("foo"));
    ed.show();
  }

}
