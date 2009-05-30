--Distribution objects are created and initialised by passing a values
--  array containing the lower-limit and all upper-limits of each interval  
--  and an array containing the probability associated with each interval.
PACKAGE distributions IS
  TYPE data IS ARRAY(positive RANGE <>) OF integer;
  TYPE distribution(size : natural) IS PRIVATE;
  PROCEDURE set(a_distribution : IN OUT distribution; values : IN data; 
                                                       probs : IN data);
  FUNCTION sample(this_distribution : distribution) RETURN integer;
PRIVATE
  TYPE distribution(size : natural) IS RECORD
                                         lower_limit  : integer;
                                         upper_limits : data(1..size);
                                         cum_probs    : data(1..size);
                                       END RECORD;
END distributions;

