import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

// DateTime selectedDate = DateTime.now();
DateTime date;

class _CalendarState extends State<Calendar> {
  //
  String getText() {
    if (date == null) {
      return 'Birth Day';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Text(
        //   "${selectedDate.toLocal()}".split(' ')[0],
        //   style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
        // ),
        // SizedBox(
        //   height: 20.0,
        // ),
        // RaisedButton(
        //   onPressed: () => _selectDate(context), // Refer step 3

        //   color: Colors.greenAccent,
        // ),
        GestureDetector(
            onTap: () => pickDate(context), child: Icon(Icons.calendar_today))
      ],
    );
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (newDate == null) return;
    setState(() => date = newDate);
  }
}
