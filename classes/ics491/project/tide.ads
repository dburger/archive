--The tide is assumed to start at clock time 0 at high tide and to vary
--  sinusoidally completing a cycle in 12 hours 20 minutes.
--The channel level (and lock bottom) at the entrance to the port provides  
--  a shallower depth than in the approach roads. The tide is represented
--  by a sinusoidal variation with specified high and low depths above
--  this datum. This value must exceed the ships draught to allow ships
--  to enter or leave.
PACKAGE tide IS
  FUNCTION get_height RETURN positive;  
END tide;

