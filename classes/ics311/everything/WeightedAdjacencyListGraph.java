import java.util.Enumeration;
import java.util.StringTokenizer;
import java.util.Hashtable;
/**
 * A weighted directed adjacency list graph implementation 
 * 
 * @author digitalOverflow
 */
public class WeightedAdjacencyListGraph extends AdjacencyListGraph {
    
    /**
     * Inserts a new directed WeightedEdge into the graph with end
     * Vertices given by Positions vp, the origin, and wp,
     * the destination, storing Object o, and weight 0
     * returns a Position object for the new Edge
     *
     * @param vp     Position holding the origin Vertex
     * @param wp     Position holding the destination Vertex
     * @param o      Object to store at the new Edge
     * @return Position containing the new Edge object
     * @exception InvalidPositionException
     *                   thrown if either of the given vertices are invalid for
     *                   this container
     */
    public Position insertDirectedEdge(Position vp, Position wp, Object o) throws InvalidPositionException {
        Vertex v = checkVertexPosition(vp);
        Vertex w = checkVertexPosition(wp);
        //adding to the incident containers for v and w
        //is done in this constructor
        WeightedEdge e = new WeightedEdge(o,E,true,v,w,0);
        Position pos = E.insertLast(e);
        e.setContainerPosition(pos);
        return e;
    }

    /**
     * Inserts a new directed WeightedEdge into the graph with end
     * Vertices given by Positions vp, the origin, and wp,
     * the destination, storing Object o, and weight
     * returns a Position object for the new WeightedEdge
     *
     * @param vp     Position holding the origin Vertex
     * @param wp     Position holding the destination Vertex
     * @param o      Object to store at the new WeightedEdge
     * @param weight weight to store at the new WeightedEdge
     * @return Position containing the new WeightedEdge object
     * @exception InvalidPositionException
     *                   thrown if either of the given vertices are invalid for
     *                   this container
     */
    public Position insertDirectedEdge(Position vp, Position wp, Object o, int weight) throws InvalidPositionException {
        Vertex v = checkVertexPosition(vp);
        Vertex w = checkVertexPosition(wp);
        //adding to the incident containers for v and w
        //is done in this constructor
        WeightedEdge e = new WeightedEdge(o,E,true,v,w,weight);
        Position pos = E.insertLast(e);
        e.setContainerPosition(pos);
        return e;
    }

    /**
     * Inserts a new undirected WeightedEdge into the graph with end
     * Vertices given by Positions vp and wp storing Object o, and weight 0
     * returns a Position object for the new WeightedEdge
     *
     * @param vp     Position holding one Vertex endpoint
     * @param wp     Position holding the other Vertex endpoint
     * @param o      Object to store at the new WeightedEdge
     * @return Position containing the new WeightedEdge object
     * @exception InvalidPositionException
     *                   thrown if either of the given vertices are invalid for
     *                   this container
     */
    public Position insertEdge(Position vp, Position wp, Object o) throws InvalidPositionException {
        Vertex v = checkVertexPosition(vp);
        Vertex w = checkVertexPosition(wp);
        //adding to the incident containers for v and w
        //is done in this constructor
        WeightedEdge e = new WeightedEdge(o,E,false,v,w,0);
        Position pos = E.insertLast(e);
        e.setContainerPosition(pos);
        return e;
    }

    /**
     * Inserts a new undirected WeightedEdge into the graph with end
     * Vertices given by Positions vp and wp storing Object o, and weight
     * returns a Position object for the new Edge
     *
     * @param vp     Position holding one Vertex endpoint
     * @param wp     Position holding the other Vertex endpoint
     * @param o      Object to store at the new WeightedEdge
     * @param weight weight to store at the new WeightedEdge
     * @return Position containing the new WeightedEdge object
     * @exception InvalidPositionException
     *                   thrown if either of the given vertices are invalid for
     *                   this container
     */
    public Position insertEdge(Position vp, Position wp, Object o, int weight) throws InvalidPositionException {
        Vertex v = checkVertexPosition(vp);
        Vertex w = checkVertexPosition(wp);
        //adding to the incident containers for v and w
        //is done in this constructor
        WeightedEdge e = new WeightedEdge(o,E,false,v,w,weight);
        Position pos = E.insertLast(e);
        e.setContainerPosition(pos);
        return e;
    }

    /**
     * Inserts a new LabeledVertex into the graph holding Object o with label 0
     * and returns a Position holding the new Vertex
     *
     * @param o      the Object to hold in this Vertex
     * @return the Position holding the Vertex
     */
    public Position insertVertex(Object o) {
        LabeledVertex v = new LabeledVertex(o,V,0);
        Position pos = V.insertLast(v);
        v.setContainerPosition(pos);
        return v;
    }

    /**
     * Inserts a new LabeledVertex into the graph holding Object o with label l
     * and returns a Position holding the new LabeledVertex
     *
     * @param o      the Object to hold in this LabeledVertex
     * @param l      the label to hold in this LabeledVertext
     * @return the Position holding the Vertex
     */
    public Position insertVertex(Object o, int l) {
        LabeledVertex v = new LabeledVertex(o,V,l);
        Position pos = V.insertLast(v);
        v.setContainerPosition(pos);
        return v;
    }

    /**
     * Returns the edge weight for the WeightedEdge in the passed
     * in Position ep
     * 
     * @param ep     Position object holding WeightedEdge to return the weight of
     * @return weight of the passed in WeightedEdge
     * @exception InvalidPositionException
     *                   thrown if ep does not contain a valid Position for this Container
     */
    public int getEdgeWeight(Position ep) throws InvalidPositionException {
        WeightedEdge e = (WeightedEdge)checkEdgePosition(ep);
        return e.getWeight();
    }

    /**
     * Sets the edge weight for the WeightedEdge in the passed
     * in Position ep
     * 
     * @param ep     Position object holding the WeightedEdge to set the weight of
     * @param w      new weight for the given WeightedEdge
     * @exception InvalidPositionException
     *                   thrown if the given WeightedEdge is invalid for this Container
     */
    public void setEdgeWeight(Position ep, int w) throws InvalidPositionException {
        WeightedEdge e = (WeightedEdge)checkEdgePosition(ep);
        e.setWeight(w);
    }

    /**
     * Returns the label for the LabeledVertex in the passed
     * in Position vp
     * 
     * @param vp     Position object holding LabeledVertex to return the label of
     * @return label of the passed in LabeledVertex
     * @exception InvalidPositionException
     *                   thrown if vp does not contain a valid Position for this Container
     */
    public int getVertexLabel(Position vp) throws InvalidPositionException {
        LabeledVertex v = (LabeledVertex)checkVertexPosition(vp);
        return v.getLabel();
    }

    /**
     * Sets the vertex label for the LabeledVertex in the passed
     * in Position vp
     * 
     * @param ep     Position object holding the LabeledVertex to set the label of
     * @param l      new label for the given LabeledVertex
     * @exception InvalidPositionException
     *                   thrown if the given LabeledVertex is invalid for this Container
     */
    public void setVertexLabel(Position vp, int l) throws InvalidPositionException {
        LabeledVertex v = (LabeledVertex)checkVertexPosition(vp);
        v.setLabel(l);
    }

    /**
     * Returns the maximum flow for this graph from Vertex src
     * to Vertex snk using the findPath method defined in object
     * PathFinder to determine augmenting paths
     * 
     * @param src    source vertex for max flow
     * @param snk    sink vertex for max flow
     * @param pf     a PathFinder object implementing the findPath method
     *               for determining the next augmenting path
     * @return the maximum flow of the graph from source to sink
     */
    public int getMaxFlow(LabeledVertex src, LabeledVertex snk, PathFinder pf) {
        //create the residual graph based on the flows on the edges
        ResidualGraphResult R = getResidualGraph(true);
        //find the augmenting path using our passed in PathFinder object
        Enumeration path = pf.findPath(R.getGraph(),R.getCorresVertex(src),R.getCorresVertex(snk));
        while (path.hasMoreElements()) {
            //find the edge with the least capacity along the found path
            int smallestWeight = Integer.MAX_VALUE;
            while (path.hasMoreElements()) {
                WeightedEdge e = (WeightedEdge)path.nextElement();
                if (e.getWeight()<smallestWeight)
                    smallestWeight = e.getWeight();            
            }
            //uncomment to get feedback during testing
            //System.out.println("augmenting:  " + smallestWeight);
            //enumerate back through and augment each edge smallestWeight amount
            ((SequenceEnumerator)path).reset();
            while (path.hasMoreElements()) {
                //get the corresponding edge in this graph
                WeightedEdge edgeInResidual = (WeightedEdge)path.nextElement();
                WeightedEdge e = (WeightedEdge)edgeInResidual.element();
                //augment
                increaseFlow((WeightedEdge)e,smallestWeight);
                //find the back edge
                LabeledVertex orig = (LabeledVertex)e.getOrigVertex();
                LabeledVertex dest = (LabeledVertex)e.getDestVertex();
                Enumeration inEdges = inIncidentEdges(orig);
                while (inEdges.hasMoreElements()) {
                    WeightedEdge we = (WeightedEdge)inEdges.nextElement();
                    if (we.getOrigVertex()==dest) {
                        //decrease the back edges flow by the same amount augmented
                        decreaseFlow((WeightedEdge)we,smallestWeight);
                        break;
                    }
                }
            }
            //create the residual graph again
            R = getResidualGraph(false);
            //get the next augmenting path
            path = pf.findPath(R.getGraph(),R.getCorresVertex(src),R.getCorresVertex(snk));
        }
        //returning the flow total going out of the source by enumerating the outgoing edges from source
        int maxFlow = 0;
        Enumeration edges = outIncidentEdges(src);
        while (edges.hasMoreElements()) {
            WeightedEdge e = (WeightedEdge)edges.nextElement();
            maxFlow+= getCurrFlow(e.getTag());
        }
        return maxFlow;
    }

    /**
     * This method computes a residual graph for this graph and
     * returns the graph along with a Hashtable containing the
     * vertices of the residual graph indexed by the vertices of
     * the original graph in a ResidualGraphResult object
     * 
     * @param labelFlow true to label flow, false otherwise.  If true markers
     *                  are set within this graph in the tag fields that indicate
     *                  flow/capacity/residual.  This should be called with true
     *                  on a first call and false on subsequent calls for max flow
     *                  problems
     * @return a ResidualGraphResult object returning the residual graph
     *         and a Hashtable with the vertices of the residual graph
     *         indexed by their corresponding vertices in the original
     *         graph
     */
    public ResidualGraphResult getResidualGraph(boolean labelFlow) {
        //the first time this is called using getMaxFlow labelFlow is set to true and the
        //  flow/capacity/residual standard is put into the tag variable for each edge,
        //on subsequent calls to getResidualGraph labeling should be set to false so that
        //the old correct labels will still be there
        Enumeration enum;
        Hashtable verticesInR = new Hashtable();
        if (labelFlow) {
            enum = edges();
            while (enum.hasMoreElements()) {
                WeightedEdge e = (WeightedEdge)enum.nextElement();
                e.setTag("0/" + e.getWeight() + "/" + e.getWeight());
            }
        }
        WeightedAdjacencyListGraph R = new WeightedAdjacencyListGraph();
        //put all the vertices of G in the residual graph R
        enum = vertices();
        while (enum.hasMoreElements()) {
            LabeledVertex v = (LabeledVertex)enum.nextElement();
            LabeledVertex newVertex = (LabeledVertex)R.insertVertex(v);
            verticesInR.put(v,newVertex);
        }
        //put edges of G with residual capacity in R with weight as residual capacity
        enum = edges();
        while (enum.hasMoreElements()) {
            WeightedEdge e = (WeightedEdge)enum.nextElement();
            //using the markers in the tag fields to determine which edges get placed into the
            //original graph...only those where f/c/r indicates r>0 or still has residual capacity
            int resCapacity = getResCapacity(e.getTag());
            if (resCapacity>0) {
                //insert the edge into R
                LabeledVertex origVertex = (LabeledVertex)e.getOrigVertex();
                LabeledVertex destVertex = (LabeledVertex)e.getDestVertex();
                LabeledVertex origInR = (LabeledVertex)verticesInR.get(origVertex);
                LabeledVertex destInR = (LabeledVertex)verticesInR.get(destVertex);
                //this was only doing directed before so it may be more flexible and
                //applicable now
                if (e.isDirected())
                    R.insertDirectedEdge(origInR,destInR,e,resCapacity);
                else
                    R.insertEdge(origInR,destInR,e,resCapacity);
            }
        }

        return new ResidualGraphResult(R,verticesInR);
    }

    /**
     * Returns the residual capacity from a properly formatted
     * tag string (f/c/r where f = flow c = capacity r = residual )
     * 
     * @param tag    tag String to return the residual capcacity of
     * @return the residual capacity held within the tag String
     */
    private int getResCapacity(String tag) {
        StringTokenizer st = new StringTokenizer(tag,"/");
        //residual capacity is third token
        st.nextToken();st.nextToken();
        return Integer.parseInt(st.nextToken());
    }

    /**
     * Returns the current flow from a properly formatted
     * tag string (f/c/r where f = flow c = capacity r = residual )
     * 
     * @param tag    tag String to return the current flow of
     * @return the current flow held within the tag String
     */
    private int getCurrFlow(String tag) {
        StringTokenizer st = new StringTokenizer(tag,"/");
        //current flow is the first token
        return Integer.parseInt(st.nextToken());
    }

    /**
     * Returns the capacity from a properly formatted
     * tag string (f/c/r where f = flow c = capacity r = residual )
     * 
     * @param tag    tag String to return the capcacity of
     * @return the capacity held within the tag String
     */
    private int getCapacity(String tag) {
        StringTokenizer st = new StringTokenizer(tag,"/");
        //residual capacity is second token
        st.nextToken();
        return Integer.parseInt(st.nextToken());
    }


    /**
     * Increases the indicated flow along an edge from a residual
     * graph by adjusting its properly formatted tag string
     * accordinly
     * 
     * flow/capacity/residual
     * 
     * flow is increase by weight
     * residual is decreased by weight
     * 
     * @param e      The edge to increase the flow on
     * @param weight the weight of the increase
     */
    private void increaseFlow(WeightedEdge e, int weight) {
        String tag = e.getTag();
        int flow = getCurrFlow(tag);
        int capacity = getCapacity(tag);
        flow+=weight;
        int residCapacity = capacity - flow;
        e.setTag(flow + "/" + capacity + "/" + residCapacity);
    }

    /**
     * Decreases the flow by calling increaseFlow with a negative
     * amount, see increaseFlow
     * 
     * @param e      Edge to decrease the flow upon
     * @param weight amount to decrease the flow
     */
    private void decreaseFlow(WeightedEdge e, int weight) {
        increaseFlow(e,-1*weight);
    }

    /**
     * Uses Baruvka's algorithm to return a graph representing
     * the MST of this graph, or null if no MST exists
     * 
     * @return MST representation of this graph or null if no such
     *         MST exists
     */
    public WeightedAdjacencyListGraph getBaruvkaMST() {
        //obviously if not enough edges to have a span there is no
        //need to run through the algorithm
        if (numEdges()<numVertices()-1) return null;
        //cluster membership is represented by the values in the label fields of
        //the vertices, initially we put each vertex in its own cluster and add
        //all vertices to our MST T
        Enumeration enum = vertices();
        WeightedAdjacencyListGraph T = new WeightedAdjacencyListGraph();
        Hashtable verticesInT = new Hashtable();
        int i = 0;
        while (enum.hasMoreElements()) {
            LabeledVertex lv = (LabeledVertex)enum.nextElement();
            lv.setLabel(i++);
            LabeledVertex new_lv = (LabeledVertex)T.insertVertex(lv.element());
            verticesInT.put(lv,new_lv);
        }
        //while not enough edges for a span
        while (T.numEdges()<numVertices()-1) {
            boolean addedEdge = false;
            //cycle through all possible cluster numbers
            for (i=0;i<numVertices();i++) {
                WeightedEdge smallestEdge = null;
                boolean alreadyIn = false;
                enum = vertices();
                //this iteration of this while loop will set smallestEdge =
                // the smallesEdge coming out of cluster i
                while (enum.hasMoreElements()) {
                    LabeledVertex lv = (LabeledVertex)enum.nextElement();
                    if (lv.getLabel()==i) {
                        //lv is a member of cluster i
                        Enumeration edges = lv.edges();
                        while (edges.hasMoreElements()) {
                            WeightedEdge temp = (WeightedEdge)edges.nextElement();
                            LabeledVertex opposite = (LabeledVertex)opposite(lv,temp);
                            if (lv.getLabel()!=opposite.getLabel()) {
                                //in different clusters
                                if (smallestEdge==null)
                                    smallestEdge = temp;
                                else
                                    if (temp.getWeight()<smallestEdge.getWeight())
                                        //it beat the smallest edge so far
                                        smallestEdge = temp;
                            }
                        }
                    }
                }
                //if you cycle through an empty cluster smallestEdge is null
                //so we skip adding an edge
                if (smallestEdge!=null) {
                    //we found a smallestEdge out of cluster i that is not already
                    //in T, add it, get the end vertices of smallestEdge in G
                    Position pArray[] = endVertices(smallestEdge);
                    LabeledVertex v = (LabeledVertex)pArray[0];
                    LabeledVertex u = (LabeledVertex)pArray[1];
                    //these will be references to the vertices that represent
                    //v and u in T
                    LabeledVertex vInT = (LabeledVertex)verticesInT.get(v);
                    LabeledVertex uInT = (LabeledVertex)verticesInT.get(u);
                    //insert the new edge in T
                    WeightedEdge newEdge = (WeightedEdge)T.insertEdge(vInT,uInT,smallestEdge.element(),smallestEdge.getWeight());
                    addedEdge = true;
                    //merge the clusters of v and u
                    enum = vertices();
                    int uLabel = u.getLabel();
                    while (enum.hasMoreElements()) {
                        LabeledVertex lv = (LabeledVertex)enum.nextElement();
                        if (lv.getLabel()==uLabel)
                            lv.setLabel(v.getLabel());
                    }
                }
            }
            //if no edge was added through a cyle of clusters then this graph is not
            //connected and has no mst
            if (!addedEdge) return null;
        }
        return T;
    }


    /**
     * Uses Kruskal's algorithm to return a graph representing
     * the MST of this graph, or null if no MST exists
     * 
     * @return MST representation of this graph or null if no such
     *         MST exists
     */
    public WeightedAdjacencyListGraph getKruskalMST() {
        //obviously if not enough edges to have a span there is no
        //need to run through the algorithm
        if (numEdges()<numVertices()-1) return null;
        //using the label field to keep track of cluster membership
        //put each vertex in its own cluster
        Enumeration enum = vertices();
        int i = 0;
        while (enum.hasMoreElements()) {
            LabeledVertex lv = (LabeledVertex)enum.nextElement();
            lv.setLabel(i++);
        }
        LinkedBinaryTreeHeap H = new LinkedBinaryTreeHeap(new IntegerComparator());
        //place all the edges into a heap
        enum = edges();
        while (enum.hasMoreElements()) {
            Position ep = (Position)enum.nextElement();
            H.insertItem(new Integer(getEdgeWeight(ep)),ep);
        }
        WeightedAdjacencyListGraph T = new WeightedAdjacencyListGraph();
        Hashtable verticesInT = new Hashtable();
        //repeat until all edges have been considered
        while (!H.isEmpty()  && T.numEdges()<numVertices()-1) {
            //remove the least weighted edge
            WeightedEdge we = (WeightedEdge)H.removeMinElement();
            //retrieve the end vertices of this edge
            Position pArray[] = endVertices(we);
            LabeledVertex v = (LabeledVertex)pArray[0];
            LabeledVertex u = (LabeledVertex)pArray[1];
            //if the end vertices are not in the same cluster add the edge
            if (v.getLabel()!=u.getLabel()) {
                LabeledVertex newV = (LabeledVertex)verticesInT.get(v);
                LabeledVertex newU = (LabeledVertex)verticesInT.get(u);
                //if v wasn't already represented in T then make a new Vertex
                if (newV==null)
                    newV = (LabeledVertex)T.insertVertex(v.element());
                //if u wasn't already represented in T then make a new Vertex
                if (newU==null)
                    newU = (LabeledVertex)T.insertVertex(u.element());
                //insert the new edge
                T.insertEdge(newV,newU,we.element(),we.getWeight());
                //and put the vertices in the hashtable so we can get them next time
                verticesInT.put(v,newV);
                verticesInT.put(u,newU);
                //the label numbers represent cluster membership,
                //we now change all items in u's cluster to the
                //label for v's cluster
                int uLabel = u.getLabel();
                enum = vertices();
                while (enum.hasMoreElements()) {
                    LabeledVertex w = (LabeledVertex)enum.nextElement();
                    if (w.getLabel()==uLabel)
                        w.setLabel(v.getLabel());
                }
            }
        }
        //if we didn't get enough edges for an mst return null
        if (T.numEdges()<numVertices()-1)
            return null;
        else
            return T;
    }
}
