WITH text_io;
PACKAGE server1 IS
    TYPE readWriteLock IS LIMITED PRIVATE;
    PROCEDURE write(message : string);
    FUNCTION read RETURN string;
PRIVATE
    PROTECTED type readWriteLock IS
       ENTRY startWrite;
       PROCEDURE finishWrite;
       ENTRY startRead;
       PROCEDURE finishRead;
    PRIVATE
       ENTRY waitingReaders;
       numWriters        : integer := 0;
       numReaders        : integer := 0;
       numReadersToFlush : integer := 0;
    END readWriteLock;
END server1;
