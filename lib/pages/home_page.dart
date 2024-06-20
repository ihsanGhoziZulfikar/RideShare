import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 25),
        child: Column(
          children: [
            Container(
              height: 65,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, Zainudin',
                        style: TextStyle(
                          fontSize: 19,
                          fontFamily: 'Kanit',
                        ),
                      ),
                      Text(
                        'Kamu ingin pergi ke mana?',
                        style: TextStyle(
                          fontSize: 19,
                          fontFamily: 'Kantumruy',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(
                        'https://plus.unsplash.com/premium_photo-1708275670170-f92d0c82a1d3?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        scale: 1.0),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 32,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Temukan destinasimu di sini',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
