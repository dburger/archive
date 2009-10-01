// printStackTrace can go to PrintStream or PrintWriter

StringWriter w = new StringWriter();
PrintWriter p = new PrintWriter(w, true);
exc.printStackTrace(p);
w.toString();

// or

ByteArrayOutputStream b = new ByteArrayOutputStream();
PrintStream p = new PrintStream(b);
exc.printStackTrace(p);
b.toString();
