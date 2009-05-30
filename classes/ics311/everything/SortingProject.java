import java.util.Random;
import java.util.Enumeration;

public class SortingProject {


    public static void main(String args[]) {

        WeightedAdjacencyListGraph G = new WeightedAdjacencyListGraph();




        Position y = G.insertVertex("y");
        Position x = G.insertVertex("x");
        Position s = G.insertVertex("s");
        Position t = G.insertVertex("t");

        G.insertDirectedEdge(s,y,"s-y",1000000);
        G.insertDirectedEdge(y,s,"y-s",0);
        G.insertDirectedEdge(x,y,"x-y",1000000);
        G.insertDirectedEdge(y,x,"y-x",0);
        G.insertDirectedEdge(s,x,"s-x",1000000);
        G.insertDirectedEdge(x,s,"x-s",0);
        G.insertDirectedEdge(y,t,"y-t",1000000);
        G.insertDirectedEdge(t,y,"t-y",0);
        G.insertDirectedEdge(x,t,"x-t",1000000);
        G.insertDirectedEdge(t,x,"t-x",0);

        long l = System.currentTimeMillis();
        int dfsFlow = G.getMaxFlow((LabeledVertex)s,(LabeledVertex)t,new MaxWeightBFSPathFinder());
        long dfsTime = System.currentTimeMillis() - l;




//robert's random stuff
/*
        int Vertices = 200; 

        Sequence Seq = new ArraySequence(Vertices);
        Random decision = new Random();
        int choice;
        Random value = new Random();

	for(int index = 0; index < Vertices; index++)
	    Seq.insertLast(G.insertVertex("" + index)); 

        for(int index = 0; index < Seq.size(); index++)  //no outgoing from snk
	    for(int inside = 1; inside < Seq.size(); inside++)  //no incoming from src
	        if(inside != index) {
		    choice = ((Math.abs(decision.nextInt()))%100);
		    if(choice >= 99) {
                        System.out.println("inserting edge from " + index + " to " + inside);
                        G.insertDirectedEdge((Position)Seq.elemAtRank(index),
		                             (Position)Seq.elemAtRank(inside),
                                             "" + index + "-" + inside,
                                             ((Math.abs(value.nextInt()%6)+1)*10000));
//                        G.insertDirectedEdge((Position)Seq.elemAtRank(inside),
//		                             (Position)Seq.elemAtRank(index),
//                                             "" + inside + "-" + index, 0);
                    }
                }


//        GraphAlgorithms.MaxFlowDFS(G,(LabeledVertex)Seq.elemAtRank(0),
//		                            (LabeledVertex)Seq.elemAtRank(Vertices-1));


        //PathFinder pf = new MaxWeightPathFinder();
        PathFinder pf1 = new DFSPathFinder();
        PathFinder pf2 = new BFSPathFinder();
        PathFinder pf3 = new MaxWeightPathFinder();

        //int maxFlow = GraphAlgorithms.getMaxFlow(G,(LabeledVertex)S,(LabeledVertex)T,pf);

        //int maxFlow = GraphAlgorithms.getMaxFlow(G,(LabeledVertex)Seq.first().element(),(LabeledVertex)Seq.last().element(),pf);
//        long l = System.currentTimeMillis();
//        int maxFlow1 = G.getMaxFlow((LabeledVertex)Seq.first().element(),(LabeledVertex)Seq.last().element(),pf1);
//        long time1 = System.currentTimeMillis() - l;


        
        long l = System.currentTimeMillis();
//        int maxFlow2 = G.getMaxFlow((LabeledVertex)Seq.first().element(),(LabeledVertex)Seq.last().element(),pf2);
        long time2 = System.currentTimeMillis() - l;


        l = System.currentTimeMillis();
//        int maxFlow3 = G.getMaxFlow((LabeledVertex)Seq.first().element(),(LabeledVertex)Seq.last().element(),pf3);
        long time3 = System.currentTimeMillis() - l;

        WeightedAdjacencyListGraph mst = G.getKruskalMST();

        if (mst==null)
            System.out.println("has no mst");
        else
            System.out.println("found mst");

*/
        //Enumeration enum = G.edges();
        //while (enum.hasMoreElements()) {
        //    WeightedEdge e = (WeightedEdge)enum.nextElement();
        //    System.out.println(e.getTag() + " " + e.element());
        //}
        //System.out.println("DFS:  " + maxFlow1 + "  " + time1);
//        System.out.println("BFS:  " + maxFlow2 + "  " + time2);
//        System.out.println("Max:  " + maxFlow3 + "  " + time3);



//        long l = System.currentTimeMillis();
//        WeightedAdjacencyListGraph T = GraphAlgorithms.Kruskal(G);
//        System.out.println("time " + (System.currentTimeMillis()-l));
//
//        FindPathDFS fp = new FindPathDFS();
//
//        Enumeration enum = (Enumeration)fp.execute((Graph)G,(Vertex)PVD,(Vertex)LAX);
//
//        while (enum.hasMoreElements()) {
//            LabeledVertex lv = (LabeledVertex)enum.nextElement();
//            System.out.println("path " + lv.element());
//        }
//


/*
        //GraphAlgorithms.BFS(G,(LabeledVertex)LAX);


        System.out.println("Edges:  " + T.numEdges());

        System.out.println("Vertices:  " + T.numVertices());

        enum = T.edges();
        while (enum.hasMoreElements()) {
            WeightedEdge we = (WeightedEdge)enum.nextElement();
            System.out.println(we.getWeight());
        }

        enum = T.vertices();
        while (enum.hasMoreElements()) {
            LabeledVertex lv = (LabeledVertex)enum.nextElement();
            System.out.println(lv.element());
        }

        enum = G.edges();
        while (enum.hasMoreElements()) {
            WeightedEdge we = (WeightedEdge)enum.nextElement();
            System.out.println(we.element() + " " + we.getTag());
        }

        enum = G.vertices();
        while (enum.hasMoreElements()) {
            LabeledVertex lv = (LabeledVertex)enum.nextElement();
            System.out.println(lv.element() + " " + lv.getTag());
        }
*/

    }

}

