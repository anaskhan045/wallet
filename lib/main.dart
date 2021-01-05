import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallet',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  DateTime _selectedDay;
  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();

    _events = {
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
    };

    _selectedEvents = _events[_selectedDay] ?? [];
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

  void _onDaySelected(DateTime day, List events, List holidays) {
    print(events);

    setState(() {
      _selectedDay = day;
      if (_events[_selectedDay] == null) {
        _events[_selectedDay] = [];
      }
      _selectedEvents = events;
    });
    print(_selectedDay);
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
      backgroundColor: Color(0xffdddeef),
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        tooltip: 'Add new Expense',
        elevation: 10.0,
        backgroundColor: Colors.purpleAccent,
        child: Icon(
          Icons.add,
          size: 40.0,
        ),
        onPressed: () {
          setState(() {
            _events[_selectedDay].add('anas');

            _selectedEvents = _events[_selectedDay];
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              margin: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  _buildTableCalendar(),
                  Container(
                    width: 300.0,
                    height: 150.0,
                    child: Center(
                      child: Text(
                          '${_selectedDay.day} ${_selectedDay.month} ${_selectedDay.year} '),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: Container(child: _buildEventList())),
          ],
        ),
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      initialCalendarFormat: CalendarFormat.week,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.purpleAccent,
        todayColor: Colors.purpleAccent[100],
        outsideDaysVisible: false,
        markersMaxAmount: 0,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.purpleAccent,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  TextEditingController listController;

  Widget _buildEventList() {
    return WillPopScope(
      child: ListView.builder(
        itemCount: _selectedEvents.length,
        itemBuilder: (context, index) {
          print(index);
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              title: Text(_selectedEvents[index].toString()),
            ),
          );
        },

        // children: _selectedEvents.map((event) {
        //   listController = TextEditingController(text: event.toString());
        //   return Container(
        //     decoration: BoxDecoration(
        //       border: Border.all(width: 0.8),
        //       borderRadius: BorderRadius.circular(12.0),
        //     ),
        //     margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        //     child: TextFormField(
        //       onChanged: (newText) {
        //         event = newText;
        //       },
        //       controller: listController,
        //       decoration: InputDecoration(
        //         contentPadding: EdgeInsets.only(left: 10.0),
        //       ),
        //     ),
        //   );
        // }).toList(),
      ),
    );
  }
}
