package com.digitaloverflow.util;

import java.io.Serializable;

/**
 * The type of object representing an Edge in a graph
 * 
 * @author digitalOverflow
 */
public class Edge implements Position, Serializable {

    private Object elem;

    private Container cont;

    private boolean directed;

    private Vertex origVertex;
    private Vertex destVertex;

    private Position incidentOrigPos;
    private Position incidentDestPos;

    private Position edgePos;

    /**
     * Constructor for Edge object
     * 
     * @param o      Object to hold at this Edge
     * @param c      Container of this Edge
     * @param d      true for a directed edge, false otherwise
     * @param orig   one of the vertices of the edge, and,
     *               if directed, origination vertex
     * @param dest   one of the vertices of the edge, and,
     *               if directed, destination vertex
     */
    Edge(Object o, Container c, boolean d, Vertex orig, Vertex dest) {
        elem = o;
        cont = c;
        directed = d;
        origVertex = orig;
        destVertex = dest;
        if (directed) {
            incidentOrigPos = orig.addOutEdge(this);
            incidentDestPos = dest.addInEdge(this);
        } else {
            incidentOrigPos = orig.addUnEdge(this);
            incidentDestPos = dest.addUnEdge(this);
        }
    }

    /**
     * Returns the Position for this Edge object for the
     * container in which it is held
     * 
     * @return the Position for this Edge object for the container
     *         in which it is held
     */
    public Position getContainerPosition() {
        return edgePos;
    }

    /**
     * Sets the Position for this Edge object for the container
     * in which it is held
     * 
     * @param pos    the new Position for this Edge
     */
    public void setContainerPosition(Position pos) {
        edgePos = pos;
    }

    /**
     * returns the origin Vertex for this Edge
     * 
     * @return origin Vertex for this Edge
     */
    public Vertex getOrigVertex() {
        return origVertex;
    }

    /**
     * returns the destination Vertex for this Edge
     * 
     * @return destination Vertex for this Edge
     */
    public Vertex getDestVertex() {
        return destVertex;
    }

    /**
     * sets the origin Vertex for this Edge
     * 
     */
    public void setOrigVertex(Vertex vp) {
        origVertex = vp;
    }

    /**
     * sets the destination Vertex for this Edge
     * 
     */
    public void setDestVertex(Vertex vp) {
        destVertex = vp;
    }

    /**
     * Returns the Position of the Edge within the incident
     * Container for the origin Vertex
     * 
     * @return Returns the Position of the Edge within the incident
     *         Container for the origin Vertex
     */
    public Position getIncidentOrigPos() {
        return incidentOrigPos;
    }

    /**
     * Returns the Position of the Edge within the incident
     * Container for the destination Vertex
     * 
     * @return Returns the Position of the Edge within the incident
     *         Container for the destination Vertex
     */
    public Position getIncidentDestPos() {
        return incidentDestPos;
    }

    /**
     * Sets the Position of the Edge within the incident
     * Container for the origin vertex
     * 
     * @param vp     the new Position of the Edge vertex within the origin
     *               Vertex incident Container
     */
    public void setIncidentOrigPos(Position vp) {
        incidentOrigPos = vp;
    }

    /**
     * Sets the Position of the Edge within the incident
     * Container for the destination vertex
     * 
     * @param vp     the new Position of the Edge vertex within the destination
     *               Vertex incident Container
     */
    public void setIncidentDestPos(Position vp) {
        incidentDestPos = vp;
    }

    /**
     * Returns true if the Edge is directed, false otherwise
     * 
     * @return true for a directed Edge, false otherwise
     */
    public boolean isDirected() {
        return directed;
    }

    /**
     * Used to set the edge to either a directed or undirected edge
     * 
     * @param d      boolean value to set directed to
     */
    public void setDirected(boolean d) {
        directed = d;
    }

    /**
     * returns element stored at this position
     *
     * @return Object = element stored here
     */
    public Object element() {
        return elem;
    }

    /**
     * return the container holding this position
     *
     * @return Container = container holding this position
     */
    public Container container() {
        return cont;
    }

    /**
     * Sets the container for this Position
     * 
     * @param c      the new Container for this Position
     */
    protected void setContainer(Container c) {
        cont = c;
    }

    /**
     * replaces the Object held in this Position
     * 
     * @param o      new Object to be held in this Position
     */
    public void replaceObject(Object o) {
      elem = o;
    }

}
