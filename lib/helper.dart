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