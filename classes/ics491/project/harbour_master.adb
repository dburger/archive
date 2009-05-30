PACKAGE BODY harbour_master IS

  PROCEDURE request_dock (length : IN positive) IS
  BEGIN
     NULL;
  END request_dock;


  FUNCTION request_entry(length : IN positive; draught : IN positive) RETURN move IS
  BEGIN
     RETURN request_entry (length, draught);
  END request_entry;


  FUNCTION request_exit (draught : IN positive) RETURN move IS
  BEGIN
     RETURN request_exit (draught);
  END request_exit;


  PROCEDURE request_leave (draught : IN positive) IS
  BEGIN
     NULL;
  END request_leave;

END harbour_master;
