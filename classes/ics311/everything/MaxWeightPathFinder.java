import java.util.Enumeration;
import java.util.Hashtable;

/**
 * This object contains a method that returns the
 * edges in a maximum weighted path from one vertex to another vertex.
 * 
 * @author digitalOverflow
 */
public class MaxWeightPathFinder implements PathFinder {

    /**
     * Implementation of finding the edges between two
     * vertices using the maximum weight path
     * 
     * @param G      The WeightedAdjacencyListGraph that we are going
     *               to do the search upon
     * @param s      the source vertex
     * @param f      the destination vertex
     * @return an Enumeration of the edges that constitute the
     * maximum possible augmentation from s to f
     */        
     public Enumeration findPath(WeightedAdjacencyListGraph G, LabeledVertex s, LabeledVertex f) {
        //these variables are used to keep track of whether or not there is an outgoing edge
        //from s or an incoming edge to f in subgaph T, obviously if there is not, there is
        //no need to search for a path
        boolean pathFrom_s = false;
        boolean pathTo_f = false;
        PathFinder pf = new BFSPathFinder();
        Enumeration path = null;
        LinkedSequence S = null;
        Hashtable verticesInT = new Hashtable();
        WeightedEdge e;
        WeightedAdjacencyListGraph T = new WeightedAdjacencyListGraph();
        //put all the vertices of G in T
        path = G.vertices();
        while (path.hasMoreElements()) {
            LabeledVertex v = (LabeledVertex)path.nextElement();
            LabeledVertex vInT = (LabeledVertex)T.insertVertex(v);
            verticesInT.put(v,vInT);
        }
        //H is actually a max heap because of the modified comparator
        LinkedBinaryTreeHeap H = new LinkedBinaryTreeHeap(new DecIntegerComparator());
        //put the edges into a max heap
        Enumeration edges = G.edges();
        while (edges.hasMoreElements()) {
            e = (WeightedEdge)edges.nextElement();
            H.insertItem(new Integer(e.getWeight()),e);
        }
        //keep putting the maximum edges into our new graph one by one
        //until we find a path from s to f using a BFS traversal
        while (!H.isEmpty()) {
            e = (WeightedEdge)H.removeMinElement();
            Position p[] = G.endVertices(e);
            LabeledVertex orig = (LabeledVertex)p[0];
            LabeledVertex dest = (LabeledVertex)p[1];
            LabeledVertex origInT = (LabeledVertex)verticesInT.get(orig);
            LabeledVertex destInT = (LabeledVertex)verticesInT.get(dest);
            //find out if there is an *outgoing* edge from s
            //and an *incoming* edge to f
            if (e.isDirected()) {
                T.insertDirectedEdge(origInT,destInT,e);
                if (s==orig) pathFrom_s = true;
                if (f==dest) pathTo_f = true;
            }  else {
                T.insertEdge(origInT,destInT,e);
                if (s==orig || s==dest) pathFrom_s = true;
                if (f==orig || f==dest) pathTo_f = true;
            }
            //not necessary to look for a path unless there is an *outgoing* edge from
            //s and an *incoming* edge to f
            if (pathFrom_s && pathTo_f)
                path = pf.findPath(T,(LabeledVertex)verticesInT.get(s),(LabeledVertex)verticesInT.get(f));
            //the edges in path contain the edges that need to be augmented
            S = new LinkedSequence();
            if (path!=null)
                while (path.hasMoreElements()) {
                    e = (WeightedEdge)path.nextElement();
                    S.insertLast(e.element());
                }
            if (!S.isEmpty()) return new SequenceEnumerator(S);
        }
        //return an empty enumeration
        return path;
    }

}
