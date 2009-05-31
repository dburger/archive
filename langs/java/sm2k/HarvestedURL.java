import java.net.*;
import java.io.*;
import java.util.TreeMap;
import java.util.Set;
import java.util.TreeSet;

public class HarvestedURL {

    private URL murlFull;

    //using a TreeMap so we can get sorted order
    private static TreeMap tmNoFollow = new TreeMap();

    //Purpose:  to create and return a new HarvestedURLObject
    //Preconditions:  this constructor is passed a url found on a web page in
    //    String sHREF and the URL urlContext of the web page it was found on
    //Postconditions:  a HarvestedURLObject is created and returned, any
    //    reference part (#whatever) is removed to prevent multiple spidering
    //    of the same page
    HarvestedURL(String sHREF, URL urlContext) throws MalformedURLException {
        setSource(sHREF, urlContext);
    }

    //Purpose:  this constructor should only been used when passing a full url
    HarvestedURL(String sHREF) throws MalformedURLException {
        try {
            murlFull = new URL(sHREF);
        } catch (MalformedURLException e) {
            throw e;
        }
    }

    public static boolean addNoFollow(String sExtension) {
        if (!tmNoFollow.containsKey(sExtension)) {
            tmNoFollow.put(sExtension,null);
            return true;
        } else
            return false;
    }

    public static void removeNoFollow(String sExtension) {
        tmNoFollow.remove(sExtension);
    }

    public static Object[] noFollowArray() {
        Set s = new TreeSet();
        s = tmNoFollow.keySet();
        return s.toArray();
    }

    public boolean isEmail() {
        //the url object takes care of case issues
        return murlFull.getProtocol().equals("mailto");
    }

    public String getEmail() {
        if (isEmail()) {
            return murlFull.getFile();
        }
            throw new RuntimeException("The harvested url is not an email address.");
    }

    public void setSource (String sHREF, URL urlContext) throws MalformedURLException {
        //only work on it if it doesn't contain a query string
        if (sHREF.indexOf('?')==-1) {
            //we never want to let a url have a reference in it because it will certainly
            //cause multiple spidering of the same file
            int nRefPos = sHREF.indexOf('#');
            if (nRefPos>-1)
                sHREF = sHREF.substring(0,nRefPos);
            //this code looks at the sHREF to see if it is merely path
            //or if it contains a path + a file, if it is merely path,
            //but the web designer neglected to add a / at the end, we
            //make sure to add it so that we don't get
            //http://www.whatever.com/dburger
            //http://www.whatever.com/dburger/
            //duplicates
            int nHREFLen = sHREF.length();
            if (nHREFLen>0) {
                if (sHREF.charAt(nHREFLen-1)!='/') {
                    int nLastForSlashPos = sHREF.lastIndexOf('/',nHREFLen-1);
                    if (nLastForSlashPos==-1) {
                        if (sHREF.indexOf('.',0)==-1) {
                            sHREF+='/';
                        }
                    } else {
                        if (sHREF.indexOf('.',nLastForSlashPos)==-1) {
                            sHREF+='/';
                        }
                    }
                }
            }
        }

        try {
            murlFull = new URL(urlContext,sHREF);
            //probably not necessary changes http://www.whatever.com/pizza
            //                            to http://www.whatever.com/pizza/
            //String sFilePart = murlFull.getFile();
            //if (sFilePart.length()>0 && sFilePart.indexOf(".")==-1 && sFilePart.charAt(sFilePart.length()-1)!='/') {
            //    murlFull = new URL(murlFull.toString() + "/");
            //}
        } catch (MalformedURLException e) {
            throw e;
        }

    }

    public String toString() {
        return murlFull.toExternalForm();
    }

    public URL getFullURL() {
        return murlFull;
    }

    public String getHost() {
        return murlFull.getHost();
    }

    public InputStream openStream() throws IOException {
        try {
            return murlFull.openStream();
        } catch (IOException e) {
            throw e;
        }
    }

    public boolean shouldSpider(String sHostMatch) {
        String s;
        if (!murlFull.getProtocol().equals("http"))
            return false;
        else {
            String sTempHost = murlFull.getHost();
            //this matches either a whole domain, i.e. www.yahoo.com
            //or at the end of the domain, i.e. k12.hi.us
            //or if you want to spider forever, .com, .edu, ...etc
            if (sTempHost.length() >= sHostMatch.length() && sTempHost.substring(sTempHost.length()-sHostMatch.length()).equals(sHostMatch)) {
                //so it matched the host from above
                //now check to see if the file extension is a spiderable type
                String sFilename = murlFull.getFile();
                int nPeriodPos = sFilename.lastIndexOf(".");
                if (nPeriodPos>-1) {
                    String sFileExtension = sFilename.substring(nPeriodPos);
                    if (tmNoFollow.containsKey(sFileExtension.toLowerCase())) return false;
                }
            } else
                return false;
            return true;
        }
    }
}
