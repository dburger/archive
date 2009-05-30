WITH text_io;
USE text_io;

PACKAGE BODY ships IS
  TASK BODY ship IS
  BEGIN
    put_line("request entry from harbor master");
    put_line("request entry to lock from harbor master");
    put_line("request move to quay from harbor master");
    put_line("request gangs from supervisor");
    put_line("request exit from harbor master");
    put_line("request exit basin from harbor master");
    put_line("I'm outta here");
  END ship;
   
END ships;
