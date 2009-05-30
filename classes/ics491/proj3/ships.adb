-- ships for the port simulation
-- David J. Burger
-- ICS 491, Dr. Martin
WITH harbour_master, lock, supervisor, graphics, text_io;
USE harbour_master, lock, supervisor, graphics, text_io;

PACKAGE BODY ships IS

  -- fairly straightforward, work through the port calling the graphics display
  -- at the appropriate times.  Note that the printing calls have been left in,
  -- but commented out as used during testing.
  TASK BODY ship IS
    ship_id : positive := graphics.ship_arrive(length, containers);
    where_to : move;
  BEGIN

    -- put("ship:");
    -- put(integer'IMAGE(ship_id));
    -- put_line(" has arrived, requesting entry");
    where_to := harbour_master.request_entry(length, draught);
    
    graphics.ship_at_lock(ship_id);
    
    -- put("ship:");
    -- put(integer'IMAGE(ship_id));
    -- put_line(" granted entry, requesting entry via lock");
    lock.request_enter(ship_id);        
    
    IF where_to = harbour_master.to_basin THEN
      -- put("ship:");
      -- put(integer'IMAGE(ship_id));
      -- put_line(" in basin, requesting dock");
      graphics.basin_arrive(ship_id);
      harbour_master.request_dock(length);
    END IF;
   
    graphics.quay_arrive(ship_id);
    
    -- put("ship:");
    -- put(integer'IMAGE(ship_id));
    -- put_line(" at quay, requesting unload");    
    IF length = 450 THEN
      supervisor.unload(ship_id, containers / 2, containers / 2 + containers mod 2);
    ELSE
      supervisor.unload(ship_id, containers, 0);
    END IF;

    -- put("ship:");
    -- put(integer'IMAGE(ship_id));
    -- put_line(" finished unloading, requesting exit");
    IF harbour_master.request_exit(draught) = harbour_master.to_basin THEN
      
      -- put("ship:");
      -- put(integer'IMAGE(ship_id));
      -- put_line(" in basin, requesting leave");
      graphics.basin_arrive(ship_id);
      harbour_master.request_leave(draught);
    END IF;
    
    graphics.ship_at_lock(ship_id);

    -- put("ship:");
    -- put(integer'IMAGE(ship_id));
    -- put_line(" granted exit, requesting exit via lock");    
    lock.request_exit(ship_id);
    
    ship_leave(ship_id);
    
  END ship;
   
END ships;
