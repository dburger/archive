WITH integer_io, text_io, ships, distributions, ada.numerics.float_random, tide;
USE integer_io, text_io, ships, distributions, ada.numerics.float_random, tide;

PROCEDURE port IS
  
  -- for creating ship arrival time samples
  inter_arrive : distribution(5);
  inter_arrive_data : data := (15, 59, 119, 179, 239, 299);
  inter_arrive_prob : data := (     5,  15,  30,  40,  10);
  
  -- for creating load percentage samples
  load : distribution(4);
  load_data : data := (60, 69, 79, 89, 100);
  load_prob : data := (    15, 30, 40,  15);
  
  -- the randomization seed
  seed : generator;
  
  -- ship reference for constructor calls
  TYPE ship_ref is ACCESS ship;
  next_ship : ship_ref;  
  
  -- filled in with values and then passed in the ship constructor
  ship_type : integer;
  length : integer;
  draught : integer;
  containers : integer;
  
  -- duration of the simulation
  duration : integer;
  
  -- delay to next ship arrival
  time_delay : integer;
    
BEGIN  
  -- set up the distributions for sampling
  set(inter_arrive, inter_arrive_data, inter_arrive_prob);
  set(load, load_data, load_prob);
  reset(seed);
  
  -- retrieve running time from the user
  put("Enter the running time for the harbor simulation: ");
  get(duration);
  
  LOOP

    -- determine ship type of next ship and set values accordingly, containers
    -- set to max and then adjust down according to the sampled load percentage
    ship_type := Integer(random(seed) * 2.0);
    IF ship_type = 0 THEN
      length := 150;
      draught := 15;
      containers := 90;
    ELSIF ship_type = 1 THEN
      length := 300;
      draught := 20;
      containers := 190;
    ELSIF ship_type = 2 THEN
      length := 450;
      draught := 25;
      containers := 400;
    END IF;    
        
    -- determine load percentage and adjust num_containers accordingly
    containers := Integer(Float(containers * sample(load)) / 100.0);
        
    -- create the new ship and let er set sail
    next_ship := new ship(length, draught, containers);
    
    -- sample time to next delay
    time_delay := sample(inter_arrive);
    
    duration := get_height;
    
    put_line(integer'IMAGE(duration));
    
    -- and wait for that delay
    -- clock.wait(time_delay);    
    DELAY 1.0;
        
  END LOOP;
  
END;
