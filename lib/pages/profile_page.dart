import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 25,
              right: 25,
              top: 40,
            ),
            margin: EdgeInsets.only(bottom: 30),
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Expanded(
                  child: Align(
                      alignment: FractionalOffset.bottomLeft,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                          size: 24,
                        ),
                      )),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Akun',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 75,
            backgroundImage: NetworkImage(
              'https://plus.unsplash.com/premium_photo-1708275670170-f92d0c82a1d3?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              scale: 1.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Zainudin",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 75,
                  width: 167,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Rating",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star_rate_rounded,
                              color: Colors.amber,
                              size: 25,
                            ),
                            Text(
                              "5.0",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 75,
                  width: 167,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Jumlah",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "14",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(360),
                      ),
                      child: Icon(
                        Icons.notifications,
                        color: Theme.of(context).colorScheme.primary,
                        size: 34,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: 15,
                      ),
                      width: MediaQuery.of(context).size.width * 0.55,
                      height: 56,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Notification",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            height: 1,
                            thickness: 0.5,
                            color: Colors.grey[500],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(360),
                      ),
                      child: Icon(
                        Icons.settings,
                        color: Theme.of(context).colorScheme.primary,
                        size: 34,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: 15,
                      ),
                      width: MediaQuery.of(context).size.width * 0.55,
                      height: 56,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Settings",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            height: 1,
                            thickness: 0.5,
                            color: Colors.grey[500],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(360),
                      ),
                      child: Icon(
                        Icons.place_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 34,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: 15,
                      ),
                      width: MediaQuery.of(context).size.width * 0.55,
                      height: 56,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Saved Places",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            height: 1,
                            thickness: 0.5,
                            color: Colors.grey[500],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
