WITH integer_io, text_io, ships, distributions, ada.numerics.float_random, tide, clock;
USE integer_io, text_io, ships, distributions, ada.numerics.float_random, tide, clock;

PROCEDURE port IS
  
  -- for creating ship arrival time samples
  inter_arrive : distribution(5);
  inter_arrive_data : data := (15, 59, 119, 179, 239, 299);
  inter_arrive_prob : data := (     5,  15,  30,  40,  10);
  
  -- for creating load percentage samples
  load : distribution(4);
  load_data : data := (60, 69, 79, 89, 100);
  load_prob : data := (    15, 30, 40,  15);
  
  -- for creating ships
  ship_dist : distribution(3);
  ship_data : data := (1, 1, 2, 3);
  ship_prob : data := (30, 40, 30);
      
  -- filled in with values and then used in the ship constructor
  ship_type : integer;
  container_cnt : integer;
  
  -- duration of the simulation
  duration : integer;
  
  -- rate for the clock during simulation
  rate     : integer;
  
  -- delay to next ship arrival
  time_delay : integer := 0;
  
  -- ship reference for constructor calls
  TYPE ship_ref is ACCESS ship;
  next_ship : ship_ref;  

  -- data about ships used in constructor calls  
  TYPE ship_data_array IS ARRAY(1..3) of INTEGER;
  lengths : ship_data_array := (150, 300, 450);
  draughts : ship_data_array := (15, 20, 25);
  containers : ship_data_array := (90, 190, 400);

BEGIN  
  -- set up the distributions for sampling
  set(inter_arrive, inter_arrive_data, inter_arrive_prob);
  set(load, load_data, load_prob);
  set(ship_dist, ship_data, ship_prob);
    
  -- some hard coded units for start up
  duration := 1000;
  rate := 360;
  
  clock.set_rate(rate);
  clock.start;
  
  -- time delay is 0 on first loop, and then set at bottom of loop from there on
  WHILE duration > get_time AND THEN clock.wait(time_delay) = false LOOP

    -- ship_type := 1, 2, or 3
    ship_type := sample(ship_dist);
                    
    -- determine load percentage and adjust num_containers accordingly
    container_cnt := Integer(Float(containers(ship_type) * sample(load)) / 100.0);
    
    -- create the new ship and let er set sail
    next_ship := new ship(lengths(ship_type), draughts(ship_type), container_cnt);
    
    -- sample time to next delay
    time_delay := sample(inter_arrive);
        
  END LOOP;
  
END;
