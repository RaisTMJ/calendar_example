import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

var ExampleEvents = [
  {
    "eventName": "Bathroom Modification",
    "dateStart": "2020-10-08T00:00:01.001Z",
    "dateEnd": "2020-10-10T11:00:00.151Z",
  },
  {
    "eventName": "Enola Piano Class",
    "dateStart": "2020-10-08T01:30:22.151Z",
    "dateEnd": "2020-10-08T11:00:00.151Z",
  },
  {
    "eventName": "Hr Bypass heart operation",
    "dateStart": "2020-10-09T01:30:22.151Z",
    "dateEnd": "2020-10-12T11:00:00.151Z",
  },
  {
    "eventName": "Hr Bypass heart operation",
    "dateStart": "2020-10-13T01:30:22.151Z",
    "dateEnd": "2020-10-24T11:00:00.151Z",
  }
];

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Table Calendar With Event'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(
    DateTime day,
  ) {
    print('CALLBACK: _onDaySelected');
    setState(() {});
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTableCalendarWithBuilders(),
          const SizedBox(height: 8.0),
          _buildButtons(),
          const SizedBox(height: 8.0),
          // Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    final Size size = MediaQuery.of(context).size;
    double dateBoxSize = (size.width - 16) / 7;
    double rowHeight = (size.height - 250) / 5;

    Map<DateTime, List> _events;
    final _selectedDay = DateTime.now();

    _events = {
      _selectedDay.subtract(Duration(days: -1)): [
        {'width': 3.0, 'position': 2.0, 'task': 'harro what are'},
        {'width': 4.0, 'position': 1.0, 'task': 'This is My second Irem'},
      ],

      _selectedDay.subtract(Duration(days: 5)): [
        {'width': 3.0, 'position': 2.0, 'task': 'Third a'},
        {'width': 4.0, 'position': 1.0, 'task': 'third b'},
      ],
    };

    return TableCalendar(
      locale: 'en-us',
      events: _events,
      rowHeight: rowHeight,
      calendarController: _calendarController,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.yellow[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        dayBuilder: (context, date, _) {
          return Container(
            width: dateBoxSize,
            height: rowHeight,
            decoration: BoxDecoration(
                border: Border.all(width: .2), color: Colors.white),
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[
            Stack(
              overflow: Overflow.visible,
              children: [
                for (var event in events)
                  Positioned(
                    right: 0,
                    bottom: 3 + (event["position"] * 30) - 30,
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _calendarController
                                .setCalendarFormat(CalendarFormat.twoWeeks);
                          });
                        },
                        behavior: HitTestBehavior.deferToChild,
                        child: Container(
                          margin: EdgeInsets.only(top: 3, bottom: 3, right: 2),
                          color: Colors.white,
                          child: Container(
                            width: dateBoxSize * event['width'] -
                                ((event['width'] > 1) ? 10 : 2.5),
                            height: 25,
                            alignment: Alignment.centerLeft,
                            padding: ((event['width'] > 1)
                                ? EdgeInsets.only(left: 10)
                                : EdgeInsets.only(left: 5)),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .secondaryHeaderColor
                                  .withOpacity(.2),
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                            ),
                            // change to double
                            child: Text(
                              event["task"],
                              style: Theme.of(context).textTheme.headline5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )),
                  ),
              ],
            )
          ];
          return children;
        },
      ),
      onDaySelected: (date, holidays) {
        _onDaySelected(
          date,
        );
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildButtons() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Month'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.month);
                });
              },
            ),
            RaisedButton(
              child: Text('2 weeks'),
              onPressed: () {
                setState(() {
                  _calendarController
                      .setCalendarFormat(CalendarFormat.twoWeeks);
                });
              },
            ),
            RaisedButton(
              child: Text('Week'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }

// Widget _buildEventList() {
//   return ListView(
//     children: _selectedEvents
//         .map((event) => Container(
//               decoration: BoxDecoration(
//                 border: Border.all(width: 0.8),
//                 borderRadius: BorderRadius.circular(12.0),
//               ),
//               margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//               child: ListTile(
//                 title: Text(event.toString()),
//                 onTap: () => print('$event tapped!'),
//               ),
//             ))
//         .toList(),
//   );
// }
}
