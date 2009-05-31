#!/bin/sh



# This routine takes a string containing one or more hex values
# preceeded by % (ie %2F) and converts it to the corresponding
# ASCII value (ie %2F -> "/").
#
# Input must be in convertHex2ASCII_Input and output is returned
# in convertHex2ASCII_Output.  The file ascii-table must reside
# in the current directory.
#
# Created by George Toft, June 1998
#


convertHex2ASCII() {

    # Step 1 - create input and output variables
    hex=$convertHex2ASCII_Input
    convertHex2ASCII_Output=$(echo $convertHex2ASCII_Input | cut -f 1 -d"%")
    # Step 2 - add % to the end of the input string - 
    #   we will use cut with % delimiters to parse the input
    #   string.
    hex=$hex"%"

    # loop through entire string
    asciicounter=2
    asciitemp=$(echo $hex | cut -f $asciicounter -d "%")
    while [ "$asciitemp" != "" ]
    do
        # Step 3 - Save any string after the hex
        asciistring=$(echo $asciitemp | cut -b 3-)
        asciitemp=$(echo $asciitemp | cut -b 1-2)

        # Step 4 - Convert %XX to ASCII via lookup table and assemble
        convertHex2ASCII_Output=$convertHex2ASCII_Output$(grep $asciitemp ascii-table | cut -b 3)$asciistring

        # Prepare for next iteration
        asciicounter=$((asciicounter+1))
        asciitemp=$(echo $hex | cut -f $asciicounter -d "%")
    done

    return 0
}


# This routine gets the CGI data from a POST method and saves
# the data retrieved in the environment with the name of the field
# sent.  For example, if the field "name" exists in a form, the
# environment variable FORM_name will hold its value.  Additionally,
# FORM_ contains how many fields were parsed.
#
# Created by George Toft, June 1998
#
parseCGI() {

    # POST method puts data in STDIN
    read input_buffer

    # Break up name-value pairs and export them
    # name=value&name=value&name=value

    # step 1 - add & to the end to make & delimited fields
    input_buffer=$input_buffer"&"

    # Step 2 - cut out the & delimited fields
    counter=1
    #put in by djb to change + to space, causes later parse to malfunction
    #input_buffer=$(echo $input_buffer | tr '+' ' ')
    temp=$(echo $input_buffer | cut -f $counter -d "&")
    while [ "$temp" != "" ]
    do
        # Convert temp (which contains hex) to ASCII
        convertHex2ASCII_Input=$temp
        convertHex2ASCII
        temp=$convertHex2ASCII_Output

        # Step 3 - put them in the environment
        eval "export FORM_"$temp
        counter=$((counter+1))
        temp=$(echo $input_buffer | cut -f $counter -d "&")
    done
    eval "export FORM_="$((counter-1))

    return 0
}


