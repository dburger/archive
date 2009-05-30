import java.applet.*;
import java.awt.*;
import java.awt.event.*;
import java.util.Random;
import java.applet.AudioClip;
import java.util.Enumeration;


public class GraphApp extends Applet implements ActionListener {
    Button cmdGo;
    Choice cboGraphOp;
    TextField txtVertices, txtDensity;
    TextArea txtOutput;
    AudioClip sound;

    public void init() {

        //COLORS
        Color titleColor  = new Color(255,200,00);   //title color,matches site
        Color outerColor  = new Color(102,204,255);  //outer table cells
        Color innerColor  = new Color(204,204,204);  //inner table cells
        setBackground(titleColor);

        BorderLayout bl = new BorderLayout();
        setLayout(bl);

        Panel pnl = new Panel();

       

        add(pnl,bl.NORTH);



        //START - OUTER TABLE CELLS - LABELS
        Label lblVertices = new Label("Vertices:", Label.CENTER);
        lblVertices.setBackground(titleColor);
        pnl.add(lblVertices);
    
        txtVertices = new TextField("20");
        txtVertices.setBackground(Color.white);
        pnl.add(txtVertices);
    
        Label lblDensity = new Label("Edge Density:", Label.CENTER);
        lblDensity.setBackground(titleColor);
        pnl.add(lblDensity);
    
        txtDensity = new TextField("20");
        txtDensity.setBackground(Color.white);
        pnl.add(txtDensity);
                
        cboGraphOp = new Choice();
        cboGraphOp.addItem("Random Max Flow");
        cboGraphOp.addItem("Max Flow example 1");
        cboGraphOp.addItem("Max Flow example 2");
        cboGraphOp.addItem("Max Flow example 3");
        cboGraphOp.addItem("Random MST");
        cboGraphOp.addItem("MST example 1");
        cboGraphOp.addItem("MST example 2");
        pnl.add(cboGraphOp);

        cmdGo = new Button("Go");
        cmdGo.addActionListener(this);
        pnl.add(cmdGo);


        txtOutput = new TextArea(); //"", 150, 0);
        txtOutput.setBackground(Color.white);
        txtOutput.setFont(new Font("Courier",0,11));
//        gb.fill = gb.BOTH;
        add(txtOutput,bl.CENTER);


    
//        sound = getAudioClip(getDocumentBase(),"sound16.au");
   
    }

    /**
    * Invoked when an action occurs.
    */
    public void actionPerformed(ActionEvent e) {
        if (e.getSource()==cmdGo)
            doGraphOp();
    }

    private void doGraphOp() {
        if(cboGraphOp.getSelectedItem().equals("Random Max Flow")) {
            doRandomMaxFlow();
        }
        else if(cboGraphOp.getSelectedItem().equals("Random MST")) {
            doRandomMST();
        } else if(cboGraphOp.getSelectedItem().equals("Max Flow example 1")) {
            doMaxFlowExample1();
        } else if(cboGraphOp.getSelectedItem().equals("Max Flow example 2")) {
            doMaxFlowExample2();
        } else if(cboGraphOp.getSelectedItem().equals("Max Flow example 3")) {
            doMaxFlowExample3();
        } else if(cboGraphOp.getSelectedItem().equals("MST example 1")) {
            doMSTExample1();
        } else if(cboGraphOp.getSelectedItem().equals("MST example 2")) {
            doMSTExample2();
        }

    }

    private void doRandomMaxFlow() {
        txtOutput.setText("");
        int numVertices = Integer.parseInt(txtVertices.getText());
        int edgeDensity = Integer.parseInt(txtDensity.getText());

        if (numVertices<0 || numVertices>500)
            txtOutput.append("Please enter a number of vertices from 1 to 500.\n");
        else if (edgeDensity<0 || edgeDensity>100) {
            txtOutput.append("Please enter an edge density from 0 to 100.\n");
            txtOutput.append("(Percentage chance of edge from vertex a to b.\n");
        } else {
            txtOutput.append("Vertices:  " + numVertices + "\n");
            txtOutput.append("Edge density:  " + edgeDensity + " percent\n");
            double expectedEdges = 0;
            if (edgeDensity>0)
                //see GraphAlgorithms.CreateRandomGraphForMaxFlow for math breakdown
                expectedEdges = (numVertices-1)*(numVertices-1)*edgeDensity/100;
            txtOutput.append("Expected # edges:  " + expectedEdges + "\n");
            Sequence S = GraphAlgorithms.CreateRandomGraphForMaxFlow(numVertices,edgeDensity);
            WeightedAdjacencyListGraph G = (WeightedAdjacencyListGraph)S.remove(S.first());
            if (G.numVertices()==0) {
                txtOutput.append("Graph has no vertices, and therefore no flow.");
            } else {
                LabeledVertex src = (LabeledVertex)S.remove(S.first());
                LabeledVertex snk = (LabeledVertex)S.remove(S.first());
                //divide out the back edges
                txtOutput.append("Actual # edges:    " + G.numEdges()/2 + "\n");
    
                PathFinder dfs = new DFSPathFinder();
                PathFinder bfs = new BFSPathFinder();
                PathFinder max = new MaxWeightPathFinder();
                PathFinder maxbfs = new MaxWeightBFSPathFinder();

                try {
    
                    long dfsTime = 0;
                    int dfsWeight = 0;
                    long l = 0;
    
                    txtOutput.append("=======================================\n");
    
                    if (expectedEdges>500) {
                        txtOutput.append("Expected edges > 500, dfs augmentation will not be tested.\n");
                        txtOutput.append("(It's just too slow!)\n");
                    } else {
                        l = System.currentTimeMillis();
                        dfsWeight = G.getMaxFlow(src,snk,dfs);
                        dfsTime = System.currentTimeMillis() - l;
                        if (expectedEdges<=500)
                            txtOutput.append("dfs flow found:      " + dfsWeight + "\n");
                    }

                    l = System.currentTimeMillis();
                    int bfsWeight = G.getMaxFlow(src,snk,bfs);
                    long bfsTime = System.currentTimeMillis() - l;
                    txtOutput.append("bfs flow found:      " + bfsWeight + "\n");
        
                    l = System.currentTimeMillis();
                    int maxWeight = G.getMaxFlow(src,snk,max);
                    long maxTime = System.currentTimeMillis() - l;
                    txtOutput.append("max flow found:      " + maxWeight + "\n");
    
                    l = System.currentTimeMillis();
                    int maxbfsWeight = G.getMaxFlow(src,snk,maxbfs);
                    long maxbfsTime = System.currentTimeMillis() - l;
                    txtOutput.append("max bfs flow found:  " + maxbfsWeight + "\n");
    
                    txtOutput.append("=======================================\n");
    
                    if (expectedEdges<=500)
                        txtOutput.append("dfs augmentation time:  " + dfsTime + "\n");
                    txtOutput.append("bfs augmentation time:  " + bfsTime + "\n");
                    txtOutput.append("max augmentation time:  " + maxTime + "\n");
                    txtOutput.append("max bfs augmentation time:  " + maxbfsTime + "\n");
    
                } catch (RuntimeException e) {
                    txtOutput.append(e.getMessage());
                    txtOutput.append("error");
    
                }
            }
        }
    }

    private void doRandomMST() {
        txtOutput.setText("");
        int numVertices = Integer.parseInt(txtVertices.getText());
        int edgeDensity = Integer.parseInt(txtDensity.getText());

        if (numVertices<0 || numVertices>500)
            txtOutput.append("Please enter a number of vertices from 0 to 500.\n");
        else if (edgeDensity<0 || edgeDensity>100) {
            txtOutput.append("Please enter an edge density from 0 to 100.\n");
            txtOutput.append("(Percentage chance of edge from vertex a to b.\n");
        } else {
            txtOutput.append("Vertices:  " + numVertices + "\n");
            txtOutput.append("Edge density:  " + edgeDensity + " percent\n");
            double expectedEdges = 0;
            if (edgeDensity>0)
                //see GraphAlgorithms.CreateRandomGraphForMST for math breakdown
                expectedEdges = numVertices*(numVertices-1)/2*edgeDensity/100;
            txtOutput.append("Expected # edges:  " + expectedEdges + "\n");

            //undirected and no back edges            
            WeightedAdjacencyListGraph G = GraphAlgorithms.CreateRandomGraphForMST(numVertices,edgeDensity);

            txtOutput.append("Actual # edges:    " + G.numEdges() + "\n");
            txtOutput.append("All edges undirected and no double edges.\n");

            long l = System.currentTimeMillis();
            WeightedAdjacencyListGraph MST = G.getBaruvkaMST();
            long baruvkaTime = System.currentTimeMillis() - l;

            txtOutput.append("=======================================\n");
            txtOutput.append("Results:\n");
            txtOutput.append("=======================================\n");

            if (MST==null)
                txtOutput.append("Baruvka:  This graph has no spanning tree.\n");
            else {
                int spanWeight = 0;
                Enumeration edges = MST.edges();
                while (edges.hasMoreElements()) {
                    WeightedEdge e = (WeightedEdge)edges.nextElement();
                    spanWeight+=e.getWeight();
                }
                txtOutput.append("Baruvka span weight:  " + spanWeight + "\n");
            }
            txtOutput.append("Baruvka time:  " + baruvkaTime + "\n");


            l = System.currentTimeMillis();
            MST = G.getKruskalMST();
            long kruskalTime = System.currentTimeMillis() - l;
            if (MST==null)
                txtOutput.append("Kruskal:  This graph has no spanning tree.\n");
            else {
                int spanWeight = 0;
                Enumeration edges = MST.edges();
                while (edges.hasMoreElements()) {
                    WeightedEdge e = (WeightedEdge)edges.nextElement();
                    spanWeight+=e.getWeight();
                }
                txtOutput.append("Kruskal span weight:  " + spanWeight + "\n");
            }
            txtOutput.append("Kruskal time:  " + kruskalTime + "\n");
        }
    }

    private void doMaxFlowExample1() {
        txtOutput.setText("");
        txtOutput.append("Max Flow example p. 429 Goodrich and Tamassia\n");

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
        int dfsFlow = G.getMaxFlow((LabeledVertex)s,(LabeledVertex)t,new DFSPathFinder());
        long dfsTime = System.currentTimeMillis() - l;

        txtOutput.append("=======================================\n");
        txtOutput.append("DFS augmentation result:\n");
        txtOutput.append("edge  flow/capacity/residual\n");
        Enumeration enum = G.edges();
        while (enum.hasMoreElements()) {
            WeightedEdge we = (WeightedEdge)enum.nextElement();
            //don't show the edges only inserted as back edges
            if (we.getWeight()>0)
                txtOutput.append(we.element() + "  " + we.getTag() + "\n");
        }
        txtOutput.append("DFS max flow:  " + dfsFlow + "\n");
        txtOutput.append("DFS time:      " + dfsTime + "\n");

        l = System.currentTimeMillis();
        int bfsFlow = G.getMaxFlow((LabeledVertex)s,(LabeledVertex)t,new BFSPathFinder());
        long bfsTime = System.currentTimeMillis() - l;

        txtOutput.append("=======================================\n");
        txtOutput.append("BFS augmentation result:\n");
        txtOutput.append("edge  flow/capacity/residual\n");
        enum = G.edges();
        while (enum.hasMoreElements()) {
            WeightedEdge we = (WeightedEdge)enum.nextElement();
            //don't show the edges only inserted as back edges
            if (we.getWeight()>0)
                txtOutput.append(we.element() + "  " + we.getTag() + "\n");
        }
        txtOutput.append("BFS max flow:  " + bfsFlow + "\n");
        txtOutput.append("BFS time:      " + bfsTime + "\n");

        l = System.currentTimeMillis();
        int maxFlow = G.getMaxFlow((LabeledVertex)s,(LabeledVertex)t,new MaxWeightPathFinder());
        long maxTime = System.currentTimeMillis() - l;

        txtOutput.append("=======================================\n");
        txtOutput.append("Max augmentation result:\n");
        txtOutput.append("edge  flow/capacity/residual\n");
        enum = G.edges();
        while (enum.hasMoreElements()) {
            WeightedEdge we = (WeightedEdge)enum.nextElement();
            //don't show the edges only inserted as back edges
            if (we.getWeight()>0)
                txtOutput.append(we.element() + "  " + we.getTag() + "\n");
        }
        txtOutput.append("Max max flow:  " + maxFlow + "\n");
        txtOutput.append("Max time:  " + maxTime + "\n");

        l = System.currentTimeMillis();
        int maxbfsFlow = G.getMaxFlow((LabeledVertex)s,(LabeledVertex)t,new MaxWeightBFSPathFinder());
        long maxbfsTime = System.currentTimeMillis() - l;

        txtOutput.append("=======================================\n");
        txtOutput.append("Max BFS augmentation result:\n");
        txtOutput.append("edge  flow/capacity/residual\n");
        enum = G.edges();
        while (enum.hasMoreElements()) {
            WeightedEdge we = (WeightedEdge)enum.nextElement();
            //don't show the edges only inserted as back edges
            if (we.getWeight()>0)
                txtOutput.append(we.element() + "  " + we.getTag() + "\n");
        }
        txtOutput.append("Max BFS max flow:  " + maxbfsFlow + "\n");
        txtOutput.append("Max BFS time:      " + maxbfsTime + "\n");

    }

    private void doMaxFlowExample2() {
        txtOutput.setText("");
        txtOutput.append("Max Flow example from the midterm 2 practice test.\n");

        WeightedAdjacencyListGraph G = new WeightedAdjacencyListGraph();

        Position S = G.insertVertex("S");
        Position A = G.insertVertex("A");
        Position B = G.insertVertex("B");
        Position C = G.insertVertex("C");
        Position D = G.insertVertex("D");
        Position T = G.insertVertex("T");

        G.insertDirectedEdge(S,A,"S->A",7);
        G.insertDirectedEdge(A,S,"A->S",0);

        G.insertDirectedEdge(S,C,"S->C",3);
        G.insertDirectedEdge(C,S,"C->S",0);

        G.insertDirectedEdge(A,C,"A->C",4);
        G.insertDirectedEdge(C,A,"C->A",0);

        G.insertDirectedEdge(A,B,"A->B",3);
        G.insertDirectedEdge(B,A,"B->A",0);

        G.insertDirectedEdge(C,B,"C->B",2);
        G.insertDirectedEdge(B,C,"B->C",0);

        G.insertDirectedEdge(B,T,"B->T",6);
        G.insertDirectedEdge(T,B,"T->B",0);

        G.insertDirectedEdge(D,T,"D->T",4);
        G.insertDirectedEdge(T,D,"D->T",0);

        G.insertDirectedEdge(C,D,"C->D",5);
        G.insertDirectedEdge(D,C,"D->C",0);

        long l = System.currentTimeMillis();
        int dfsFlow = G.getMaxFlow((LabeledVertex)S,(LabeledVertex)T,new DFSPathFinder());
        long dfsTime = System.currentTimeMillis() - l;

        txtOutput.append("=======================================\n");
        txtOutput.append("DFS augmentation result:\n");
        txtOutput.append("edge  flow/capacity/residual\n");
        Enumeration enum = G.edges();
        while (enum.hasMoreElements()) {
            WeightedEdge we = (WeightedEdge)enum.nextElement();
            //don't show the edges only inserted as back edges
            if (we.getWeight()>0)
                txtOutput.append(we.element() + "  " + we.getTag() + "\n");
        }
        txtOutput.append("DFS max flow:  " + dfsFlow + "\n");
        txtOutput.append("DFS time:      " + dfsTime + "\n");

        l = System.currentTimeMillis();
        int bfsFlow = G.getMaxFlow((LabeledVertex)S,(LabeledVertex)T,new BFSPathFinder());
        long bfsTime = System.currentTimeMillis() - l;

        txtOutput.append("=======================================\n");
        txtOutput.append("BFS augmentation result:\n");
        txtOutput.append("edge  flow/capacity/residual\n");
        enum = G.edges();
        while (enum.hasMoreElements()) {
            WeightedEdge we = (WeightedEdge)enum.nextElement();
            //don't show the edges only inserted as back edges
            if (we.getWeight()>0)
                txtOutput.append(we.element() + "  " + we.getTag() + "\n");
        }
        txtOutput.append("BFS max flow:  " + bfsFlow + "\n");
        txtOutput.append("BFS time:      " + bfsTime + "\n");

        l = System.currentTimeMillis();
        int maxFlow = G.getMaxFlow((LabeledVertex)S,(LabeledVertex)T,new MaxWeightPathFinder());
        long maxTime = System.currentTimeMillis() - l;

        txtOutput.append("=======================================\n");
        txtOutput.append("Max augmentation result:\n");
        txtOutput.append("edge  flow/capacity/residual\n");
        enum = G.edges();
        while (enum.hasMoreElements()) {
            WeightedEdge we = (WeightedEdge)enum.nextElement();
            //don't show the edges only inserted as back edges
            if (we.getWeight()>0)
                txtOutput.append(we.element() + "  " + we.getTag() + "\n");
        }
        txtOutput.append("Max max flow:  " + maxFlow + "\n");
        txtOutput.append("Max time:      " + maxTime + "\n");

        l = System.currentTimeMillis();
        int maxbfsFlow = G.getMaxFlow((LabeledVertex)S,(LabeledVertex)T,new MaxWeightBFSPathFinder());
        long maxbfsTime = System.currentTimeMillis() - l;

        txtOutput.append("=======================================\n");
        txtOutput.append("Max BFS augmentation result:\n");
        txtOutput.append("edge  flow/capacity/residual\n");
        enum = G.edges();
        while (enum.hasMoreElements()) {
            WeightedEdge we = (WeightedEdge)enum.nextElement();
            //don't show the edges only inserted as back edges
            if (we.getWeight()>0)
                txtOutput.append(we.element() + "  " + we.getTag() + "\n");
        }
        txtOutput.append("Max BFS max flow:  " + maxbfsFlow + "\n");
        txtOutput.append("Max BFS time:      " + maxbfsTime + "\n");
    }

    private void doMaxFlowExample3() {
        txtOutput.setText("");
        txtOutput.append("Max Flow example p. 426 Goodrich and Tamassia\n");

        WeightedAdjacencyListGraph G = new WeightedAdjacencyListGraph();

        Position SRC = G.insertVertex("The Source");
        Position A = G.insertVertex("alpha");
        Position O = G.insertVertex("omega");
        Position GAM = G.insertVertex("gamma");
        Position D = G.insertVertex("delta");
        Position T = G.insertVertex("theta");
        Position U = G.insertVertex("Unknown");
        Position SNK = G.insertVertex("The Sink");

        G.insertDirectedEdge(SRC,A,"SRC - > A",1);
        G.insertDirectedEdge(A,SRC,"A - > SRC",0);

        G.insertDirectedEdge(SRC,GAM,"SRC - > GAM",2);
        G.insertDirectedEdge(GAM,SRC,"GAM - > SRC",0);

        G.insertDirectedEdge(SRC,O,"SRC - > O",4);
        G.insertDirectedEdge(O,SRC,"O - > SRC",0);

        G.insertDirectedEdge(A,U,"A - > U",1);
        G.insertDirectedEdge(U,A,"U - > A",0);

        G.insertDirectedEdge(GAM,U,"GAM - > U",1);
        G.insertDirectedEdge(U,GAM,"U - > GAM",0);

        G.insertDirectedEdge(GAM,D,"GAM - > D",1);
        G.insertDirectedEdge(D,GAM,"D - > GAM",0);

        G.insertDirectedEdge(O,U,"O - > U",2);
        G.insertDirectedEdge(U,O,"U - > O",0);

        G.insertDirectedEdge(O,T,"O - > T",2);
        G.insertDirectedEdge(T,O,"T - > O",0);

        G.insertDirectedEdge(U,SNK,"U - > SNK",2);
        G.insertDirectedEdge(SNK,U,"SNK - > U",0);

        G.insertDirectedEdge(U,D,"U - > D",2);
        G.insertDirectedEdge(D,U,"D - > U",2);

        G.insertDirectedEdge(D,SNK,"D - > SNK",4);
        G.insertDirectedEdge(SNK,D,"SNK - > D",0);

        G.insertDirectedEdge(T,D,"T - > D",4);
        G.insertDirectedEdge(D,T,"D - > T",0);

        G.insertDirectedEdge(T,SNK,"T - > SNK",1);
        G.insertDirectedEdge(SNK,T,"SNK - > T",0);

        long l = System.currentTimeMillis();
        int dfsFlow = G.getMaxFlow((LabeledVertex)SRC,(LabeledVertex)SNK,new DFSPathFinder());
        long dfsTime = System.currentTimeMillis() - l;

        txtOutput.append("=======================================\n");
        txtOutput.append("DFS augmentation result:\n");
        txtOutput.append("edge  flow/capacity/residual\n");
        Enumeration enum = G.edges();
        while (enum.hasMoreElements()) {
            WeightedEdge we = (WeightedEdge)enum.nextElement();
            //don't show the edges only inserted as back edges
            if (we.getWeight()>0)
                txtOutput.append(we.element() + "  " + we.getTag() + "\n");
        }
        txtOutput.append("DFS max flow:  " + dfsFlow + "\n");
        txtOutput.append("DFS time:      " + dfsTime + "\n");

        l = System.currentTimeMillis();
        int bfsFlow = G.getMaxFlow((LabeledVertex)SRC,(LabeledVertex)SNK,new BFSPathFinder());
        long bfsTime = System.currentTimeMillis() - l;

        txtOutput.append("=======================================\n");
        txtOutput.append("BFS augmentation result:\n");
        txtOutput.append("edge  flow/capacity/residual\n");
        enum = G.edges();
        while (enum.hasMoreElements()) {
            WeightedEdge we = (WeightedEdge)enum.nextElement();
            //don't show the edges only inserted as back edges
            if (we.getWeight()>0)
                txtOutput.append(we.element() + "  " + we.getTag() + "\n");
        }
        txtOutput.append("BFS max flow:  " + bfsFlow + "\n");
        txtOutput.append("BFS time:      " + bfsTime + "\n");

        l = System.currentTimeMillis();
        int maxFlow = G.getMaxFlow((LabeledVertex)SRC,(LabeledVertex)SNK,new MaxWeightPathFinder());
        long maxTime = System.currentTimeMillis() - l;

        txtOutput.append("=======================================\n");
        txtOutput.append("Max augmentation result:\n");
        txtOutput.append("edge  flow/capacity/residual\n");
        enum = G.edges();
        while (enum.hasMoreElements()) {
            WeightedEdge we = (WeightedEdge)enum.nextElement();
            //don't show the edges only inserted as back edges
            if (we.getWeight()>0)
                txtOutput.append(we.element() + "  " + we.getTag() + "\n");
        }
        txtOutput.append("Max max flow:  " + maxFlow + "\n");
        txtOutput.append("Max time:      " + maxTime + "\n");

        l = System.currentTimeMillis();
        int maxbfsFlow = G.getMaxFlow((LabeledVertex)SRC,(LabeledVertex)SNK,new MaxWeightBFSPathFinder());
        long maxbfsTime = System.currentTimeMillis() - l;

        txtOutput.append("=======================================\n");
        txtOutput.append("Max BFS augmentation result:\n");
        txtOutput.append("edge  flow/capacity/residual\n");
        enum = G.edges();
        while (enum.hasMoreElements()) {
            WeightedEdge we = (WeightedEdge)enum.nextElement();
            //don't show the edges only inserted as back edges
            if (we.getWeight()>0)
                txtOutput.append(we.element() + "  " + we.getTag() + "\n");
        }
        txtOutput.append("Max BFS max flow:  " + maxbfsFlow + "\n");
        txtOutput.append("Max BFS time:      " + maxbfsTime + "\n");
    }

    private void doMSTExample1() {
        txtOutput.setText("");
        txtOutput.append("MST example p. 414 Goodrich and Tamassia\n");

        WeightedAdjacencyListGraph G = new WeightedAdjacencyListGraph();

        Position SFO = G.insertVertex("SFO");
        Position LAX = G.insertVertex("LAX");
        Position DFW = G.insertVertex("DFW");
        Position ORD = G.insertVertex("ORD");
        Position BOS = G.insertVertex("BOS");
        Position PVD = G.insertVertex("PVD");
        Position JFK = G.insertVertex("JFK");
        Position BWI = G.insertVertex("BWI");
        Position MIA = G.insertVertex("MIA");
        G.insertEdge(SFO,LAX,"SFO <-> LAX",337);
        G.insertEdge(SFO,DFW,"SFO <-> DFW",1464);
        G.insertEdge(SFO,ORD,"SFO <-> ORD",1846);
        G.insertEdge(SFO,BOS,"SFO <-> BOS",2704);
        G.insertEdge(LAX,DFW,"LAX <-> DFW",1235);
        G.insertEdge(LAX,MIA,"LAX <-> MIA",2342);
        G.insertEdge(DFW,ORD,"DFW <-> ORD",802);
        G.insertEdge(DFW,JFK,"DFW <-> JKF",1391);
        G.insertEdge(DFW,MIA,"DFW <-> MIA",1121);
        G.insertEdge(ORD,BOS,"ORD <-> BOS",867);
        G.insertEdge(ORD,PVD,"ORD <-> PVD",849);
        G.insertEdge(ORD,JFK,"ORD <-> JFK",740);
        G.insertEdge(ORD,BWI,"ORD <-> BWI",621);
        G.insertEdge(BOS,JFK,"BOS <-> JFK",187);
        G.insertEdge(BOS,MIA,"BOS <-> MIA",1258);
        G.insertEdge(PVD,JFK,"PVD <-> JFK",144);
        G.insertEdge(JFK,BWI,"JFK <-> BWI",184);
        G.insertEdge(JFK,MIA,"JFK <-> MIA",1090);
        G.insertEdge(BWI,MIA,"BWI <-> MIA",946);

        long l = System.currentTimeMillis();
        WeightedAdjacencyListGraph MST = G.getBaruvkaMST();
        long baruvkaTime = System.currentTimeMillis() - l;

        txtOutput.append("=======================================\n");
        txtOutput.append("Baruvka MST result:\n");
        txtOutput.append("edges\n");
        int baruvkaWeightFound = 0;
        Enumeration enum = MST.edges();
        while (enum.hasMoreElements()) {
            WeightedEdge we = (WeightedEdge)enum.nextElement();
            txtOutput.append(we.element() + "  " + we.getWeight() + "\n");
            baruvkaWeightFound+=we.getWeight();
        }
        txtOutput.append("Span weight:   " + baruvkaWeightFound + "\n");
        txtOutput.append("Baruvka time:  " + baruvkaTime + "\n");

        l = System.currentTimeMillis();
        MST = G.getKruskalMST();
        long kruskalTime = System.currentTimeMillis() - l;

        txtOutput.append("=======================================\n");
        txtOutput.append("Kruskal MST result:\n");
        txtOutput.append("edges\n");
        int kruskalWeightFound = 0;
        enum = MST.edges();
        while (enum.hasMoreElements()) {
            WeightedEdge we = (WeightedEdge)enum.nextElement();
            txtOutput.append(we.element() + "  " + we.getWeight() + "\n");
            kruskalWeightFound+=we.getWeight();
        }
        txtOutput.append("Span weight:   " + kruskalWeightFound + "\n");
        txtOutput.append("Kruskal time:  " + kruskalTime + "\n");

    }

    private void doMSTExample2() {
        txtOutput.setText("");
        txtOutput.append("MST example from\n");
        txtOutput.append("http://www.me.utexas.edu/~jensen/exercises/mst_spt/mst_spt.html\n");
        txtOutput.append("(graph shown at top of page, solution at bottom left)\n");
        txtOutput.append("=======================================\n");
        txtOutput.append("Our versions happen to pick edge v2 <-> v11 instead\n");
        txtOutput.append("of edge v7 <-> v8, like the web version, creating a\n");
        txtOutput.append("different but equal weight MST.\n");

        WeightedAdjacencyListGraph G = new WeightedAdjacencyListGraph();

        Position v1 = G.insertVertex("v1");
        Position v2 = G.insertVertex("v2");
        Position v3 = G.insertVertex("v3");
        Position v4 = G.insertVertex("v4");
        Position v5 = G.insertVertex("v5");
        Position v6 = G.insertVertex("v6");                
        Position v7 = G.insertVertex("v7");        
        Position v8 = G.insertVertex("v8");
        Position v9 = G.insertVertex("v9");
        Position v10 = G.insertVertex("v10");
        Position v11 = G.insertVertex("v11");

        G.insertEdge(v1,v9,"v1 <-> v9",6);
        G.insertEdge(v1,v8,"v1 <-> v8",10);
        G.insertEdge(v1,v7,"v1 <-> v7",9);
        G.insertEdge(v1,v2,"v1 <-> v2",8);
        G.insertEdge(v1,v11,"v1 <-> v11",3);
        G.insertEdge(v1,v8,"v1 <-> v10",12);
        G.insertEdge(v9,v10,"v9 <-> v10",10);
        G.insertEdge(v9,v8,"v9 <-> v8",3);
        G.insertEdge(v8,v7,"v8 <-> v7",7);
        G.insertEdge(v7,v6,"v7 <-> v6",8);
        G.insertEdge(v7,v5,"v7 <-> v5",6);
        G.insertEdge(v6,v5,"v6 <-> v5",10);
        G.insertEdge(v6,v4,"v6 <-> v4",12);
        G.insertEdge(v5,v2,"v5 <-> v2",2);
        G.insertEdge(v5,v4,"v5 <-> v4",13);
        G.insertEdge(v4,v3,"v4 <-> v3",9);
        G.insertEdge(v2,v3,"v2 <-> v3",10);
        G.insertEdge(v3,v11,"v3 <-> v11",5);
        G.insertEdge(v11,v10,"v11 <-> v10",8);
        G.insertEdge(v2,v11,"v2 <-> v11",7);

        long l = System.currentTimeMillis();
        WeightedAdjacencyListGraph MST = G.getBaruvkaMST();
        long baruvkaTime = System.currentTimeMillis() - l;

        txtOutput.append("=======================================\n");
        txtOutput.append("Baruvka MST result:\n");
        txtOutput.append("edges\n");
        int baruvkaWeightFound = 0;
        Enumeration enum = MST.edges();
        while (enum.hasMoreElements()) {
            WeightedEdge we = (WeightedEdge)enum.nextElement();
            txtOutput.append(we.element() + "  " + we.getWeight() + "\n");
            baruvkaWeightFound+=we.getWeight();
        }
        txtOutput.append("Span weight:   " + baruvkaWeightFound + "\n");
        txtOutput.append("Baruvka time:  " + baruvkaTime + "\n");

        l = System.currentTimeMillis();
        MST = G.getKruskalMST();
        long kruskalTime = System.currentTimeMillis() - l;

        txtOutput.append("=======================================\n");
        txtOutput.append("Kruskal MST result:\n");
        txtOutput.append("edges\n");
        int kruskalWeightFound = 0;
        enum = MST.edges();
        while (enum.hasMoreElements()) {
            WeightedEdge we = (WeightedEdge)enum.nextElement();
            txtOutput.append(we.element() + "  " + we.getWeight() + "\n");
            kruskalWeightFound+=we.getWeight();
        }
        txtOutput.append("Span weight:   " + kruskalWeightFound + "\n");
        txtOutput.append("Kruskal time:  " + kruskalTime + "\n");

    }


} //end class VariousSortApplet
