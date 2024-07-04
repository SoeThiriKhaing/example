import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.teal,
        body: SafeArea(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage("assets/images/fg.jpg"),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                "Soe Thiri",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Pacifico",
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              const Text(
                "Flutter Developer",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Padauk",
                  letterSpacing: 3,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 25.0),
                color: Colors.white,
                child: const Row(
                  children: <Widget>[
                    Icon(
                      Icons.phone,
                      color: Color.fromARGB(255, 8, 87, 79),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text("09-123456789")
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 25.0),
                color: Colors.white,
                child: const Row(
                  children: [
                    Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 8, 87, 79),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text("soethiri123@gmail.com")
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
