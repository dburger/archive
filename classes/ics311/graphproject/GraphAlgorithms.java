import java.util.Random;
public class GraphAlgorithms {

    //weighted directed with back edges
    //density indicates probably of directed edge from u -> v for any u and v in V
    public static Sequence CreateRandomGraphForMaxFlow(int Vertices, int density) {
    /* 
    expected number of edges for this routine is
    (Vertices-1)(Vertices-1)*density/100
    Why?  density/100 is the percentage for a considered edges likely inclusion
    we don't allow edges incoming to the source or outgoing from the sink, so
    n-1 edge destination are considered for n-1 originations
    
    so, (n-1)(n-1)*density/100
    */
        WeightedAdjacencyListGraph G = new WeightedAdjacencyListGraph();
        //if Vertices = 0 then we just return an empty graph
        Sequence Result = new LinkedSequence();
        if (Vertices==0) {
            Result.insertFirst(G);
            return Result;
        }
        //checking to make sure the edge density is valid, if not we
        //change it to a valid range
        if(density < 0) density = 0;
        if(density > 100) density = 100;
        Sequence Seq = new ArraySequence(Vertices);
        Random decision = new Random();
        int choice;
        Random value = new Random();
        //create the vertices and put them in the sequence
        for(int index = 0; index < Vertices; index++)
 	    Seq.insertLast(G.insertVertex("" + index)); 
        //iterate through each vertex as a origin
        for(int index = 0; index < Seq.size()-1; index++)       //no outgoing from snk
            //iterate through each vertex as a destination
            for(int inside = 1; inside < Seq.size(); inside++)  //no incoming from src
                if(inside != index) {                           //no self loops allowed
                    choice = (((Math.abs(decision.nextInt()))%100)+1);
                    //result is 1-100
                    if(choice <= density) {
                            G.insertDirectedEdge((Position)Seq.elemAtRank(index),(Position)Seq.elemAtRank(inside),"" + index + "-" + inside,((Math.abs(value.nextInt()%50)+1)*20));
                            //inserting back edges for Max Flow
                            G.insertDirectedEdge((Position)Seq.elemAtRank(inside),(Position)Seq.elemAtRank(index),"" + inside + "-" + index, 0);
                    }
                }

        //returns a sequence with three elements, the first is the Grapp
        //the second is the source, the third is the sink
        Result.insertLast(G);
        Result.insertLast(Seq.elemAtRank(0));
        Result.insertLast(Seq.elemAtRank(Vertices-1));
        return Result; 
    }

    //weighted undirected and no back edges in the style of Goodrich and Tamassia p. 414
    public static WeightedAdjacencyListGraph CreateRandomGraphForMST(int numVertices, int density) {
        /* 
        expected number of edges for this routine is
        (numVertices)(numVertices-1)*density/100
        Why?  density/100 is the percentage for a considered edges likely inclusion
        We are not allowing double edges here so for the first vertex, n-1 destinations
        are consider, for the second vertex n-2 destinations are considered, ...,
        for the last vertex, 0 destinations are consider.
        0+1+2+...+(n-2)+(n-1) = n(n-1)/2, so
        
        so, (n)(n-1)/2*density/100
        */
        WeightedAdjacencyListGraph G = new WeightedAdjacencyListGraph();
        //change the density to a valid range if not valid
        if(density < 0) density = 0;
        if(density > 100) density = 100;
        Random decision = new Random();
        Random value = new Random();
        int choice;
        Sequence vertSequence = new ArraySequence(numVertices);
        //create the vertices
        for(int index = 0; index < numVertices; index++)
 	    vertSequence.insertLast(G.insertVertex("" + index));
        //consider each vertex as an origin in an undirected edge
        for (int index=0;index < numVertices;index++)
            //consider all vertices after index as destinations in an undirected edge
            for (int inside=index;inside<numVertices;inside++)
                //no self loops
                if (inside!=index){
                    choice = (((Math.abs(decision.nextInt()))%100)+1);
                    //result is 1-100
                    if(choice <= density) {
                        G.insertEdge((Position)vertSequence.elemAtRank(index),(Position)vertSequence.elemAtRank(inside),"" + index + "-" + inside,((Math.abs(value.nextInt()%50)+1)*20));
                    }
                }
        return G;
    }
}
