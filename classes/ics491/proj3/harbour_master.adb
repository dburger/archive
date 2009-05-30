-- harbour_master for the port simulation
-- David J. Burger
-- ICS 491, Dr. Martin
WITH clock, tide, text_io;
USE clock, tide, text_io;

PACKAGE BODY harbour_master IS

  FUNCTION tide_ok(draught : integer; going_in : IN boolean) RETURN boolean;

  -- ***** AGENT *****
  -- An agent acts as the callback agent for any ship request and in doing so
  -- blocks the ship until a request can be granted.  The originating call
  -- creates an agent and then makes a call passing that agent to master_logic.
  -- Then the originating call calls the get_result(outcome) entry below.  That
  -- call cannot be accepted until the call release(result) is called back to
  -- the agent by the master_logic.  The calling routine is returned the outcome
  -- via the outcome parameter in the get_result(outcome) call.
  TASK TYPE agent(length : positive; draught : positive) IS
    ENTRY release(result : IN move);  
    ENTRY get_result(outcome : OUT move);
  END agent;
  
  TASK BODY agent IS
  BEGIN
    ACCEPT release(result : IN move) DO
      ACCEPT get_result(outcome : OUT move) DO
        outcome := result;
      END get_result;
    END release;
  END agent;
  
  TYPE agent_ref IS ACCESS agent;
  
  TASK TYPE alarm(time_delay : integer) IS
  END alarm;
    
  TYPE alarm_ref IS ACCESS alarm;

  -- ***** MASTER_LOGIC *****
  -- The master_logic contains all the decision making code for the
  -- for the harbour_master.  It first accepts a call for a request with an
  -- agent as the passed in parameter.  If there is no other call already
  -- pending for that queue, a reference corresponding to the call is set,
  -- and processing continues down to the checking of each reference variable.
  -- In each loop the agent specified by the reference variable will be checked
  -- to determine if its corresponding ship can proceed.  If it can the release
  -- call is called back on the agent with the outcome of the release (to_quay,
  -- to_basin, ... etc.).  If the ship is unable to proceed because of tide
  -- conditions, a callback is set up to awaken the server thread when the tide
  -- becomes acceptable.
  -- 
  -- Note that it could be possible for a notify to be set up for a proper tide
  -- for a given draught, but for the ship to be unable to proceed when the
  -- tide_notify comes in because other conditions such as a full basin and
  -- quay in the case of an entry. (Although maybe highly unlikely given the
  -- current constraints of the simulation.)  If the ship is unable to proceed
  -- during the entire cycle when the tide became ok again, the harbour_master
  -- will need to set up another callback to get a tide_notify when the tide is
  -- appropriate again.  In order to prevent multiple callbacks being set up,
  -- boolean variables are kept for the pending requests of entry, exit, and
  -- leave, that is those that may depend on the tide.  These booleans are
  -- called request-XXXX_ref_cb.  This boolean will be set to true when the
  -- callback is set up, and set to false anytime any call comes in while the
  -- tide is ok for the request corresponding to the boolean.  Then when any
  -- call comes in when the tide is not ok for the request corresponding to the
  -- boolean, the boolean is first checked to see if it is true, if it is, the
  -- callback has already been set up and nothing needs to be done.  If it is
  -- false, the callback is set up and the boolean is changed to true so that
  -- further requests don't cause multiple callbacks to be set up.
  -- When the simulation is over the clock will call the finish entry.  This
  -- call will cause the master_logic to first release any ships that are
  -- already held up, that is those held by a reference variable.  After that
  -- the master_logic will enter another loop that accepts and answers all
  -- entry calls immediately and also has a terminate.  This will allow all
  -- pending ships to be quickly flushed out of the simulation.
  TASK master_logic IS
    ENTRY request_entry(an_agent : agent_ref);
    ENTRY request_dock(an_agent : agent_ref);
    ENTRY request_exit(an_agent : agent_ref);
    ENTRY request_leave(an_agent : agent_ref);
    ENTRY tide_notify;
  END master_logic;
  
  TASK BODY alarm IS
  BEGIN
    -- we don't need to check the return because that will be determined by
    -- checking clock.is_finished after the main select loop
    IF clock.wait(time_delay) THEN
      NULL;
    END IF;
    master_logic.tide_notify;
  END alarm;  

  TASK BODY master_logic IS
    request_entry_ref : agent_ref := NULL;
    request_entry_ref_cb : boolean := false;
    request_exit_ref : agent_ref := NULL;
    request_exit_ref_cb : boolean := false;
    request_dock_ref : agent_ref := NULL;
    request_leave_ref : agent_ref := NULL;
    an_alarm : alarm_ref := NULL;
    request_leave_ref_cb : boolean;
    state_change : boolean;
    free_quay : natural := 3000;
    free_basin : natural := 6;
  BEGIN
    LOOP
      SELECT
        WHEN request_entry_ref = NULL =>
        ACCEPT request_entry(an_agent : agent_ref) DO
          request_entry_ref := an_agent;
        END request_entry;
      OR
        WHEN request_exit_ref = NULL =>
        ACCEPT request_exit(an_agent : agent_ref) DO
          request_exit_ref := an_agent;
        END request_exit;
      OR
        WHEN request_dock_ref = NULL =>
        ACCEPT request_dock(an_agent : agent_ref) DO
          request_dock_ref := an_agent;
        END request_dock;
      OR
        WHEN request_leave_ref = NULL =>
        ACCEPT request_leave(an_agent : agent_ref) DO
          request_leave_ref := an_agent;
        END request_leave;
      OR
        ACCEPT tide_notify;
        NULL;
      OR
        DELAY 1.0; -- will check is_finsihed if times out...every second
      END SELECT;
    
      -- here we check if the simulation is over, if it is, all ships are
      -- release and all further requests are granted immediately until all
      -- ships are flushed from the simulation
      IF clock.is_finished = true THEN
        -- first release anybody already waiting
        IF request_entry_ref /= NULL THEN
          request_entry_ref.release(to_quay);
          request_entry_ref := NULL;
        END IF;
        
        IF request_exit_ref /= NULL THEN
          request_exit_ref.release(leave);
          request_exit_ref := NULL;
        END IF;
    
        IF request_dock_ref /= NULL THEN
          request_dock_ref.release(to_quay);
          request_dock_ref := NULL;
        END IF;
      
        IF request_leave_ref /= NULL THEN
          request_leave_ref.release(leave);
          request_leave_ref := NULL;
        END IF;
      
        -- and now greet all further request with immediate releases
        LOOP
          SELECT
            ACCEPT request_entry(an_agent : agent_ref) DO
              an_agent.release(to_quay);
            END request_entry;
          OR
            ACCEPT request_exit(an_agent : agent_ref) DO
              an_agent.release(leave);
            END request_exit;
          OR
            ACCEPT request_dock(an_agent : agent_ref) DO
              an_agent.release(to_quay);
            END request_dock;
          OR
            ACCEPT request_leave(an_agent : agent_ref) DO
              an_agent.release(leave);
            END request_leave;
          OR
            TERMINATE;
          END SELECT;
        END LOOP;
      END IF;
          
      state_change := true;
      
      WHILE state_change = true LOOP

        state_change := false;
        
        IF request_dock_ref /= NULL THEN
          IF request_dock_ref.length <= free_quay THEN
            free_quay := free_quay - request_dock_ref.length;
            free_basin := free_basin + 1;
            request_dock_ref.release(to_quay);
            request_dock_ref := NULL;
            state_change := true;
          END IF;
        END IF;        
        
        IF request_entry_ref /= NULL THEN
          IF tide_ok(request_entry_ref.draught, true) THEN
            request_entry_ref_cb := false;
            IF request_entry_ref.length <=  free_quay THEN
              free_quay := free_quay - request_entry_ref.length;
              request_entry_ref.release(to_quay);
              request_entry_ref := NULL;
              state_change := true;
            ELSIF free_basin > 0 THEN
              free_basin := free_basin - 1;
              request_entry_ref.release(to_basin);
              request_entry_ref := NULL;
              state_change := true;
            END IF;
          ELSE
            IF request_entry_ref_cb = false THEN
              an_alarm := new alarm(tide.time_to_wait(request_entry_ref.draught));
              request_entry_ref_cb := true;
            END IF;
          END IF;
        END IF;
                
        IF request_leave_ref /= NULL THEN
          IF tide_ok(request_leave_ref.draught, false) THEN
            request_leave_ref_cb := false;
            free_basin := free_basin + 1;
            request_leave_ref.release(leave);
            request_leave_ref := NULL;
            state_change := true;
          ELSE
            IF request_leave_ref_cb = false THEN
              an_alarm := new alarm(tide.time_to_wait(request_leave_ref.draught));
              request_leave_ref_cb := true;
            END IF;
          END IF;
        END IF;        
        
        IF request_exit_ref /= NULL THEN
          IF tide_ok(request_exit_ref.draught, false) THEN
            request_exit_ref_cb := false;
            free_quay := free_quay + request_exit_ref.length;
            request_exit_ref.release(leave);
            request_exit_ref := NULL;
            state_change := true;
          ELSIF free_basin > 0 THEN
            free_quay := free_quay + request_exit_ref.length;
            free_basin := free_basin - 1;
            request_exit_ref.release(to_basin);
            request_exit_ref := NULL;
            state_change := true;
          ELSE
            IF request_exit_ref_cb = false THEN
              an_alarm := new alarm(tide.time_to_wait(request_exit_ref.draught));
              request_exit_ref_cb := true;
            END IF;
          END IF;
        END IF;
                        
      END LOOP;
            
    END LOOP;
  END master_logic;
  
  
  -- ***** the public procedures / functions *****

  -- called by a ship as a request to dock on the quay
  PROCEDURE request_dock(length : IN positive) IS
    an_agent : agent_ref;
    outcome : move;
  BEGIN
    an_agent := new agent(length, 1); -- draught does not matter here
    master_logic.request_dock(an_agent);
    an_agent.get_result(outcome);
  END request_dock;

  -- called by a ship as a request to enter, result will be either to_basin or
  -- to_quay
  FUNCTION request_entry(length : IN positive; draught : IN positive) RETURN move IS
    an_agent : agent_ref;
    outcome : move;
  BEGIN
    an_agent := new agent(length, draught);
    master_logic.request_entry(an_agent);
    an_agent.get_result(outcome);
    RETURN outcome;
  END request_entry;

  -- called by a ship as a request to exit the quay, the result will be either
  -- to_basin or leave
  FUNCTION request_exit(draught : IN positive) RETURN move IS
    an_agent : agent_ref;
    outcome : move;
  BEGIN
    an_agent := new agent(1, draught); -- length does not matter here
    master_logic.request_exit(an_agent);
    an_agent.get_result(outcome);
    RETURN outcome;
  END request_exit;

  -- called by a ship as a request to leave the basin
  PROCEDURE request_leave(draught : IN positive) IS
    an_agent : agent_ref;
    outcome : move;
  BEGIN
    an_agent := new agent(1, draught); -- length does not matter here
    master_logic.request_leave(an_agent);
    an_agent.get_result(outcome);
  END request_leave;  
      
  -- used to determine if the tide is ok for a ship with a given draught to use
  -- the lock.  Note that this is a somewhat "dumbed" down version and a
  -- more exacting version would probably need expanded information available
  -- from the lock and tide objects.
  --
  -- This version takes a worst case approach disregarding the possiblity of
  -- a queue of ships on the lock.  For ships going in, that means checking if
  -- the tide will be ok after a 5 minute move and 10 minute fill / empty for
  -- a total of 15 minutes.  For ships going out, this means checking if the
  -- tide will be ok after a 5 minute move, 10 minutes fill / empty, 10 minutes
  -- fill empty for a total of 25 minutes.
  FUNCTION tide_ok(draught : integer; going_in : IN boolean) RETURN boolean IS
    time_target : integer := clock.get_time;
  BEGIN
    --IF going_in = true THEN
    --  time_target := time_target + 15;
    --ELSE
    --  time_target := time_target + 25;
    --END IF;
    -- This should probably be a method of the tide object.
    --RETURN tide.get_height_at_time(time_target) > draught;
    
    -- I have removed more complicated tide calculation functions to avoid the
    -- problem of having constant notifications when the tide is higher than
    -- the draught but the ship is not clear to go...this needs more thought
    -- as to the proper way to handle.
    RETURN tide.get_height > draught;
  END;
  
END harbour_master;
