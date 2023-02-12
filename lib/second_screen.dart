// import 'dart:async';

// ignore_for_file: unused_import, must_be_immutable, non_constant_identifier_names, use_key_in_widget_constructors, no_logic_in_create_state, empty_statements, unused_local_variable

import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:netra/last_week.dart';
import 'package:netra/qr_screen.dart';
// import 'package:flutter_application_3/qr_screen.dart';

class Second extends StatefulWidget {
  String id, attendance, today, total_attendance;
  String name;
  List<dynamic> last;
  Second({
    required this.id,
    required this.attendance,
    required this.today,
    required this.total_attendance,
    required this.name,
    required this.last,
  });

  @override
  State<Second> createState() =>
      _SecondState(id, attendance, today, total_attendance, name, last);
}

class _SecondState extends State<Second> {
  String id;
  String name;
  String attendance;
  String today;
  String total_attendance;
  List<dynamic> last;
  _SecondState(this.id, this.attendance, this.today, this.total_attendance,
      this.name, this.last);

  @override
  Widget build(BuildContext context) {
    String day = "", att = "";
    var li = ['🔴 ', '🟢 ', '⚪ '];
    for (int i = 1; i < last.length; i++) {
      if (last[i]['holiday'] == 'true') continue;
      day += last[i]['date'] + "\n\n";
      att += li[int.parse(last[i]['sessions']['session1'])];
      att += li[int.parse(last[i]['sessions']['session2'])];
      att += li[int.parse(last[i]['sessions']['session3'])];
      att += li[int.parse(last[i]['sessions']['session4'])];
      att += li[int.parse(last[i]['sessions']['session5'])];
      att += li[int.parse(last[i]['sessions']['session6'])];
      att += li[int.parse(last[i]['sessions']['session7'])];
      att += '\n\n';
    }
    // print(l);
    String x = "";
    for (int i = 0; i < today.length; i++) {
      if (today[i] == '1') {
        x += '🟢 ';
      } else if (today[i] == '0') {
        x += '🔴 ';
      } else {
        x += '⚪ ';
      }
    }
    ;
    int val = 0;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.qr_code,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QR(
                            img: id,
                          )));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              CircleAvatar(
                radius: 75,
                child: ClipOval(
                  child: Image.network(
                      'http://teleuniv.in/sanjaya/student-images/${id.toUpperCase()}.jpg'),
                ),
              ),
              // Image.network(
              //     'http://teleuniv.in/sanjaya/student-images/${id.toUpperCase()}.jpg'),
              SizedBox(
                height: MediaQuery.of(context).size.height / 40,
              ),
              Text(
                name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                total_attendance,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                attendance,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              const Text(
                'Today\'s attendance : ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                x,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> LastWeek(showday: day,showatt: att,img: id,)));
                },
                child: const Text(
                  "Last Two week's attendance",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
