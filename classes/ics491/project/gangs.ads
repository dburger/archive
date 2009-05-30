--Gangs are autonomous actor tasks who queue up for work allocation
--  from the supervisor. A gang (one per crane) is allocated a hold   
--  at a time. Smaller ships have one hold, the largest have two.
PACKAGE gangs IS
  TYPE gang IS LIMITED PRIVATE;  
PRIVATE
  TASK TYPE gang;
END gangs;  

