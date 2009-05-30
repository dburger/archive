PACKAGE BODY server2 IS

   --  The policy I have enforced for this server is:
   --
   --    readers - any number of simultaneous readers may exist, but not if
   --              there is a writer updating the shared resource
   --    writers - writers are allowed to access one at a time, but not if there
   --              are any readers
   --
   --  Because in most server situations the number of reads will be greater
   --  than the number of writes, and writes are likely to be more time
   --  consuming than reads, I have implemented a flushing policy.  That is that
   --  whenever a write takes place reads that come in during the write
   --  operation are placed on a queue of waiting readers.  When the write
   --  operation completes the waiting readers are given priority as they are
   --  all "flushed" before other operations take place.  With a constant flow
   --  of readers and writers the flow of execution becomes:
   --
   --    Allow one writer, flush waiting readers, repeat...   
   
    TASK BODY readWriteLock IS
    numWriters        : integer := 0;
    numReaders        : integer := 0;
    numReadersToFlush : integer := 0;
    BEGIN
       LOOP
          SELECT
             -- guard conditions prevent startWrite when active writer, active readers, or readers to flush
             WHEN numReaders = 0 AND THEN numWriters < 1 AND THEN numReadersToFlush = 0 =>
             ACCEPT startWrite DO
                -- used to indicate an active writer
                numWriters := numWriters + 1;
             END startWrite;
          OR
             ACCEPT finishWrite DO
                -- used to indicate no longer an active writer
                numWriters := numWriters - 1;
                -- and set up to flush all the readers that came in during this write
                numReadersToFlush := waitingReader'COUNT;
             END finishWrite;
          OR
             ACCEPT startRead DO
                -- if there is an active writer, or already writers waiting, this
                -- read will be flushed after the next write finishes, so we place
                -- ourselves on the waitingReaders queue
                IF numWriters > 0 OR ELSE startWrite'COUNT > 0 THEN
                   REQUEUE waitingReader;
                END IF;
                -- used to indicate an active reader
                numReaders := numReaders + 1;
             END startRead;
          OR
             ACCEPT finishRead DO
                -- decrement the number of active readers
                numReaders := numReaders - 1;
             END finishRead;
          OR
             -- guard condition only allows waiting readers to proceed when a
             -- finished write set numReadersToFlush to the number of waiting readers
             WHEN numReadersToFlush > 0 =>
             ACCEPT waitingReader DO
                -- when numReadersToFlush goes to 0 this ENTRY queue will be locked again
                numReadersToFlush := numReadersToFlush - 1;
                -- used to indicate an active reader
                numReaders := numReaders + 1;
             END waitingReader;
          OR
             TERMINATE;
          END SELECT;
       END LOOP;
    END readWriteLock;
    
    -- the share resource
    message : string(1..23);
    -- the lock used to control access to the shared resource
    rwlock : readWriteLock;

    PROCEDURE write(message : string) IS
    BEGIN
      rwlock.startWrite;
      server2.message := message;
      rwlock.finishWrite;
    END write;

    FUNCTION read RETURN string IS
    temp : string(1..23);
    BEGIN
      rwlock.startRead;
      temp := server2.message;
      rwlock.finishRead;
      RETURN temp;
    END read;

END server2;
