import 'dart:ui';

import 'package:Cliamizer/res/assets_manager.dart';
import 'package:Cliamizer/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper{

  static bool checkEmergencyNumbersDate(String startTimeStr, String endTimeStr) {
    print('hereeeeeeeeeeeee' + startTimeStr);
    print('hereeeeeeeeeeeee' + DateTime.now().toString());
    DateFormat dateFormat = DateFormat('HH:mm:ss', 'en_US');
    DateTime now = DateTime.now();
    try {
      DateTime startTime = dateFormat.parse(startTimeStr);
      DateTime endTime = dateFormat.parse(endTimeStr);
      print('Parsed Start Time: $startTime');
      print('Parsed End Time: $endTime');
      DateTime startDateTime = DateTime(
          now.year, now.month, now.day, startTime.hour, startTime.minute);
      DateTime endDateTime = DateTime(
          now.year, now.month, now.day, endTime.hour, endTime.minute);
      bool startIsAM = startTime.hour >= 12; // Before 12 PM
      bool endIsPM = endTime.hour < 12;
      /*if (endDateTime.isBefore(startDateTime)) {
        print('yes before');
        startDateTime = startDateTime.subtract(Duration(days: 1));
      }*/
      if(startIsAM && endIsPM){
        endDateTime = endDateTime.add(Duration(days: 1));
      }
      print('Start DateTime: $startDateTime');
      print('End DateTime: $endDateTime');
      print(now.isAfter(startDateTime));
      print(now.isBefore(endDateTime));
      if (now.isAfter(startDateTime) && now.isBefore(endDateTime)) {
        print('true');
        return true;
      }
      print('false');
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
  static String removeSeconds(String dateTimeString) {
    DateTime parsedDateTime = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat('yyyy-MM-dd h:mm').format(parsedDateTime);
    return formattedDate;
  }

  static Color getLogColor(String status){
    switch (status){
      case 'New':
        return Colors.yellow;
      case 'Assigned':
        return Colors.blue;
      case 'Started':
        return Colors.cyan;
      case 'Completed':
        return Colors.green;
      case 'Closed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      case 'جديد':
        return Colors.yellow;
      case 'تم اختيار فني':
        return Colors.blue;
      case 'بدأت':
        return Colors.cyan;
      case 'مكتمل':
        return Colors.green;
      case 'مغلق':
        return Colors.green;
      case 'ملغي':
        return Colors.red;
      default:
        return MColors.primary_color;
    }
  }
  static String getLogImage(String status){
    switch (status){
      case 'New':
        return AssetsManager.newClaims;
      case 'Assigned':
        return AssetsManager.assignedClaims;
      case 'Started':
        return AssetsManager.startedClaims;
      case 'Completed':
        return AssetsManager.completedClaims;
      case 'Closed':
        return AssetsManager.closedClaims;
      case 'Cancelled':
        return AssetsManager.canceledClaims;
      case 'جديد':
        return AssetsManager.newClaims;
      case 'تم اختيار فني':
        return AssetsManager.assignedClaims;
      case 'بدأت':
        return AssetsManager.startedClaims;
      case 'مكتمل':
        return AssetsManager.completedClaims;
      case 'مغلق':
        return AssetsManager.closedClaims;
      case 'ملغي':
        return AssetsManager.canceledClaims;
      default:
        return '';
    }
  }
  static String extractDate(String dateTime) {
    if(dateTime == ''){
      return '-';
    }
    return dateTime.split(' ')[0];
  }

  static String extractTime(String dateTime) {
    if(dateTime == ''){
      return '-';
    }
    String time = dateTime.split(' ')[1];
    return time.substring(0, 5);
  }

  static String calculateDuration(String startOn, String endOn) {
    if(startOn == '' || endOn == ''){
      return '${0}D ${0}H ${0}M';
    }
    DateTime start = DateTime.parse(startOn);
    DateTime end = DateTime.parse(endOn);

    Duration duration = end.difference(start);

    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;

    // Formatting the result
    String result = '${days}D ${hours}H ${minutes}M';
    return result;
  }
}

extension DateTimeExtension on DateTime {
  bool isAfterOrEqual(DateTime other) {
    return isAtSameMomentAs(other) || isAfter(other);
  }

  bool isBeforeOrEqual(DateTime other) {
    return isAtSameMomentAs(other) || isBefore(other);
  }

  bool isBetween({required DateTime from, required DateTime to}) {
    return isAfterOrEqual(from) && isBeforeOrEqual(to);
  }

  bool isBetweenExclusive({required DateTime from, required DateTime to}) {
    return isAfter(from) && isBefore(to);
  }
}