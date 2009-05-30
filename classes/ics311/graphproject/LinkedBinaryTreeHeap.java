/**
 * Represents Heap Priority Queue P, which an ADT for storing
 * a collection of prioritized elements that supports arbitrary element
 * insertion but supports removal of elements only in order of priority;
 * that is only the element with first priority can be removed at any time.
 *
 * @author Swee Lee Jim, Alan Wong, Kin Lik Wang
 * @company SAK Company
 * @version 1.1 */
public class LinkedBinaryTreeHeap implements PriorityQueue{

  LinkedBinaryTree T;
  Position last;
  Comparator comparator;

    /* constuctor for HeapSimplePriorityQueue */
  public LinkedBinaryTreeHeap(Comparator c) {
    comparator = c;
    T =  new LinkedBinaryTree();
  }

  /**
   * Insert a new element e with key k into P
   *
   * @param Object k = key
   * @param Object e = element
   */
  public void insertItem(Object k, Object e) throws InvalidKeyException {
    if (!comparator.isComparable(k))
      throw new InvalidKeyException("Invalid Key");
    Position z; // insertion position
    if (isEmpty())
      z = T.root();
    else {
      z = last;
      while (!T.isRoot(z) && !isLeftChild(z))
	      z = T.parent(z);
      if (!T.isRoot(z))
	      z = T.rightChild(T.parent(z));
      while (!T.isExternal(z))
	      z = T.leftChild(z);
    }
    T.expandExternal(z);
    T.replace(z, new Item(k, e));
    last = z;
    Position u;
    while (!T.isRoot(z)) { // up-heap bubbling
      u = T.parent(z);
      if (comparator.isLessThanOrEqualTo(keyOfPosition(u),
					 keyOfPosition(z))) break;
      T.swap(u, z);
      z = u;
    }
  }

  /**
   * Return (but do not remove) an element of P with smallest
   * key; an error condition occurs if the priority queue is
   * empty.
   *
   * @param none
   * @return Object = element
   */
  public Object minElement() {
    return element(T.root());
  }

  /**
   * Return a smallest key in P; an error condition occurs if
   * the priority queue is empty.
   *
   * @param none
   * @return Object = key
   */
  public Object minKey() {
    return key(T.root());
  }

  /**
   * Remove from P and return an element with smallest key;
   * an error condition occurs if the priority queue is empty.
   *
   * @param none
   * @return Object = element
   */
  public Object removeMinElement(){
    Position left, right, cursor;
    Object answer = element(T.root());
    Position temp = last;
    if (size() == 1) {
      T.removeAboveExternal(T.rightChild(last));
      T.setRoot(null);
      return answer;
    }
    Object min = T.replace(T.root(), last.element());
    if (isLeftChild(last)) {
        while(isLeftChild(last)) {
          last = T.parent(last);
          if (T.isRoot(last))
            break;
        }
        if (!T.isRoot(last)) {
          last = T.rightChild(T.leftChild(T.parent(last)));
          while (T.isInternal(last)) {
            last = T.rightChild(last);
          }
          last = T.parent(last);
        } else {
          last = T.rightChild(last);
          while(T.isInternal(last)) {
            last = T.rightChild(last);
          }
          last = T.parent(last);
        }
    } else {
      last = T.leftChild(T.parent(last));
    }
    T.removeAboveExternal(T.leftChild(temp));
    cursor = T.root();
    while(T.isInternal(T.leftChild(cursor))) {   //if cursor's leftchild is not null
      left = T.leftChild(cursor);
      right = T.rightChild(cursor);
      if(right.element() == null){
         if (comparator.isLessThanOrEqualTo(keyOfPosition(left), keyOfPosition(cursor))) {
          T.swap(cursor, left);
          cursor = T.leftChild(cursor);
         }
          else
            break;
      }
      else if (comparator.isGreaterThan(keyOfPosition(cursor), keyOfPosition(left)) ||
       comparator.isGreaterThan(keyOfPosition(cursor), keyOfPosition(right))) {
        if (comparator.isLessThanOrEqualTo(keyOfPosition(left), keyOfPosition(right))) {
          T.swap(cursor, left);
          cursor = T.leftChild(cursor);
        }
        else {
          T.swap(cursor, right);
          cursor = T.rightChild(cursor);
        }
      }
      else
        break;
    }
    return answer;
  }

  // Container methods
  /**
   * returns how many elements are in the container.
   *
   * @return int = number of elements in the container.
   */
  public int size() {
    return (T.size()-1)/2;
  }

  /**
   * returns true if the container is empty, false otherwise.
   *
   * @return boolean true if container is empty
   */
  public boolean isEmpty() {
    return (this.size() == 0);
  }

  // Auxiliary methods
  /**
   * Return the key at Postion p
   *
   * @param Position p = a node in the tree
   * @return Object = key
   */
  protected Object key(Position p)  {
    return ((Item) p.element()).key();
  }

  /**
   * Return the element at Postion p
   *
   * @param Position p = a node in the tree
   * @return Object = element
   */
  protected Object element(Position p)  {
    return ((Item) p.element()).element();
  }

  //Helper methods
  /**
   * Returns the key of position
   *
   * @param Position p = a node in the tree
   * @return Object = key
   */
  private Object keyOfPosition(Position p) throws InvalidPositionException {
    return ((Item)p.element()).key();
  }

  /**
   * Check the position if left child of the tree
   * true if position is left child
   * false if position is right child
   *
   * @param Position p = a node in the tree
   * @return Object = key
   */
  private boolean isLeftChild(Position p) throws InvalidPositionException {
    try {
      return T.leftChild(T.parent(p)).equals(p);
    } catch (BoundaryViolationException e) {
      return false;
    }
  }

}
