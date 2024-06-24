import 'package:flutter/material.dart';

class MyHistoryList extends StatelessWidget {
  final IconData icon;
  final String title;
  final String location;
  final String time;
  const MyHistoryList(
      {super.key,
      required this.icon,
      required this.title,
      required this.location,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
      ),
      subtitle: Text(
        location,
        style: TextStyle(
          color: Colors.black,
          fontSize: 10,
        ),
      ),
      trailing: Text(
        time,
        style: TextStyle(
          color: Colors.black,
          fontSize: 10,
        ),
      ),
    );

    // Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Row(
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Icon(Icons.motorcycle_sharp),
    //       ),
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(title, style: TextStyle(color: Colors.black, fontSize: 10)),
    //           Text(location,
    //               style: TextStyle(color: Colors.black, fontSize: 10)),
    //           Text(time, style: TextStyle(color: Colors.black, fontSize: 10)),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
