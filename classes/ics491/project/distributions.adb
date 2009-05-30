WITH ada.numerics.float_random;
USE ada.numerics.float_random;

PACKAGE BODY distributions IS

   -- used to retrieve a random sampling based upon the passed in
   -- ranges / probabilities
   FUNCTION sample(this_distribution : distribution) RETURN integer IS
     lower_limit : integer := this_distribution.lower_limit;
     upper_limit : integer;
     seed : generator;
     random_value : integer;
   BEGIN
     -- first we generate a value between 0 and 99 inclusive
     reset(seed);
     random_value := Integer(random(seed) * 99.0);
     -- loop through the cumulative probabilities looking for the first one that
     -- has a value greater than random_value
     FOR i IN 1..this_distribution.cum_probs'LAST LOOP
       IF random_value < this_distribution.cum_probs(i) THEN
         -- i is the match, determine upper and lower limits of this range
         IF i > 1 THEN -- if 1, leave lower_limit at 0
           lower_limit := this_distribution.upper_limits(i-1) + 1;
         END IF;
         upper_limit := this_distribution.upper_limits(i);
         -- generate the random amount to add on to the lower_limit and return
         random_value := Integer(random(seed) * Float(upper_limit - lower_limit));
         RETURN lower_limit + random_value;
       END IF;
     END LOOP;
     RETURN 0; -- to make the compiler happy, won't happen if data in set OK
   END sample;
   
   
   -- used to set the ranges / probabilities for later samples
   PROCEDURE set(a_distribution : IN OUT distribution; values : IN data; probs : IN data) IS
   BEGIN
     -- first set the lower_limit based on the first element of values
     a_distribution.lower_limit := values(values'First);
     -- now use a loop to set the values in upper_limits and cum_probs
     FOR i IN 1..values'LAST-values'FIRST LOOP
       a_distribution.upper_limits(i) := values(values'FIRST+i);
       IF i = 1 THEN
         a_distribution.cum_probs(i) := probs(probs'FIRST+i-1);
       ELSE
         a_distribution.cum_probs(i) := probs(probs'First+i-1) + a_distribution.cum_probs(i-1);
       END IF;
     END LOOP;
   END set;

END distributions;
