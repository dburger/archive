--The supervisor is given the number of containers in each hold (sum
--  of containers to be unloaded and loded) by a ship when it
--  wishes to load/unload. 
--For a two hold ship, it is assumed that the number of containers in
--  each hold is the same.
--The unload procedure which is called by ships does not return until 
--  all work has been completed.
--The ship ID is passed in to allow supervisor and/or gangs to update
--  graphics display.
--Gangs acquire work by calling get_work.
PACKAGE supervisor IS
  PROCEDURE unload(id : IN natural; hold1 : IN natural; hold2 : IN natural);  
  PROCEDURE get_work(id : OUT natural; containers : OUT natural);
END supervisor;
