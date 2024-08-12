import 'dart:developer';

import 'package:flutter/material.dart';

class date_converter{
  static String dateconvert({required BuildContext context,required String time}){
    final date=DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMsgTime({required BuildContext context,required String time , bool showYear = false}){
    final DateTime sent=DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    log("time _------ $sent");
    final DateTime now=DateTime.now();

    if (now.day==sent.day && now.month==sent.month && now.year==sent.year) {
    return TimeOfDay.fromDateTime(sent).format(context);
      
    }
    return showYear? "${sent.day} ${_getMonth(sent)}  ${sent.year}": "${sent.day} ${_getMonth(sent)}";
  }
  static String joinAt({required BuildContext context,required String time , bool showYear = false}){
    final DateTime sent=DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
    log("time _------ $sent");
    final DateTime now=DateTime.now();

    if (now.day==sent.day && now.month==sent.month && now.year==sent.year) {
    return TimeOfDay.fromDateTime(sent).format(context);
      
    }
    return showYear? "${sent.day} ${_getMonth(sent)}  ${sent.year}": "${sent.day} ${_getMonth(sent)}";
  }
  static String _getMonth (DateTime date){
    switch(date.month){
      case 1:
        return "jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sept";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
    }
    return "NA";
  }

 static String getLastActiveTime({required BuildContext context,required String last_active_time}){
    final int i =int.parse(last_active_time)??-1;
    if (i==-1) return "last active time not available";
    DateTime time =DateTime.fromMillisecondsSinceEpoch(i) ;
    DateTime now=DateTime.now();
    String formated_time= TimeOfDay.fromDateTime(time).format(context); 
     if (now.day==time.day && now.month==time.month && now.year==time.year) {
    return "Last seen today at $formated_time";      
    }
    if ((now.difference(time).inHours/24).round()==1) {
      return "Last seen yesterday at $formated_time" ;
    } 
    String month= _getMonth(time);
    return "Last seen on ${time.day} $month on ${formated_time}" ;
  }

}