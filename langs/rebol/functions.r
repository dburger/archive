REBOL [
	Title:	"Generate Random Character Sequence Routine"
	Author: "David Burger"
	Email:	dburger@aloha.net
	Date:	14-Jul-1999
	
	Purpose: {
		The purpose of this script is to generate a random sequence
         of characters for tasks such as generating passwords.
	}
] 

GenerateRandCharSequence: function [nCharacters] [nLoop sTemp] [

  random/seed now
  actions: [[(random 10) - 1] [to-char 64 + random 26] [to-char 96 + random 26]]
  sTemp: ""
  loop nCharacters [
    nType: random 3
    append sTemp do pick actions nType
  ]
  return sTemp
]

{an example}

print GenerateRandCharSequence 10