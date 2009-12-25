import java.util.Date;

public class Defensive {

    private final Date _date;

    public Defensive(Date date) {
        // ah ha defensive copy, otherwise below would mutate it...
        _date = new Date(date.getTime());
        // check validity on copies...not originals
    }

    public Date getDate() {
        // ah ah returning a defensive copy
        return new Date(_date.getTime());
    }

    public static void main(String[] args) {
        Date date = new Date();
        Defensive defensive = new Defensive(date);
        // trying to mutate...
        date.setYear(78);
    }

    // in a read object you would need to make sure to defensive copy in case
    // they tried to feed a byte array with a reference to the object

}
