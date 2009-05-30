WITH text_io, clock;
USE text_io, clock;

PACKAGE BODY tide IS

  base_tide : integer := 10;  -- low tide 10 feet
  tide_swing : float := 20.0; -- with a 20 foot swing

  FUNCTION get_height RETURN positive IS
    time_offset : integer; -- time since last high tide
    cycle : integer;
    percent : float;
    the_time : integer;
  BEGIN    
    the_time := get_time;
    put("the time is now ");
    put_line(integer'Image(the_time));
    time_offset := the_time mod ((12 * 60) + 20);
    cycle := the_time / ((12 * 60) + 20);
    percent := Float(time_offset) / Float((12 * 60) + 20);
    IF cycle mod 2 = 0 THEN
      RETURN base_tide + Integer((1.0 - percent) * tide_swing);
    ElSE
      RETURN base_tide + Integer(percent * tide_swing);
    END IF;
  END get_height;

END tide;
