import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FocusDateAvatar extends StatelessWidget {
  const FocusDateAvatar({
    super.key,
    required DateTime focusedDay,
  }) : _focusedDay = focusedDay;

  final DateTime _focusedDay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          DateFormat('E').format(_focusedDay),
          style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text(
              '${_focusedDay.day}',
              style: const TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        )
      ],
    );
  }
}