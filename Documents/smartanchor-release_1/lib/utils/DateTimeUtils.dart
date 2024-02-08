import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../common/widgets.dart';

class DateTimeUtils extends GetxController {
  bool isSameDayCheck(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String formattedDateTimeNow() {
    //to show in attendance
    final now = DateTime.now();
    final formatter = DateFormat("MMM d, y HH:mm:ss");
    final formattedDate = formatter.format(now);
    return formattedDate;
    //gmt
  }

  int dateTimeToTimestamp(String datetime) {
    final dateTimeString = datetime;
    final originalFormat = DateFormat("MMM d, yyyy HH:mm:ss");
    final originalDateTime = originalFormat.parse(dateTimeString);

    // Convert to GMT by setting the time zone to UTC
    final gmtDateTime = originalDateTime.toUtc();

    // Get the timestamp in milliseconds
    return gmtDateTime.millisecondsSinceEpoch;
  }

  String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  String formatDateTimePreviousOrder(DateTime dateTime) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  String formatDateTimeNowYYYYMMDD() {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(DateTime.now());
  }

  String convertDateFormat(String inputDate) {
    //2023-10-31 00:00:00.000 => "05/10/2023"dd/mm/2023
    DateTime dateTime = DateTime.parse(inputDate);

    String outputDate =
        "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";

    return outputDate;
  }

  bool get isMorning {
    bool isMorning = true;
    final now = DateTime.now();
    isMorning = now.hour >= 0 && now.hour < 12;
    return isMorning;
  }

  String formatDate(String inputDate) {
    //May 22, 2023' date format from  2023-10-23 00:00:00.000
    try {
      DateTime dateTime = DateTime.parse(inputDate);
      String formattedDate = DateFormat("MMMM d, y").format(dateTime);
      return formattedDate;
    } catch (e) {
      return ""; // Return a message for invalid date strings
    }
  }

  bool isDateInPast(String dateString) {
    DateTime date =
        DateTime.parse(DateFormat('dd/MM/yyyy').parse(dateString).toString());
    DateTime currentDate = DateTime.now();
    return date.isBefore(currentDate);
  }

  ///--------validations
  bool isStartDateBeforeEndDate(String startDate, String endDate) {
    //22/10/2023
    if (startDate.isEmpty) {
      Widgets().showToast("Please insert start date !!");

      return false;
    }

    if (isDateInPast(startDate) || isDateInPast(endDate)) {
      Widgets().showToast("can not select past dates !!");

      return false;
    }
    final dateFormat = DateFormat("dd/MM/yyyy");

    try {
      final startDateTime = dateFormat.parse(startDate);
      final endDateTime = dateFormat.parse(endDate);

      if (startDateTime.isBefore(endDateTime)) {
        return true;
      } else {
        Widgets().showToast("Start date can not be greater than end date !!");
        return false;
      }
    } catch (e) {
      Widgets().showToast("Something went wrong !!");

      return false;
    }
  }

  String convertDateFormatN(String inputDate) {
    try {
      // Parse the input date string with the original format
      final inputFormat = DateFormat('dd/MM/yyyy');
      final date = inputFormat.parse(inputDate);

      // Define the desired output format
      final outputFormat = DateFormat('yyyy-MM-dd hh:mm:ssZ');

      // Format the date in the desired format
      final result = outputFormat.format(date);

      return result;
    } catch (e) {
      // Handle any parsing errors
      print('Error: $e');
      return 'Invalid Date';
    }
  }

  String convertDateFormatMonth(String inputDate) {
    try {
      // Parse the input date string with the original format
      final inputFormat = DateFormat('dd/MM/yyyy');
      final date = inputFormat.parse(inputDate);

      // Define the desired output format
      final outputFormat = DateFormat('dd MMMM yyyy');

      // Format the date in the desired format
      final result = outputFormat.format(date);

      return result;
    } catch (e) {
      // Handle any parsing errors
      print('Error: $e');
      return 'Invalid Date';
    }
  }

  String getStartOfMonth() {
    var now = DateTime.now();
    var firstDayOfMonth = DateTime(now.year, now.month, 1);
    return '${firstDayOfMonth.day}/${firstDayOfMonth.month}/${firstDayOfMonth.year}';
  }

  String getEndOfMonth() {
    var now = DateTime.now();
    var lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    return '${lastDayOfMonth.day}/${lastDayOfMonth.month}/${lastDayOfMonth.year}';
  }

  String getCurrentYear() {
    DateTime now = DateTime.now();
    return now.year.toString();
  }

  String getCurrentMonth() {
    DateTime now = DateTime.now();
    return now.month.toString();
  }

  String getStartDateOfMonth(String year, String month) {
    int yearInt = int.parse(year);
    int monthInt = int.parse(month);

    DateTime firstDayOfMonth = DateTime(yearInt, monthInt, 1);
    return "${firstDayOfMonth.day.toString().padLeft(2, '0')}/${monthInt.toString().padLeft(2, '0')}/$yearInt";
  }

  String getEndDateOfMonth(String year, String month) {
    int yearInt = int.parse(year);
    int monthInt = int.parse(month);

    DateTime lastDayOfMonth = DateTime(yearInt, monthInt + 1, 0);
    return "${lastDayOfMonth.day.toString().padLeft(2, '0')}/${monthInt.toString().padLeft(2, '0')}/$yearInt";
  }

  String getFirstDateOfMonthFormatted(int targetMonth) {
    if (targetMonth < 1 || targetMonth > 12) {
      throw ArgumentError(
          'Invalid month value. Month should be between 1 and 12.');
    }

    DateTime firstDate = DateTime(DateTime.now().year, targetMonth, 1);

    // Format the first date in "dd/MM/yyyy" format
    return DateFormat('dd/MM/yyyy').format(firstDate);
  }

  String getLastDateOfMonthFormatted(int targetMonth) {
    if (targetMonth < 1 || targetMonth > 12) {
      throw ArgumentError(
          'Invalid month value. Month should be between 1 and 12.');
    }

    DateTime lastDate = DateTime(DateTime.now().year, targetMonth + 1, 0);

    // Format the last date in "dd/MM/yyyy" format
    return DateFormat('dd/MM/yyyy').format(lastDate);
  }

  String convertDateFormatBar(String inputDate) {
    List<String> parts = inputDate.split('/');
    if (parts.length == 3) {
      String day = parts[0];
      String month = parts[1];
      String year = parts[2];

      DateTime dateTime =
          DateTime(int.parse(year), int.parse(month), int.parse(day));

      String outputDate = DateFormat('dd MMMM yyyy').format(dateTime);

      return outputDate;
    } else {
      return 'Invalid date format';
    }
  }

  convertStringDateIntoMonthAndYear(String inputDate) {
    List<String> parts = inputDate.split('/');
    if (parts.length == 3) {
      String day = parts[0];
      String month = parts[1];
      String year = parts[2];

      DateTime dateTime =
          DateTime(int.parse(year), int.parse(month), int.parse(day));

      String outputDate = DateFormat("MMMM y").format(dateTime);

      return outputDate;
    } else {
      return 'Invalid date format';
    }
  }

  convertStringDateIntoDateTime(String inputDate) {
    List<String> parts = inputDate.split('/');
    if (parts.length == 3) {
      String day = parts[0];
      String month = parts[1];
      String year = parts[2];

      DateTime dateTime =
          DateTime(int.parse(year), int.parse(month), int.parse(day));

      return dateTime;
    } else {
      return 'Invalid date format';
    }
  }

  String convertDateFormatMonthForBeat(String inputDate) {
    try {
      // Parse the input date string with the original format
      //2023-11-26 00:00:00.000
      //2023-12-01T09:52:07Z
      final inputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
      final date = inputFormat.parse(inputDate);

      // Define the desired output format
      final outputFormat = DateFormat('dd MMMM yyyy');

      // Format the date in the desired format
      final result = outputFormat.format(date);

      return result;
    } catch (e) {
      // Handle any parsing errors
      print('Error: $e');
      return 'Invalid Date';
    }
  }

  String formatDatePreviousOder(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);

    // Format the date using intl package
    String formattedDate = DateFormat('dd-MMM-yyyy').format(dateTime.toLocal());

    return formattedDate;
  }
}
