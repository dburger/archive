/**
 * Priority Queue interface.
 * 
 * @author digitalOverflow
 */
public interface PriorityQueue {
    /**
     * Returns the number of items in the Priority Queue.
     * 
     * @return the number of items in the Priority Queue
     */
    public int size();

    /**
     * Used to determine whether or not the Priority Queue is empty.
     * 
     * @return true if empty, otherwise false
     */
    public boolean isEmpty();

    /**
     * Inserts the given object with the given key in the Priority Queue.
     * 
     * @param k      The key for the given object.
     * @param e      The object to insert in the Priority Queue.
     * @exception InvalidKeyException
     *                   thrown if the key is reported as invalid by the Comparator
     */
    public void insertItem(Object k, Object e) throws InvalidKeyException;

    /**
     * Returns the element in the Priority Queue with the smallest key.
     * 
     * @return the element in the Priority Queue with the smallest key
     * @exception EmptyQueueException
     *                   thrown when minElement() is attempted on an empty Priority Queue
     */
    public Object minElement() throws EmptyContainerException;

    /**
     * Returns the minimum key in the Priority Queue.
     * 
     * @return the minimum key in the Priority Queue
     * @exception EmptyQueueException
     *                   thrown when minKey() is attempted on an empty Priority Queue
     */
    public Object minKey() throws EmptyContainerException;

    /**
     * Returns and removes the element with the minimum key from the Priority Queue.
     * 
     * @return the element with the minimum key in the Priority Queue.
     * @exception EmptyQueueException
     *                   thrown when removeMinElement() is attempted on an empty Priority Queue
     */
    public Object removeMinElement() throws EmptyContainerException;

}
