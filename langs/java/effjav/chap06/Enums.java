public class Enums {

    // the basic enum
    public enum Apple {
        FUJI, PIPPIN, GRANNY_SMITH
    }

    // but they are like instances brah
    public enum Base {
        FIRST("hold hands", 20),
        SECOND("KISS", 40),
        THIRD("COP FEEL", 100),
        HOME("YEAH", 120);

        private String _result;

        private int _intensity;

        Base(String result, int intensity) {
            _result = result;
            _intensity = intensity;
        }

        public void describe() {
            System.out.println("Well yeah you know they " + _result);
        }

        public double farkle() {
            return _intensity * 3.2;
        }

    }

    // constant specific method implementations, book does strategy pattern
    // with this

    public enum Manny {

        FANNIE {
            void doit() {
                System.out.println("i do it like this");
            }
        },
        BANNIE {
            void doit() {
                System.out.println("but i do it like this");
            }
        };

        abstract void doit();
    }

    // this is the way to use the number, don't use the ordinal for it, for the
    // reasons of re-ordering, gaps, etc.

    public enum Ensemble {
        SOLO(1), DUET(2);

        private int _cardinality;

        Ensemble(int cardinality) {_cardinality = cardinality;}

        void shout() {
            System.out.printf("i am %s i am %s persons%n", this, _cardinality);
        }

    }

    public static void main(String[] args) {
        System.out.println(Apple.FUJI);
        Base.HOME.describe();

        Manny.FANNIE.doit();
        Manny.BANNIE.doit();

        // values()
        for (Base b : Base.values()) {
            System.out.println("a base: " + b);
        }

        // valueOf(String)
        Base b = Base.valueOf("FIRST");
        System.out.printf("retrieved %s by string%n", b);

        // has an ordinal, but I don't think you want to use
        System.out.println("the ordinal for this is (but you shouldn't use it: " + b.ordinal());

        // if you change the toString then you might also want to provide
        // a fromString to work with it

        Ensemble.SOLO.shout();
        Ensemble.DUET.shout();
    }

}
