PACKAGE server2 IS
    TYPE readWriteLock IS LIMITED PRIVATE;
    PROCEDURE write(message : string);
    FUNCTION read RETURN string;
PRIVATE
    TASK type readWriteLock IS
       ENTRY startWrite;
       ENTRY finishWrite;
       ENTRY startRead;
       ENTRY finishRead;
    PRIVATE
       ENTRY waitingReader;
    END readWriteLock;
END server2;
