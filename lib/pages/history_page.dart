import 'package:flutter/material.dart';
import 'package:ride_share/components/my_history_list.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<List<Map<String, String>>> fetchHistoryData() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      {
        'title': 'Cirebon Mall',
        'location': 'Darma, Kuningan Regency, West Java',
        'time': '3.00 pm'
      },
      {
        'title': 'Haven',
        'location':
            'Komp. Chelsea Blue Ruko 9 - 10, Jl. DR. Cipto Mangunkusumo',
        'time': '4.30 pm'
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Expanded(
                  child: Align(
                      alignment: FractionalOffset.bottomLeft,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_back_ios),
                      )),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Timeline',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: 0.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 15,
                  )),
              Row(
                children: [
                  Text('Sat, Apr 6, 2024',
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: 15,
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 20, maxWidth: 20),
                  )
                ],
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  )),
            ],
          ),
          Divider(thickness: 0.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.motorcycle_sharp,
                    ),
                  ),
                  Column(
                    children: [
                      Text('1.2 km',
                          style: TextStyle(color: Colors.black, fontSize: 10)),
                      Text('8 min',
                          style: TextStyle(color: Colors.black, fontSize: 10)),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 50),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.location_on),
                  ),
                  Text('2 visits',
                      style: TextStyle(color: Colors.black, fontSize: 10)),
                ],
              ),
            ],
          ),
          Divider(thickness: 0.5),

          // list
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: FutureBuilder<List<Map<String, String>>>(
              future: fetchHistoryData(),
              builder: (context, snapshot) {
                // While the data is loading, show a loading indicator
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                // If an error occurred, show an error message
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // Once the data is loaded, build the list of MyHistoryList widgets
                if (snapshot.hasData) {
                  final historyList = snapshot.data!;
                  return Column(
                    children: historyList.map((historyItem) {
                      return MyHistoryList(
                        icon: Icons.motorcycle_sharp,
                        title: historyItem['title']!,
                        location: historyItem['location']!,
                        time: historyItem['time']!,
                      );
                    }).toList(),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
