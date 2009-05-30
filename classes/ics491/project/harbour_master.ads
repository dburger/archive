--The harbour master is required to give permission for all ship movements
--Calls made by ships to the harbour master do not return until an answer
-- can be given of the type move or permission given. 
--Many simultaneous calls may be pending at the same time.
--Initially a ship will call request_entry and if response is to_quay that is
-- all that is required. If response is to_basin then ship must subsequently
-- call request_dock.
--Similarly on exit, the ship will initially call request_exit and if response is
-- to_basin will need to subsequently call request_leave. 
PACKAGE harbour_master IS
  TYPE move IS (to_quay, to_basin, leave);
  FUNCTION request_entry(length : IN positive; draught : IN positive) RETURN move;  
  PROCEDURE request_dock(length : IN positive);
  FUNCTION request_exit(draught : IN positive) RETURN move;
  PROCEDURE request_leave(draught : IN positive);
END harbour_master;
