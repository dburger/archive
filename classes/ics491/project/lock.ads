--When the lock is called by the ship, the method does not return until  
--the requested operation has completed. Many simultaneous calls could
--exist. The ship ID is passed to allow update by lock of the graphics
--display. 
--To allow a ship in, lock must be emptied (if not already empty), outer  
-- gate opened, ship admitted and outer gate closed. Then it must be 
-- filled and inner gate opened to allow ship in.
--Exit follows a similar but reverse process.
--The time to fill/empty depends on the state of the tide (at high tide
--zero time, at lower levels time increases. A fill/empty rate is given.
PACKAGE lock IS
  PROCEDURE request_enter(id: IN natural);  
  PROCEDURE request_exit(id : IN natural);
END lock;

