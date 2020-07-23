import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:login_example/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class PlanningPage extends StatefulWidget {
  static const routeName = '/interventionplanning';
  @override
  _PlanningPageState createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  DateTime _currentDate2 = DateTime.now();
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.calendar_today,
      color: Colors.amber,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>();

  CalendarCarousel _calendarCarouselNoHeader;

  bool _isLoading = false;
  var data;
  List<DateTime> dates;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isLoading = true;
      });
      fetchPlanningDates();
    });
    super.initState();
  }

  void fetchPlanningDates() async {
    data = await Provider.of<AuthProvider>(context, listen: false)
        .fetchAllInterventions();
    dates = [];
    setState(() {
      _isLoading = false;
    });
    data.asMap().forEach((index, inter) {
      dates.add(DateTime.parse(inter.dateIntervention));
    });

    dates.asMap().forEach((index, date) {
      _markedDateMap.add(
          date,
          Event(
            date: date,
            title: 'My PLanning',
            icon: _eventIcon,
          ));
    });

    print(dates);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.white,
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _currentDate2 = date);
        events.forEach((event) => print(event.title));
      },
      daysHaveCircularBorder: true,
      weekendTextStyle: TextStyle(
        color: Colors.grey.shade900,
      ),
      thisMonthDayBorderColor: Colors.white,
      headerTitleTouchable: true,
      markedDateShowIcon: true,
      markedDateIconBuilder: (event) {
        return event.icon;
      },
      iconColor: Colors.blueGrey,
      selectedDayButtonColor: Colors.pinkAccent.shade100,
      staticSixWeekFormat: true,
//      firstDayOfWeek: 4,
      markedDatesMap: _markedDateMap,

      selectedDateTime: _currentDate2,
      customGridViewPhysics: AlwaysScrollableScrollPhysics(),
      prevDaysTextStyle: TextStyle(color: Colors.blueGrey),
      nextDaysTextStyle: TextStyle(color: Colors.blueGrey),
      headerTextStyle: TextStyle(
          color: Colors.blueGrey, fontSize: 20.0, fontWeight: FontWeight.bold),
      markedDateCustomShapeBorder:
          CircleBorder(side: BorderSide(color: Colors.yellow)),
      showHeaderButton: true,
      todayButtonColor: Colors.grey,
      daysTextStyle: TextStyle(color: Colors.grey.shade900),
      weekdayTextStyle: TextStyle(
          color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 15.0),
      onCalendarChanged: (DateTime date) {},
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('Planning'),
        ),
        body: _isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Wrap(
                  children: <Widget>[
                    Container(
                      height: screenSize.height / 1.7,
                      child: Theme(
                          data: ThemeData(
                            primaryColor: Colors.blueGrey,
                            primarySwatch: Colors.blueGrey,
                          ),
                          child: _calendarCarouselNoHeader),
                    ), //
                  ],
                ),
              ));
  }
}
