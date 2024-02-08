import 'package:flutter/cupertino.dart';
import '../constants/colorConst.dart';

class CustomerCalendarDesign extends StatelessWidget {
  final DateTime date;

  const CustomerCalendarDesign({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.white,
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
              color: pattensBlue,
              width: 1.0,
            ),
            right: BorderSide(
              color: pattensBlue,
              width: 1.0,
            ),
            bottom: BorderSide(
              color: pattensBlue,
              width: 1.0,
            )),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${date.day}', style: const TextStyle(fontWeight: FontWeight.bold)),
          //const SizedBox(height: 5),
          const Text('Text 1'),
          const Text('Text 2'),
        ],
      ),
    );
  }
}
