
REBOL[
    Title: "Send Email with Buttons"
    File:  %emailsend.r
    Date:  20-May-2000
    Purpose: {
        A very simple email sending application that
        shows how text is input and buttons are used.
    }
    Category: [view email VID 1]
]

view layout [
    backdrop 40.70.140
    origin 40x20
    subtitle "Send Group Email:"
    text "Email File:"
    txtEmailFile: field 210x25
    text "Message:"
    txtMessage: area 420x210
    across return
    text "Current Operation:"
    txtCurrentAddress: field 210x25
    return
    button "Do It" [
    
        emailfile: read/lines to-file txtEmailFile/text


        i: 0
        
        foreach line emailfile [
        
            txtCurrentAddress/text: join "Sending to:  " line show txtCurrentAddress
    
            send make email! line txtMessage/text
    
            ;increase the batch number
            i: i + 1
    
            ;waits ten minutes between batches
            if i = 10 [
                txtCurrentAddress/text: join "Waiting/last:  " line show txtCurrentAddress
                wait 0:10:0
                ;set batch count back to 0
                i: 0 
            ]    

        ]
    
    ]
    button "Quit" [quit]
    
]
