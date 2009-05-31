import java.io.*;
import java.util.TreeMap;
import java.util.StringTokenizer;
import java.net.*;

/**
 * A class that can spider the web starting at a specific
 * web page following hyperlinks that match a specified
 * host match.  The email addresses found are stored in
 * a specified file.
 * 
 * @author David J. Burger
 * @version 1.0
 * @since 06/19/01
 */
public class EmailSpider extends Thread {

    private TreeMap tmSpider;
    private TreeMap tmOutput;

    private String msSpiderFile;
    //note that we could store the spider list in a queue, it would
    //work faster, however, by storing it in a file we get two benefits
    //1.  saves on memory used by the program
    //2.  if the program bails the last harvested url can be located
    //    and the spider can continue from there
    private String msOutputFile;
    private String msLastHarvestFile;

    private String msStartingPage;
    private String msHostMatch;

    private int mnHostLimit;
    
    private Status statusListener;

    private boolean mbLoadPrevious;

    //for multi-threading notifications
    private boolean pauseFlag = false;
    private boolean stopFlag = false;

    EmailSpider() {
        tmSpider = new TreeMap();
        tmOutput = new TreeMap();
    }

    EmailSpider(String sStartingPage, String sHostMatch, String sOutputFile, String sSpiderFile, String sLastHarvestFile, int nHostLimit, Status sl, boolean bLoadPrevious) {
        msStartingPage = sStartingPage;
        msHostMatch = sHostMatch;
        msOutputFile = sOutputFile;
        msSpiderFile = sSpiderFile;
        msLastHarvestFile = sLastHarvestFile;
        mnHostLimit = nHostLimit;
        statusListener = sl;
        mbLoadPrevious = bLoadPrevious;
        tmSpider = new TreeMap();
        tmOutput = new TreeMap();
    }

    public synchronized void setPaused(boolean b) {
        if (b)
            pauseFlag = true;
        else {
            pauseFlag = false;
            notify();
        }
    }

    public synchronized void setStopped(boolean b) {
        stopFlag = b;
    }

    /**
     * Method that starts the spider process.
     */
    public void run() {

        //URL urlCurrent;
        HarvestedURL urlCurrent;
        String sCurrentPage;
        String sInputLine;
        BufferedReader webIn;
        BufferedReader fileInput;

            //first we check to see if a residual run needs to be
            //completed, this is indicated by a Last Harvest file that
            //has a value in it

        try {
            if (mbLoadPrevious) {
                loadPreviousRun();
                BufferedReader fileLastHarvest = new BufferedReader(new FileReader(msLastHarvestFile));
                sInputLine = fileLastHarvest.readLine();
                fileInput = new BufferedReader(new FileReader(msSpiderFile));
                //position fileInput at the proper line for the next page
                //to harvest
                while (!(fileInput.readLine().equals(sInputLine)));
                statusListener.status("Resuming standard spider.");
            } else {
                urlCurrent = new HarvestedURL(msStartingPage);
                insertIntoSpiderTree(urlCurrent,true);
                fileInput = new BufferedReader(new FileReader(msSpiderFile));
            }

            while ((sCurrentPage = fileInput.readLine()) != null) {
                try {
                    //we use the HarvestedURL constructor that expects
                    //to receive a full url because these are coming
                    //from the file they should always be ok
                    urlCurrent = new HarvestedURL(sCurrentPage);

                    statusListener.status("Harvesting:    " + sCurrentPage);
                    setCurrentHarvest(sCurrentPage);
                    try {
                        webIn = new BufferedReader(new InputStreamReader(urlCurrent.openStream()));
                        while ((sInputLine = webIn.readLine()) != null) {
                            parseHTMLString(sInputLine,urlCurrent,"href=",msHostMatch);
                            parseHTMLString(sInputLine,urlCurrent,"frame src=",msHostMatch);
                        }
                        webIn.close();
                    } catch (IOException e) {
                        statusListener.status(e.getMessage());
                    }
                } catch (MalformedURLException e) {
                    statusListener.status(e.getMessage());
                }
                //check to see if they want to stop
		if (stopFlag) {
                    statusListener.status("Spider stopped.");
                    return;
                }
                synchronized(this) {
                    while (pauseFlag) {
                        try {
                            wait();
                        } catch (InterruptedException e) {
                            //just let it loop back
                        }
                    }
                }
                /*
                try {
                    //to keep it here while paused
                    while (pauseFlag) {
                        sleep(100);
			//still need to check for stop flag in this pause loop
                        if (stopFlag) {
			    statusListener.status("Spider stopped.");
                            return;
			}
		    }
		} catch (InterruptedException e) {
		    statusListener.status(e.getMessage());
                }
                */
            }
        } catch (IOException e) {
            statusListener.status(e.getMessage());
        }
        statusListener.status("Work complete.");
    }

    /**
     * Method that looks for href= in the html string.  If
     * found to be a valid hyperlink it is added to the list
     * of files to spider.  If found to be an email it is added
     * to the email output file.
     * 
     * @param sHTML      the htmls string
     * @param urlContext the url from which the html was found
     * @param sAttribParsingFor
     *                   the attribute we are searching for, currently set up to
     *                   work with href= attributes
     * @param sHostMatch A string representing the tail end of a matching host.
     *                   For example, sHostMatch=".edu" would only spider to .edu
     *                   sites and sHostMatch="hawaii.edu" would spider univ.
     *                   of Hawaii sites
     */
    private void parseHTMLString(String sHTML, HarvestedURL urlContext, String sAttribParsingFor, String sHostMatch) {
        String sTempURL;
        char charDelimiter;
        int nStartPos;
        int nEndPos;
        int nSpacePos;
        int nGreaterThanPos;
        int nFoundPos = 0;
        HarvestedURL hurlTemp;
        //this while loop looks for href =
        while ((nFoundPos=sHTML.indexOf(sAttribParsingFor ,nFoundPos)) > -1) {
            nStartPos = nFoundPos + sAttribParsingFor.length();
            if (sHTML.length() > nStartPos) {
                charDelimiter = sHTML.charAt(nStartPos);
                switch (charDelimiter) {
                    case '\"':
                        nStartPos++;
                        nEndPos = sHTML.indexOf("\"",nStartPos);
                        break;
                    case '\'':
                        nStartPos++;
                        nEndPos = sHTML.indexOf("\'",nStartPos);
                        break;
                    default:
                        //not using "http://... or 'http://...
                        //so we look for the space or > that
                        //will terminate the http://
                        nSpacePos = sHTML.indexOf(" ",nStartPos+1);
                        nGreaterThanPos = sHTML.indexOf(">",nStartPos+1);
                        if (nSpacePos < 0 && nGreaterThanPos < 0) {
                            //didn't find the ending delimiter on the same line
                            nEndPos = -1;
                        } else if (nGreaterThanPos < 0) {
                            nEndPos = nSpacePos;
                        } else if (nSpacePos < 0) {
                            nEndPos = nGreaterThanPos;
                        } else {
                            nEndPos = (nSpacePos < nGreaterThanPos) ? nSpacePos : nGreaterThanPos;
                        }
                }
                if (nEndPos > nStartPos) {
                    sTempURL = sHTML.substring(nStartPos,nEndPos);
                    statusListener.status("  Considering:   " + sTempURL);
                    try {
                        hurlTemp = new HarvestedURL(sTempURL,urlContext.getFullURL());
                        statusListener.status("  Changed to:    " + hurlTemp.toString());
                        if (hurlTemp.isEmail()) {
                            appendToOutputFile(hurlTemp.getEmail());
                        } else if (hurlTemp.shouldSpider(sHostMatch)) {
                            insertIntoSpiderTree(hurlTemp,true);
                        } else
                            statusListener.status("  Discarding");
                    } catch (MalformedURLException e) {
                        //wasn't a good url
                        statusListener.status(e.getMessage());
                    }
                }
            }
            nFoundPos++;
        }
    }

    /**
     * Sets the string in the msLastHarvest file to the file
     * currently harvesting so if a problem occurs the spider
     * can be picked up where it was stopped at.
     * 
     * @param sURL   the url of the page we are currently spidering.
     */
    private void setCurrentHarvest(String sURL) {
        try {
            PrintWriter fileOutput = new PrintWriter(new FileOutputStream(msLastHarvestFile, false));
            fileOutput.println(sURL);
            fileOutput.close();
        } catch (IOException e) {
            statusListener.status(e.getMessage());
        }
    }

    /**
     *  Also adds the url to the
     * tmSpider TreeMap so that it can be quickly retrieved
     * to determine what has already been set to be spidered
     * 
     * @param theURL the url to add to the spider file.
     */
    private void insertIntoSpiderTree(HarvestedURL theURL, boolean addToSpider) {
        try {
            //note the TreeMap of hosts with a TreeMap of the urls
            //at that host in the TreeMap node.  This is done so
            //that limits can be added for the number of pages to
            //spider under one host.
            TreeMap domainTree;
            domainTree = (TreeMap)tmSpider.get(theURL.getHost());
            if (domainTree==null) {
                statusListener.status("  New host:      " +   theURL.getHost());
                domainTree = new TreeMap();
                tmSpider.put(theURL.getHost(),domainTree);
            }
            if (domainTree.containsKey(theURL.toString())) {
                statusListener.status("  Duplicate URL");
            } else {
                if (mnHostLimit==0 || domainTree.size()<mnHostLimit) {
                    statusListener.status("  Adding URL");
                    domainTree.put(theURL.toString(),null);
                    if (addToSpider) {
                        PrintWriter fileOutput = new PrintWriter(new FileOutputStream(msSpiderFile, true));
                        fileOutput.println(theURL.toString());
                        fileOutput.close();
                    }

                } else {
                    statusListener.status("  Host limit reached.");
                }
            }
        } catch (IOException e) {
            statusListener.status(e.getMessage());
        }
    }

    /**
     * Adds the given text (email) to the output file.  Also
     * adds the text to the tmOutput spider.
     * 
     * @param sNewItem the string to add to the output file.
     */
    private void appendToOutputFile(String sNewItem) {
        try {
            if (tmOutput.containsKey(sNewItem)) {
                statusListener.status("  Duplicate email");
            } else {
                statusListener.status("  Adding email");
                tmOutput.put(sNewItem,null);
                PrintWriter fileOutput = new PrintWriter(new FileOutputStream(msOutputFile, true));
                fileOutput.println(sNewItem);
                fileOutput.close();
            }
        } catch (IOException e) {
            statusListener.status(e.getMessage());
        }
    }

    /**
     * this method is able to load the data structures that keep
     * track of spidered pages and stored email addresses with
     * those of a previous run we restarting a stopped spider
     * run.  It first checks if the lastHarvest file already
     * has a value and if so it attempt to recover the data.
     * 
     * @param fileInput the lastHarvest file.
     * @return returns true if previous run information was loaded, false otherwise
     */
    private void loadPreviousRun() {
        HarvestedURL theURL;
        TreeMap domainTree;
        try {
            BufferedReader fileSpider = new BufferedReader(new FileReader(msSpiderFile));
            statusListener.status("Indexing already spidered pages.");
            String sAlreadyHarvestedPage;
            //note that the passed in fileInput must be left at the right location
            while ((sAlreadyHarvestedPage = fileSpider.readLine())!=null) {
                statusListener.status("  Indexing:      " + sAlreadyHarvestedPage);
                try {
                    theURL = new HarvestedURL(sAlreadyHarvestedPage);
                    //false to keep it from adding to the spider file again
                    insertIntoSpiderTree(theURL,false);
                } catch (MalformedURLException e) {
                    //for some reason some URL's will throw this exception when
                    //added by themselves, that is not added with a context as
                    //was done before
                    statusListener.status(e.getMessage());
                }
            }
            statusListener.status("Indexing already retrieved emails.");
            BufferedReader fileEmail = new BufferedReader(new FileReader(msOutputFile));
            String sAlreadyHarvestedEmail;
            while ((sAlreadyHarvestedEmail = fileEmail.readLine())  != null) {
               statusListener.status("  Indexing:      " + sAlreadyHarvestedEmail);
               tmOutput.put(sAlreadyHarvestedEmail,null);
            }
        } catch (IOException e) {
            //no last harvest file found so threw IO exception
            //in other words, no previous run information found
            statusListener.status(e.getMessage());
        }
    }

}
