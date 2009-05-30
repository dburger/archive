--The simulation clock starts at 0 when the simulation starts and
--  measures integer minutes in real-time. 
--Rate is the multiplying factor related to real-time i.e. a rate  
--  of 2 implies 2 x real-time. 
--The clock when created is stopped and set to real-time. 
--It will accept rate changes at any time including when stopped.
--When started it continues from the time at which it was stopped.
PACKAGE clock IS
  FUNCTION get_time RETURN natural;
  PROCEDURE wait(interval : IN positive);  
  PROCEDURE set_rate(rate : IN positive);
  PROCEDURE stop;
  PROCEDURE start;
END clock;

