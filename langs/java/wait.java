// paradigm for wait in java
private synchronized Object getRecvMessage(long waitMillis) {
    if (_recvMsg == null) {
        long waitLeft = waitMillis;
        long startTime = System.currentTimeMillis();
        while (waitLeft > 0 && _recvMsg == null) {
            try {wait(waitMillis);} catch (InterruptedException exc) { }
            waitLeft = waitMillis - (System.currentTimeMillis() - startTime);
        }
    }

    Object retVal = _recvMsg;
    _recvMsg = null;
    return retVal;
}
