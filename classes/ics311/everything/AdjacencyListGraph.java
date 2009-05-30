import java.util.Enumeration;
/**
 * A directed adjacency list graph implementation 
 * 
 * @author digitalOverflow
 */
public class AdjacencyListGraph implements Graph {

    protected Sequence V;
    protected Sequence E;

    /**
     * Constructor for the Graph object.
     */
    AdjacencyListGraph() {
        V = new LinkedSequence();
        E = new LinkedSequence();
    }

    /**
     * returns how many elements are in the container.
     *
     * @return int = number of elements in the container.
     */
    public int size() {
        return V.size() + E.size();
    }

    /**
     * returns true if the container is empty, false otherwise.
     *
     * @return boolean true if container is empty
     */
    public boolean isEmpty() {
        return size()==0;
    }

    /**
     * return the number of vertices in the graph
     * 
     * @return number of vertices in the graph
     */
    public int numVertices() {
        return V.size();
    }

    /**
     * returns the number for edges in the graph
     * 
     * @return number of edges in the graph
     */
    public int numEdges() {
        return E.size();
    }

    /**
     * returns an Enumeration of the vertices in the graph
     * 
     * @return vertices in the graph
     */
    public Enumeration vertices() {
        return new SequenceEnumerator(V);
    }

    
    /**
     * returns an Enumeration of the edges in the graph
     * 
     * @return edges in the graph
     */
    public Enumeration edges() {
        return new SequenceEnumerator(E);
    }


    /**
     * Returns an enumeration of the directed edges in the Graph
     * 
     * @return an enumeration of the directed edges in the Graph
     */
    public Enumeration directedEdges() {
        Edge e;
        LinkedSequence S = new LinkedSequence();
        Enumeration allEdges = edges();
        while (allEdges.hasMoreElements()) {
            e = (Edge)allEdges.nextElement();
            if (e.isDirected())
                S.insertLast(e);
        }
        return new SequenceEnumerator(S);
    }

    /**
     * Returns an enumeration of the undirected edges in the Graph
     * 
     * @return an enumeration of the undirected edges in the Graph
     */
    public Enumeration undirectedEdges() {
        Edge e;
        LinkedSequence S = new LinkedSequence();
        Enumeration allEdges = edges();
        while (allEdges.hasMoreElements()) {
            e = (Edge)allEdges.nextElement();
            if (!e.isDirected())
                S.insertLast(e);
        }
        return new SequenceEnumerator(S);
    }

    /**
     * returns the degree of the passed in Vertex vp
     * 
     * @param vp      Vertex to return the degree of
     * @return degree of Vertex vp
     * @exception InvalidPositionException
     *                   thrown when vp is invalid for Vertex container V
     */
    public int degree(Position vp) throws InvalidPositionException {
        Vertex v = checkVertexPosition(vp);
        return v.inDegree() + v.outDegree() + v.unDegree();
    }

    /**
     * returns the in degree of the passed in Vertex vp
     * 
     * @param vp      Vertex to return the in degree of
     * @return in degree of Vertex vp
     * @exception InvalidPositionException
     *                   thrown when vp is invalid for Vertex container V
     */
    public int inDegree(Position vp) throws InvalidPositionException {
        Vertex v = checkVertexPosition(vp);
        return v.inDegree() + v.unDegree();
    }

    /**
     * returns the out degree of the passed in Vertex vp
     * 
     * @param vp      Vertex to return the out degree of
     * @return out degree of Vertex vp
     * @exception InvalidPositionException
     *                   thrown when vp is invalid for Vertex container V
     */
    public int outDegree(Position vp) throws InvalidPositionException {
        Vertex v = checkVertexPosition(vp);
        return v.outDegree() + v.unDegree();
    }

    /**
     * Returns an enumeration of vertices adjacent to Vertex vp
     * 
     * @param vp     Position of Vertex to return the adjacent vertices of
     * @return enumeration of vertices adjacent to Vertex vp
     * @exception InvalidPositionException
     *                   thrown if vp is not a valid Vertex for this Graph
     */
    public Enumeration adjacentVertices(Position vp) throws InvalidPositionException {
        Vertex v = checkVertexPosition(vp);
        Enumeration se = v.edges();
        LinkedSequence S = new LinkedSequence();
        while (se.hasMoreElements()) {
            Position p = opposite(vp,(Position)se.nextElement());
            //we don't want to add the same Vertex twice which
            //will happen if two vertices have more than one
            //edge between them
            if (S.isEmpty())
                S.insertLast(p);
            else {
                //here is where we find out if the Sequence already
                //holds a particular Vertex because a graph may have
                //two edges between the same vertices
                SequenceEnumerator vertices = new SequenceEnumerator(S);
                Position n = null;
                while (vertices.hasMoreElements()) {
                    n = (Position)vertices.nextElement();
                    if (n==p)
                        break;
                }
                if (n!=p)
                    S.insertLast(n);
            }

        }
        return new SequenceEnumerator(S);
    }

    /**
     * Returns an enumeration of vertices in adjacent to Vertex vp
     * 
     * @param vp     Position of Vertex to return the in adjacent vertices of
     * @return enumeration of vertices in adjacent to Vertex vp
     * @exception InvalidPositionException
     *                   thrown if vp is not a valid Vertex for this Graph
     */
    public Enumeration inAdjacentVertice(Position vp) throws InvalidPositionException {
        Vertex v = checkVertexPosition(vp);
        LinkedSequence S = new LinkedSequence();
        //first the inEdges
        Enumeration se = v.inEdges();
        while (se.hasMoreElements()) {
            Position p = opposite(vp,(Position)se.nextElement());
            //we don't want to add the same Vertex twice which
            //will happen if two vertices have more than one
            //edge between them
            if (S.isEmpty())
                S.insertLast(p);
            else {
                //here is where we find out if the Sequence already
                //holds a particular Vertex
                SequenceEnumerator vertices = new SequenceEnumerator(S);
                Position n = null;
                while (vertices.hasMoreElements()) {
                    n = (Position)vertices.nextElement();
                    if (n==p)
                        break;
                }
                if (n!=p)
                    S.insertLast(n);
            }
        }
        //now the unEdges
        se = v.unEdges();
        while (se.hasMoreElements()) {
            Position p = opposite(vp,(Position)se.nextElement());
            //we don't want to add the same Vertex twice which
            //will happen if two vertices have more than one
            //edge between them
            if (S.isEmpty())
                S.insertLast(p);
            else {
                //here is where we find out if the Sequence already
                //holds a particular Vertex
                SequenceEnumerator vertices = new SequenceEnumerator(S);
                Position n = null;
                while (vertices.hasMoreElements()) {
                    n = (Position)vertices.nextElement();
                    if (n==p)
                        break;
                }
                if (n!=p)
                    S.insertLast(n);
            }
        }
        return new SequenceEnumerator(S);
    }

    /**
     * Returns an enumeration of vertices out adjacent to Vertex vp
     * 
     * @param vp     Position of Vertex to return the out adjacent vertices of
     * @return enumeration of vertices out adjacent to Vertex vp
     * @exception InvalidPositionException
     *                   thrown if vp is not a valid Vertex for this Graph
     */
    public Enumeration outAdjacentVertices(Position vp) throws InvalidPositionException {
        Vertex v = checkVertexPosition(vp);
        LinkedSequence S = new LinkedSequence();
        //first the outEdges
        Enumeration se = v.outEdges();
        while (se.hasMoreElements()) {
            Position p = opposite(vp,(Position)se.nextElement());
            //we don't want to add the same Vertex twice which
            //will happen if two vertices have more than one
            //edge between them
            if (S.isEmpty())
                S.insertLast(p);
            else {
                //here is where we find out if the Sequence already
                //holds a particular Vertex
                SequenceEnumerator vertices = new SequenceEnumerator(S);
                Position n = null;
                while (vertices.hasMoreElements()) {
                    n = (Position)vertices.nextElement();
                    if (n==p)
                        break;
                }
                if (n!=p)
                    S.insertLast(n);
            }
        }
        //now the unEdges
        se = v.unEdges();
        while (se.hasMoreElements()) {
            Position p = opposite(vp,(Position)se.nextElement());
            //we don't want to add the same Vertex twice which
            //will happen if two vertices have more than one
            //edge between them
            if (S.isEmpty())
                S.insertLast(p);
            else {
                //here is where we find out if the Sequence already
                //holds a particular Vertex
                SequenceEnumerator vertices = new SequenceEnumerator(S);
                Position n = null;
                while (vertices.hasMoreElements()) {
                    n = (Position)vertices.nextElement();
                    if (n==p)
                        break;
                }
                if (n!=p)
                    S.insertLast(n);
            }
        }
        return new SequenceEnumerator(S);
    }

    /**
     * Returns an Enumeration of the edges incident upon the
     * Vertex in Position vp
     * 
     * @param vp     the Position to holding the Vertex to return the
     *               Enumeration of
     * @return the Enumeration of edges incident upon vp
     * @exception InvalidPositionException
     */
    public Enumeration incidentEdges(Position vp) throws InvalidPositionException {
        Vertex v = checkVertexPosition(vp);
        return v.edges();
    }

    /**
     * Returns an Enumeration of the edges in incident upon the
     * Vertex in Position vp
     * 
     * @param vp     the Position to holding the Vertex to return the
     *               Enumeration of
     * @return the Enumeration of edges in incident upon vp
     * @exception InvalidPositionException
     */
    public Enumeration inIncidentEdges(Position vp) throws InvalidPositionException {
//        Vertex v = checkVertexPosition(vp);
//        return v.inEdges();
        Vertex v = checkVertexPosition(vp);
        LinkedSequence S = new LinkedSequence();
        Enumeration se = v.inEdges();
        while (se.hasMoreElements())
            S.insertLast(se.nextElement());
        se = v.unEdges();
        while (se.hasMoreElements())
            S.insertLast(se.nextElement());
        return new SequenceEnumerator(S);
    }

    /**
     * Returns an Enumeration of the edges out incident upon the
     * Vertex in Position vp
     * 
     * @param vp     the Position to holding the Vertex to return the
     *               Enumeration of
     * @return the Enumeration of edges out incident upon vp
     * @exception InvalidPositionException
     */
    public Enumeration outIncidentEdges(Position vp) throws InvalidPositionException {
//        Vertex v = checkVertexPosition(vp);
//        return v.outEdges();
        Vertex v = checkVertexPosition(vp);
        LinkedSequence S = new LinkedSequence();
        Enumeration se = v.outEdges();
        while (se.hasMoreElements())
            S.insertLast(se.nextElement());
        se = v.unEdges();
        while (se.hasMoreElements())
            S.insertLast(se.nextElement());
        return new SequenceEnumerator(S);
    }

    /**
     * Returns the end vertices of ep in a size two array
     * 
     * @param ep     Edge Position to return the end vertices of
     * @return an array of size 2 holding the end vertices of Edge ep
     * @exception InvalidPositionException
     *                   thrown if Edge Position ep is not valid for this container
     */
    public Position[] endVertices(Position ep) throws InvalidPositionException {
        Edge e = checkEdgePosition(ep);
        Position edgeArray[] = new Position[2];
        edgeArray[0] = e.getOrigVertex();
        edgeArray[1] = e.getDestVertex();
        return edgeArray;
    }

    /**
     * Returns the Vertex on Edge ep opposite from Vertex vp
     * 
     * @param vp     Vertex to find opposite of
     * @param ep     Edge containing the vertices
     * @return 
     * @exception InvalidPositionException
     */
    public Position opposite(Position vp, Position ep) throws InvalidPositionException {
        Vertex v = checkVertexPosition(vp);
        Edge e = checkEdgePosition(ep);
        Vertex o = e.getOrigVertex();
        if (v==o)
            return e.getDestVertex();
        else {
            if (e.getDestVertex()!=v)
                throw new InvalidPositionException("Given Vertex Position invalid for given Edge Position on opposite(v,e)");
            return o;
        }
    }

    /**
     * Determine whether or not two vertices are adjacent
     * 
     * @param vp     Position of one Vertex to check
     * @param wp     Position of other Vertex to check
     * @return true if they are adjacent, false otherwise
     * @exception InvalidPositionException
     *                   thrown if either Position is invalid for this container
     */
    public boolean areAdjacent(Position vp, Position wp) throws InvalidPositionException {
        Vertex v = checkVertexPosition(vp);
        Vertex w = checkVertexPosition(wp);
        Enumeration enum;
        if (v.degree()<=w.degree()) {  //v has a smaller number of neighbors
            enum = v.edges();
            while (enum.hasMoreElements())
                if (opposite(vp,(Edge)enum.nextElement())==wp)
                    return true;
            return false;
        } else { //w.degree()<v.degree(), w has a smaller number of neighbors
            enum = w.edges();
            while (enum.hasMoreElements())
                if (opposite(wp,(Edge)enum.nextElement())==vp)
                    return true;
            return false;
        }
    }

    /**
     * Returns the destination Vertex of the given Edge Position
     * 
     * @param ep     Edge Position to return the destination Vertex of
     * @return the destination Vertex of the given Edge Position
     * @exception InvalidPositionException
     *                   thrown if the Edge Position is invalid
     */
    public Position destination(Position ep) throws InvalidPositionException {
        Edge e = checkEdgePosition(ep);
        return e.getDestVertex();
    }

    /**
     * Returns the origin Vertex of the given Edge Position
     * 
     * @param ep     Edge Position to return the origin Vertex of
     * @return the origin Vertex of the given Edge Position
     * @exception InvalidPositionException
     *                   thrown if the Edge Position is invalid
     */
    public Position origin(Position ep) throws InvalidPositionException {
        Edge e = checkEdgePosition(ep);
        return e.getOrigVertex();
    }

    /**
     * Returns true if the given Edge Position is directed,
     * otherwise false
     * 
     * @param ep     Edge Position to check directed on
     * @return true if directed, otherwise false
     * @exception InvalidPositionException
     */
    public boolean isDirected(Position ep) throws InvalidPositionException {
        Edge e = checkEdgePosition(ep);
        return e.isDirected();
    }

    /**
     * Inserts a new undirected Edge into the graph with end
     * Vertices given by Positions vp and wp storing Object o,
     * returns a Position object for the new Edge
     * 
     * @param vp     Position holding one Vertex endpoint
     * @param wp     Position holding the other Vertex endpoint
     * @param o      Object to store at the new Edge
     * @return Position containing the new Edge object
     * @exception InvalidPositionException
     *                   thrown if either of the given vertices are invalid for
     *                   this container
     */
    public Position insertEdge(Position vp,Position wp, Object o) throws InvalidPositionException {
        Vertex v = checkVertexPosition(vp);
        Vertex w = checkVertexPosition(wp);
        //adding to the incident containers for v and w
        //is done in this constructor
        Edge e = new Edge(o,E,false,v,w);
        Position pos = E.insertLast(e);
        e.setContainerPosition(pos);
        return e;
    }

    /**
     * Inserts a new directed Edge into the graph with end
     * Vertices given by Positions vp, the origin, and wp,
     * the destination, storing Object o,
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
        Edge e = new Edge(o,E,true,v,w);
        Position pos = E.insertLast(e);
        e.setContainerPosition(pos);
        return e;
    }

    /**
     * Inserts a new Vertex into the graph holding Object o
     * and returns a Position holding the new Vertex
     * 
     * @param o      the Object to hold in this Vertex
     * @return the Position holding the Vertex
     */
    public Position insertVertex(Object o) {
        Vertex v = new Vertex(o,V);
        Position pos = V.insertLast(v);
        v.setContainerPosition(pos);
        return v;
    }

    /**
     * This method removes the Vertex held in the passed in
     * Position from the Graph
     * 
     * @param vp     the Position holding the Vertex to remove
     * @exception InvalidPositionException
     *                   thrown if the given Position is invalid for this container
     */
    public void removeVertex(Position vp) throws InvalidPositionException {
        Vertex v = checkVertexPosition(vp);
        Enumeration edges = v.edges();
        while (edges.hasMoreElements()) {
            Edge e = (Edge)edges.nextElement();
            removeEdge(e);
        }
        V.remove(v.getContainerPosition());
        //do we need to unwire it completely
        //or just null out the container here
        v.setContainer(null);
    }

    /**
     * Used to remove the Edge held in Position ep from the Graph
     * 
     * @param ep     the Position holding the Edge to remove
     * @exception InvalidPositionException
     *                   thrown if Position ep is invalid for this container
     */
    public void removeEdge(Position ep) throws InvalidPositionException {
        Edge e = checkEdgePosition(ep);
        Vertex orig = e.getOrigVertex();
        Vertex dest = e.getDestVertex();
        Position origPos = e.getIncidentOrigPos();
        Position destPos = e.getIncidentDestPos();
        if (e.isDirected()) {
            orig.removeOutEdge(origPos);
            dest.removeInEdge(destPos);
        } else {
            orig.removeUnEdge(origPos);
            dest.removeUnEdge(destPos);
        }
        E.remove(e.getContainerPosition());
        //do we need to unwire it completely
        //or just null out the container here
        e.setContainer(null);
    }

    /**
     * This routine is used to change a directed Edge into an
     * undirected Edge
     * 
     * @param ep     a Position holding the Edge to change from directed to
     *               undirected
     * @exception InvalidPositionException
     */
    public void makeUndirected(Position ep) throws InvalidPositionException {
        Edge e = checkEdgePosition(ep);
        if (e.isDirected()) {
            Vertex orig = e.getOrigVertex();
            Vertex dest = e.getDestVertex();
            Position origPos = e.getIncidentOrigPos();
            Position destPos = e.getIncidentDestPos();
            orig.removeOutEdge(origPos);
            dest.removeInEdge(destPos);
            origPos = orig.addUnEdge(e);
            destPos = dest.addUnEdge(e);
            //store the Positions within incident Containers
            e.setIncidentOrigPos(origPos);
            e.setIncidentDestPos(destPos);
            e.setDirected(false);
        }
    }

    /**
     * This routine can be used to reverse the diretion of a 
     * directed Edge
     * 
     * @param ep     a Position holding the Edge to reverse
     * @exception InvalidPositionException
     *                   thrown if the given Position is invalid for this container
     */
    public void reverseDirection(Position ep) throws InvalidPositionException {
        Edge e = checkEdgePosition(ep);
        //should we throw this?  or is the reverse of undirected = undirected?
        //if (!e.isDirected())
        //    throw new InvalidPositionException("Invalid Position Exception trying to reverse an undirected Edge.");
        if (e.isDirected()) {
            Position orig = e.getOrigVertex();
            setDirectionTo(ep,orig);
        }
    }

    /**
     * Changes the direction of the given Edge to be out incident
     * upone the Vertex held in the given Position
     * 
     * @param ep     the Edge to change the direction of
     * @param vp     the Position holding the Vertex that the Edge is going
     *               to be out incident upon
     * @exception InvalidPositionException
     *                   thrown if either of the given positions are invalid for this container
     */
    public void setDirectionFrom(Position ep, Position vp) throws InvalidPositionException {
        Edge e = checkEdgePosition(ep);
        Vertex v = checkVertexPosition(vp);
        Vertex opposite = (Vertex)opposite(vp,ep);
        if (e.isDirected()) {
            //if v is already the origin nothing to do
            if (e.getOrigVertex()!=vp) {
                //opposite is the origin

                Position origIncidentPos = e.getIncidentOrigPos();
                Position destIncidentPos = e.getIncidentDestPos();
                opposite.removeOutEdge(origIncidentPos);
                v.removeInEdge(destIncidentPos);
                e.setOrigVertex(v);
                e.setDestVertex(opposite);
                origIncidentPos = v.addOutEdge(e);
                destIncidentPos = opposite.addInEdge(e);
                e.setIncidentOrigPos(origIncidentPos);
                e.setIncidentDestPos(destIncidentPos);


            }
        } else {  //e is undirected now
            Position origIncidentPos = e.getIncidentOrigPos();
            Position destIncidentPos = e.getIncidentDestPos();
            if (e.getOrigVertex()==vp) {
                //v is origin on undirected Edge
                v.removeUnEdge(origIncidentPos);
                opposite.removeUnEdge(destIncidentPos);
            } else {
                //v is destination on undirected Edge
                v.removeUnEdge(destIncidentPos);
                opposite.removeUnEdge(origIncidentPos);
            }
            origIncidentPos = v.addOutEdge(e);
            destIncidentPos = opposite.addInEdge(e);
            e.setOrigVertex(v);
            e.setDestVertex(opposite);
            e.setIncidentOrigPos(origIncidentPos);
            e.setIncidentDestPos(destIncidentPos);
            e.setDirected(true);
        }
    }


    /**
     * Changes the direction of the given Edge to be in incident
     * upone the Vertex held in the given Position
     * 
     * @param ep     the Edge to change the direction of
     * @param vp     the Position holding the Vertex that the Edge is going
     *               to be in incident upon
     * @exception InvalidPositionException
     *                   thrown if either of the given positions are invalid for this container
     */
    public void setDirectionTo(Position ep, Position vp) throws InvalidPositionException {
        Edge e = checkEdgePosition(ep);
        Vertex v = checkVertexPosition(vp);
        Position opposite = opposite(vp,ep);
        //let setDirectionFrom do all the work
        setDirectionFrom(ep,opposite);
    }

    /**
     * This method checks to make sure that a given Vertex
     * Position vp is valid for this graph and returns it as
     * a Vertex object if it is
     * 
     * @param vp     The Vertex Position to check
     * @return the Vertex represented by the Position object
     * @exception InvalidPositionException
     *                   thrown if the Position is invalid for this Graph
     */
    protected Vertex checkVertexPosition(Position vp) throws InvalidPositionException {
        if (vp.container()!=V)
           throw new InvalidPositionException("Vertex position does not belong to this container.");
        try {
            Vertex v = (Vertex)vp;
            return v;
        } catch (ClassCastException e) {
            throw new InvalidPositionException("Position is of wrong type for this vertex container.");
        }
    }

    /**
     * This method checks to make sure that a given Edge
     * Position ep is valid for this graph and returns it as
     * a Edge object if it is
     * 
     * @param ep     The Edge Position to check
     * @return the Edge represented by the Position object
     * @exception InvalidPositionException
     *                   thrown if the Position is invalid for this Graph
     */
    protected Edge checkEdgePosition(Position ep) throws InvalidPositionException {
        if (ep.container()!=E)
           throw new InvalidPositionException("Edge position does not belong to this container.");
        try {
            Edge e = (Edge)ep;
            return e;
        } catch (ClassCastException e) {
            throw new InvalidPositionException("Position is of wrong type for this edge container.");
        }    
    }
}
