WITH ada.calendar;
USE ada.calendar;

PACKAGE BODY clock IS

  start_time : time := ada.calendar.clock;
  
  FUNCTION time_to_secs(a_time : IN time) RETURN integer IS
  BEGIN
    RETURN Integer(seconds(a_time));
  END time_to_secs;  

  FUNCTION get_time RETURN natural IS
    time_now : time;
  BEGIN
    time_now := ada.calendar.clock;
    RETURN time_to_secs(time_now) - time_to_secs(start_time);
  END get_time;

  PROCEDURE set_rate(rate : IN positive) IS
  BEGIN
    NULL;
  END set_rate;


  PROCEDURE start IS
  BEGIN
    NULL;
  END start;


  PROCEDURE stop IS
  BEGIN
    NULL;
  END stop;


  PROCEDURE wait(interval : IN positive) IS
  BEGIN
    NULL;
  END wait;
  
END clock;
