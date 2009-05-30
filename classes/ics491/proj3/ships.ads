--The ship objects are autonomous actor tasks. When created they are passed
--their draught, length and number of containers - this is the sum of those
--to be unloaded and reloaded - the process is continouous and treated as one
--operation.
PACKAGE ships IS
  TYPE ship(length : positive; draught : positive;
                                  containers : positive) IS LIMITED PRIVATE;  
PRIVATE
  TASK TYPE ship(length : positive; draught : positive; containers : positive);
END ships;
