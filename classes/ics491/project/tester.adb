WITH integer_io, text_io, clock;
USE integer_io, text_io, clock;

PROCEDURE tester IS
  the_time : integer;  
BEGIN
  LOOP
    the_time := get_time;
    put_line(integer'Image(the_time));
    DELAY 1.0;
  END LOOP;

END;
