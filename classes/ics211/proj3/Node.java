//****************************************************************************************
/*

Programmer:      David J. Burger
Project Number:  3
Course:          ICS 211
Filename:        Node.java

Class Description:  This is a class to be used as a node object used in the
    implementation of a reference based stack.

    Node(Object anObject) - Creates a new Node object with the item field set to the
        Object anObject

    Node(Object anObject, Node nextNode) - Creates a new Node object with the item field
        set to Object anObject and the Node next set to Node nextNode

    public void setNext(Node nextNode) - Sets the Node next reference to the Node held in
        Node nextNode

    public Node getNext() - Returns a reference to the Node object held in the Node next
        data field.
    
    public Object getItem() - Returns a reference to the Object held in the Object item
        reference variable.
            
*/
//****************************************************************************************
public class Node {

    //private data fields
    private Object item;
    private Node next;

    //Purpose:  to create a node object
    //Preconditions:  the data the node is to hold is passed in
    //Postconditions:  a node object is returned with the item
    //    set to the object passed in and the next node set
    //    to null.
    Node(Object anObject) {
        item = anObject;
        //yeah, by default
        next = null;
    }

    //Purpose:  to create a node object
    //Preconditions:  the data the node is to hold is passed in
    //    and the node this node should hold in its next reference
    //    is also passed in
    //Postconditions:  a node object is returned with the item
    //    set to the object passed in and the next node set
    //    to the node passed in as nextNode
    Node(Object anObject, Node nextNode) {
        this(anObject);
        next = nextNode;
    }

    //Purpose:  to set the next reference to a node
    //Preconditions:  the node to set the next reference to
    //    is passed in as Node nextNode
    //Postconditions:  the next reference of the node is
    //    is set to Node nextNode
    public void setNext(Node nextNode) {
        next = nextNode;
    }

    //Purpose:  to get the reference held by next
    //Preconditions:  none
    //Postconditions:  the Node reference held by next
    //    is returned
    public Node getNext() {
        return next;
    }

    //Purpose:  to return the Object held in the item data
    //    field
    //Preconditions:  none
    //Postconditions:  the Object item reference is returned
    public Object getItem() {
        return item;
    }


}
