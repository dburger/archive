WITH text_io, ada.numerics.float_random, server1; 
USE  text_io, ada.numerics.float_random;
PROCEDURE project1 IS

 TASK TYPE client(id : integer);
 TYPE client_ref IS ACCESS client;
 TASK BODY client IS
   rand    : generator;
   message : string(1 .. 23) := "Message   from client  ";
   reply   : string(1 .. 23);
   value   : float;
   msg_num : natural := 0;
 BEGIN
   WHILE msg_num < 10 LOOP
     value := random(rand);
     IF value < 0.1 THEN
       msg_num := msg_num + 1;
       message(9)  := character'VAL(msg_num + 48);
       message(23) := character'VAL(id + 48); 
       text_io.put_line(integer'IMAGE(id) & ":Request write:-" & message);  
       server1.write(message);
       text_io.put_line(integer'IMAGE(id) & ":Request write completed");      
     ELSE
       text_io.put_line(integer'IMAGE(id) & ":Request read");
       reply := server1.read;
       text_io.put_line(integer'IMAGE(id) & ":Read - " & reply);
     END IF;
   END LOOP;
 EXCEPTION
   WHEN OTHERS => put_line("Error in client " & integer'IMAGE(id));  
 END client;
 clients : ARRAY(1 .. 9) OF client_ref;
BEGIN
 FOR i IN 1 .. 9 LOOP
   clients(i) := new client(i);
 END LOOP;
END project1;

