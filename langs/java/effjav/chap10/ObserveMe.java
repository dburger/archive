import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

interface Observable {

    int value();

    void addObserver(Observer o);

    void removeObserver(Observer o);

    void notifyObservers();

}

interface Observer {

    void update(Observable o);

}

class MyObserver implements Observer {

    public void update(Observable o) {
        System.out.println(this + " got a message from " + o);
    }

}

class MyObservable implements Observable {

    // private Set<Observer> _observers = new HashSet<Observer>();
    // this bad boy is thread safe and makes a new copy on any write
    // all mutative operations are implemented by making a fresh copy of the
    // array
    private Set<Observer> _observers = new CopyOnWriteArraySet<Observer>();

    public int value() {return 6;}

    public void addObserver(Observer o) {
        _observers.add(o);
    }

    public void removeObserver(Observer o) {
        _observers.remove(0);
    }

    public void notifyObservers() {
        // if you spun this yourself you would want to snapshot under a synchro
        // block and then iterate through snapshot, here the CopyOnWrite*
        // handles this for us
        for (Observer o : _observers) o.update(this);
    }

}


public class ObserveMe {

    public static void main(String[] args) {
        Observer o1 = new MyObserver();
        Observer o2 = new MyObserver();

        Observable ob = new MyObservable();
        ob.addObserver(o1);
        ob.addObserver(o2);

        ob.notifyObservers();
    }

}
