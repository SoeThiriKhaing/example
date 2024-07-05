import 'package:flutter/material.dart';
import 'package:soe/sharepreference.dart';

class EmployerHome extends StatefulWidget {
  const EmployerHome({super.key});

  @override
  State<EmployerHome> createState() => _EmployerHomeState();
}

class _EmployerHomeState extends State<EmployerHome> {
  String? userRole;
  @override
  void initState() {
    super.initState();
    retreveUserRole();
  }

  void retreveUserRole() async {
    var role = await SharePreferenceData().getRole();
    setState(() {
      this.userRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: userRole == "Employer"
            ? Text("Employer Screen")
            : Text("Job Seeker"),
      ),
      body: Column(
        children: [
          userRole == "Employer"
              ? Column(
                  children: [
                    Center(
                      child: Text('Employeer TExt Field for Employeer'),
                    ),
                    Text("ajgjwa;ggkeskg"),
                    Text("ajgjwa;jsfjfiesjsj"),
                  ],
                )
              : Text("Another DAta Field")
        ],
      ),
    );
  }
}
