Attribute VB_Name = "basctScheduleHelpers"
Option Explicit
Public Function DaysSince1900(dt As Date) As Long
  DaysSince1900 = DateDiff("d", "January 1, 1900", dt)
End Function
Public Function MinutesSinceMidNight(dt As Date) As Long
  MinutesSinceMidNight = DateDiff("n", "12:00:00 AM", dt)
End Function
Public Function TimeFromMinutesSinceMidnight(lMinutes As Long) As Date
  TimeFromMinutesSinceMidnight = DateAdd("n", lMinutes, "12:00:00 AM")
End Function

