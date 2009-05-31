package com.digitaloverflow.util;

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

}
