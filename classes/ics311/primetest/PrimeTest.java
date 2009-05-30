public class PrimeTest {

    public static void main(String args[]) {

        long l = System.currentTimeMillis();

        System.out.println("Found prime:  " + findPrime(1020001));

        System.out.println("Elapsed time:  " + (System.currentTimeMillis() - l));


    }


    public static int findPrime(int m) {

        if (m<1) return 0;

        boolean primes[] = new boolean[2*m + 1];

        for (int i=0;i<=2*m;i++) {
            primes[i] = true;
        }

        primes[0] = false;
        primes[1] = false;

        int nextPrime = 2;

        while (nextPrime<Math.sqrt(2*m)) {
            int primeMultiples = nextPrime * 2;
            while (primeMultiples<=2*m) {
                primes[primeMultiples] = false;
                primeMultiples += nextPrime;
            }
            nextPrime++;
            while (nextPrime<Math.sqrt(2*m) && primes[nextPrime]==false)
                nextPrime++;
        }

        for (int i=m;i<=2*m;i++)
            if (primes[i]==true)
                return i;

        //this actually can't happen, but don't tell the Java compiler
        return 0;

    }




}
