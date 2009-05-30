REBOL [
    Title: "Web HTML Tag Extractor"
    File:  %websplit.r
    Date:  20-May-1999
    Purpose: "Separate the HTML tags from the body text of a document."
    Category: [web net text 3] 
]

tags: make block! 100

text: make string! 8000

html-code: [
    copy tag ["<" thru ">"] (append tags tag) | 
    copy txt to "<" (append text txt)
]

page: read http://webpages.hsa-kauai.net/dburger

if find page "jobs" [write %result.html page]

parse page [to "<" some html-code]

foreach tag tags [
    print tag
    parse tag [to "href="]
]

foreach tag tags [
    if parse tag ["<A" thru "HREF="
        [{"} copy link to {"} | copy link to ">" | copy link to " " | {'} copy link to {'}]
        to end
    ][print link]
]

print text
