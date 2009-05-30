REBOL [
    Title: "Email Group Sender"
    File:  %mailsendgroup.r
    Date:  10-Sep-1999
    Purpose: {A very simple way to send email to a group.}
    Note: {
        The TRIM function below is used to remove the blank
        lines from the head of the email, so that the first
        line of text gets used as the subject.
    }
    Category: [email net 1] 
]

print "The email file should have a seperate email address on each line"
emailfile: read/lines to-file ask "Filename? "

i: 0

trace/net on

foreach line emailfile [

    print line
    
    send make email! line trim {
        grade book software
        
        Tired of spending so much time keeping track of your
        grades when you should be spending your time teaching?
        
        Try Excel-lent Gradebook.  Excel-lent Gradebook is a
        grade book program that runs inside of Excel.  It has
        features that will make grading easier and it is simple
        to use.
        
        You can learn about Excel-lent Gradebook's many features
        and download a free trial version by going to:
        
        http://webpages.hsa-kauai.net/dburger/gradebook/gradebook.html
        
        You owe it to yourself to check it out.  I guarantee
        that it will save you time with features like instant
        progress reports, html grade sheets, emailing of grades,
        and more.  The trial version will only keep track of one
        period at a time, however, a version that will let you
        keep track of 6 classes in the same file is a mere $19.95.
        Check it out today!
        
        David J. Burger
    }
    
    ;increase the batch number
    i: i + 1
    
    ;waits ten minutes between batches
    if i = 10 [
        wait 0:10:0
        ;set batch count back to 0
        i: 0 
    ]    

]
