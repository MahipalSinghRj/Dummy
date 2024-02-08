import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../common/AppBar.dart';

class EventCalendar extends StatefulWidget {
  final String title;

  const EventCalendar({Key? key, required this.title}) : super(key: key);

  @override
  State<EventCalendar> createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  List<String> itemValue = ["Daily", "Monthly", "Yearly"];
  String? selectedBu;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  /* Widget build(BuildContext context) {
    final events = sampleEvents();
    final cellCalendarPageController = CellCalendarPageController();
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MainAppBar(context, scaffoldKey),
        body: CellCalendar(
          cellCalendarPageController: cellCalendarPageController,
          events: events,
          daysOfTheWeekBuilder: (dayIndex) {
            final labels = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];

            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                labels[dayIndex],
                style: TextStyle(fontWeight: FontWeight.bold, color: dayIndex == 0 ? goldDropColor : codGray),
                textAlign: TextAlign.center,
              ),
            );
          },
          monthYearLabelBuilder: (datetime) {
            final year = datetime!.year.toString();
            final month = datetime.month.monthName;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                height: 7.h,
                width: 100.w,
                color: pattensBlue,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Widgets().textWidgetWithW700(titleText: "$month  $year", fontSize: 13.sp),
                      InkWell(
                          onTap: () {
                            //Get.back();
                          },
                          child: const Icon(Icons.arrow_back_ios_rounded)),
                      InkWell(
                          onTap: () {
                            //Get.back();
                          },
                          child: const Icon(Icons.arrow_forward_ios_rounded)),
                      Widgets().dayMonthYearlyStatusDropdown(
                          hintText: "Selected",
                          width: 30.w,
                          onChanged: (value) {
                            setState(() {
                              selectedBu = value;
                              if (selectedBu == "Daily") {
                                syncDailyFusionCalendar();
                              } else if (selectedBu == "Monthly") {
                                syncWeeklyFusionCalendar();
                              } else if (selectedBu == "Yearly") {
                                syncMonthlyFusionCalendar();
                              }
                            });
                          },
                          itemValue: itemValue,
                          selectedValue: selectedBu)
                    ],
                  ),
                ),
              ),
            );
          },
          onCellTapped: (date) {
            final eventsOnTheDate = events.where((event) {
              final eventDate = event.eventDate;
              return eventDate.year == date.year && eventDate.month == date.month && eventDate.day == date.day;
            }).toList();
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: Text("${date.month.monthName} ${date.day}"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: eventsOnTheDate
                            .map(
                              (event) => Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(4),
                                margin: const EdgeInsets.only(bottom: 12),
                                color: event.eventBackgroundColor,
                                child: Text(
                                  event.eventName,
                                  style: event.eventTextStyle,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ));
          },
          onPageChanged: (firstDate, lastDate) {
            /// Called when the page was changed
            /// Fetch additional events by using the range between [firstDate] and [lastDate] if you want
          },
        ),
      ),
    );
  }*/
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MainAppBar(context, scaffoldKey),
        body: syncMonthlyFusionCalendar(),
      ),
    );
  }

/*  Widget syncMonthlyFusionCalendar() {
    return SizedBox(
      height: 50.h,
      child: SfCalendar(
        view: CalendarView.month,
        onTap: (calendarTapDetails) {
          printMe("Tapped date : ${calendarTapDetails.date} ");
        },
      ),
    );
  }*/

  Widget syncMonthlyFusionCalendar() {
    return SfCalendar(
      view: CalendarView.month,
      monthCellBuilder: (BuildContext context, MonthCellDetails details) {
        if (details.date.day == 15) {
          // Customize the appearance for a specific date, e.g., 15th of the month
          return const Column(
            children: [
              Text('15th', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Text 1'),
              Text('Text 2'),
            ],
          );
        } else {
          // Default appearance for other dates
          return Container(
            alignment: Alignment.center,
            child: Text(details.date.day.toString()),
          );
        }
      },
    );
  }

  Widget syncWeeklyFusionCalendar() {
    return SfCalendar(
      view: CalendarView.week,
      initialDisplayDate: DateTime.now(),
      headerStyle: const CalendarHeaderStyle(
        textAlign: TextAlign.center,
        textStyle: TextStyle(fontSize: 20),
      ),
      todayHighlightColor: Colors.blue,
    );
  }

  Widget syncDailyFusionCalendar() {
    return SfCalendar(
      view: CalendarView.day,
      initialDisplayDate: DateTime.now(),
      headerStyle: const CalendarHeaderStyle(
        textAlign: TextAlign.center,
        textStyle: TextStyle(fontSize: 20),
      ),
      todayHighlightColor: Colors.blue,
    );
  }
}
