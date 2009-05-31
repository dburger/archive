Attribute VB_Name = "basMain"
Option Explicit
Public Const MAX_PATH = 260
Public gasGenres(0 To 255) As String
Public Sub SetUpGenres()
  gasGenres(0) = "Blues"
  gasGenres(1) = "Classic Rock"
  gasGenres(2) = "Country"
  gasGenres(3) = "Dance"
  gasGenres(4) = "Disco"
  gasGenres(5) = "Funk"
  gasGenres(6) = "Grunge"
  gasGenres(7) = "Hip-Hop"
  gasGenres(8) = "Jazz"
  gasGenres(9) = "Metal"
  gasGenres(10) = "New Age"
  gasGenres(11) = "Oldies"
  gasGenres(12) = "Other"
  gasGenres(13) = "Pop"
  gasGenres(14) = "R&B"
  gasGenres(15) = "Rap"
  gasGenres(16) = "Reggae"
  gasGenres(17) = "Rock"
  gasGenres(18) = "Techno"
  gasGenres(19) = "Industrial"
  gasGenres(20) = "Alternative"
  gasGenres(21) = "Ska"
  gasGenres(22) = "Death Metal"
  gasGenres(23) = "Pranks"
  gasGenres(24) = "Soundtrack"
  gasGenres(25) = "Euro-Techno"
  gasGenres(26) = "Ambient"
  gasGenres(27) = "Trip-Hop"
  gasGenres(28) = "Vocal"
  gasGenres(29) = "Jazz+Funk"
  gasGenres(30) = "Fusion"
  gasGenres(31) = "Trance"
  gasGenres(32) = "Classical"
  gasGenres(33) = "Instrumental"
  gasGenres(34) = "Acid"
  gasGenres(35) = "House"
  gasGenres(36) = "Game"
  gasGenres(37) = "Sound Clip"
  gasGenres(38) = "Gospel"
  gasGenres(39) = "Noise"
  gasGenres(40) = "AlternRock"
  gasGenres(41) = "Bass"
  gasGenres(42) = "Soul"
  gasGenres(43) = "Punk"
  gasGenres(44) = "Space"
  gasGenres(45) = "Meditative"
  gasGenres(46) = "Instrumental Pop"
  gasGenres(47) = "Instrumental Rock"
  gasGenres(48) = "Ethnic"
  gasGenres(49) = "Gothic"
  gasGenres(50) = "Darkwave"
  gasGenres(51) = "Techno-Industrial"
  gasGenres(52) = "Electronic"
  gasGenres(53) = "Pop-Folk"
  gasGenres(54) = "Eurodance"
  gasGenres(55) = "Dream"
  gasGenres(56) = "Southern Rock"
  gasGenres(57) = "Comedy"
  gasGenres(58) = "Cult"
  gasGenres(59) = "Gangsta"
  gasGenres(60) = "Top 40"
  gasGenres(61) = "Christian Rap"
  gasGenres(62) = "Pop/Funk"
  gasGenres(63) = "Jungle"
  gasGenres(64) = "Native American"
  gasGenres(65) = "Cabaret"
  gasGenres(66) = "New Wave"
  gasGenres(67) = "Psychadelic"
  gasGenres(68) = "Rave"
  gasGenres(69) = "Showtunes"
  gasGenres(70) = "Trailer"
  gasGenres(71) = "Lo-Fi"
  gasGenres(72) = "Tribal"
  gasGenres(73) = "Acid Punk"
  gasGenres(74) = "Acid Jazz"
  gasGenres(75) = "Polka"
  gasGenres(76) = "Retro"
  gasGenres(77) = "Musical"
  gasGenres(78) = "Rock & Roll"
  gasGenres(79) = "Hard Rock"
  gasGenres(80) = "Folk"
  gasGenres(81) = "Folk-Rock"
  gasGenres(82) = "National Folk"
  gasGenres(83) = "Swing"
  gasGenres(84) = "Fast Fusion"
  gasGenres(85) = "Bebob"
  gasGenres(86) = "Latin"
  gasGenres(87) = "Revival"
  gasGenres(88) = "Celtic"
  gasGenres(89) = "Bluegrass"
  gasGenres(90) = "Avantgarde"
  gasGenres(91) = "Gothic Rock"
  gasGenres(92) = "Progressive Rock"
  gasGenres(93) = "Psychedelic Rock"
  gasGenres(94) = "Symphonic Rock"
  gasGenres(95) = "Slow Rock"
  gasGenres(96) = "Big Band"
  gasGenres(97) = "Chorus"
  gasGenres(98) = "Easy Listening"
  gasGenres(99) = "Acoustic"
  gasGenres(100) = "Humour"
  gasGenres(101) = "Speech"
  gasGenres(102) = "Chanson"
  gasGenres(103) = "Opera"
  gasGenres(104) = "Chamber Music"
  gasGenres(105) = "Sonata"
  gasGenres(106) = "Symphony"
  gasGenres(107) = "Booty Bass"
  gasGenres(108) = "Primus"
  gasGenres(109) = "Porn Groove"
  gasGenres(110) = "Satire"
  gasGenres(111) = "Slow Jam"
  gasGenres(112) = "Club"
  gasGenres(113) = "Tango"
  gasGenres(114) = "Samba"
  gasGenres(115) = "Folklore"
  gasGenres(116) = "Ballad"
  gasGenres(117) = "Power Ballad"
  gasGenres(118) = "Rhythmic Soul"
  gasGenres(119) = "Freestyle"
  gasGenres(120) = "Duet"
  gasGenres(121) = "Punk Rock"
  gasGenres(122) = "Drum Solo"
  gasGenres(123) = "Acapella"
  gasGenres(124) = "Euro-House"
  gasGenres(125) = "Dance Hall"
  Dim nLoop As Integer
  For nLoop = 126 To 255
    gasGenres(nLoop) = "Unknown"
  Next nLoop
End Sub
Public Function ExtractSongFilenameFromTreeNodeChildKey(sKey As String) As String
  ExtractSongFilenameFromTreeNodeChildKey = Right$(sKey, Len(sKey) - InStr(1, sKey, "|"))
End Function
Public Function ExtractPlaylistFilenameFromTreeNodeChildKey(sKey As String) As String
  ExtractPlaylistFilenameFromTreeNodeChildKey = Left$(sKey, InStr(1, sKey, "|") - 1)
End Function
Public Function IsTreeViewSong(sKey As String) As Boolean
  IsTreeViewSong = InStr(1, sKey, "|") > 0
End Function
Public Function IsTreeViewPlaylist(sKey As String) As Boolean
  IsTreeViewPlaylist = InStr(1, sKey, "|") = 0
End Function
