REBOL [Title: "Dump Web links"] 

parse load/markup read to-url system/script/args [ 
some [set x tag! ( 
if x: find/tail x "href=" [print trim/with form x {<">}] 
) | string! 
] 
] 