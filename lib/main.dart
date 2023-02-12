import 'dart:convert';

// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_application_3/qr_screen.dart';
// import 'package:flutter_application_3/second_screen.dart';
import 'package:http/http.dart' as http;
import 'package:netra/second_screen.dart';
import 'package:netra/students.dart';

import 'no_user.dart';

// import 'api_result.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      theme: ThemeData.light(),
      home: const MyHomePage(title: 'NETRA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  bool loading = false;
  String attendance = "";
  String details = "";
  String overatt = "", ans = "", today = "";
  List<dynamic> last = [];
  Future<void> getAttendance(String id) async {
    setState(() {
      loading = true;
    });
    final response = await http.post(
      Uri.parse('http://teleuniv.in/netra/api.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        // 'type': c,
        'method': '314',
        'rollno': id,
      }),
    );

    if (response.statusCode == 200) {
      var x = jsonDecode(response.body);
      // print(x);
      // ignore: prefer_interpolation_to_compose_strings
      Map<String, dynamic> data = x["attandance"]["dayobjects"][0]['sessions'];
      String todayAtt = "";
      for (var b in data.values) {
        // print(i,b)
        if (b == '2' || b == 2) {
          todayAtt += "2";
        } else if (b == '0' || b == 0) {
          todayAtt += "0";
        } else {
          todayAtt += "1";
        }
      }
      // print("today$today_att");
      // ignore: prefer_interpolation_to_compose_strings
      String overallAtt = "\nOverall Attendence %: " +
          x["overallattperformance"]["totalpercentage"] +
          "%\n";
      String subAtt = "\nSubject wise Attendence :\n";
      for (var sub in x["overallattperformance"]["overall"]) {
        subAtt += sub['subjectname'] + " : ";
        if (sub['percentage'] == "--") {
          subAtt += sub['practical'].toString();
          subAtt += '%\n';
        } else {
          subAtt += sub['percentage'].toString();
          subAtt += '%\n';
        }
      }
      // print(sub_att);
      setState(() {
        today = todayAtt;
        overatt = overallAtt;
        attendance = subAtt;
        last = x["attandance"]["dayobjects"];
      });
      // print('attendance:$overall_att');
    } else {
      // print('Request failed with status: ${response.body}.');
      throw Exception('Failed to fetch');
    }
  }

  Future<void> getDetails(String id) async {
    setState(() {
      loading = true;
    });
    final response = await http.post(
      Uri.parse('http://teleuniv.in/netra/api.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        // 'type': c,
        'method': '318',
        'rollno': id,
      }),
    );

    if (response.statusCode == 200) {
      var x = jsonDecode(response.body);
      setState(() {
        ans = x['name'].substring(0, x['name'].length - 4) +
            "\n  " +
            x['currentyear'] +
            "rd year   " +
            x['branch'] +
            '-' +
            x['section'];
      });
    } else {
      // print('Request failed with status: ${response.body}.');
      throw Exception('Failed to fetch');
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator.adaptive(),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(widget.title),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                )
              ],
            ),
            body: Center(
                child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height/4,
                    ),
                    const Text(
                      'Enter Roll No : ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    // (
                    SizedBox(
                      // color: Colors.black,
                      height: 100,
                      child: TextField(
                        controller: controller,
                        // keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "Roll No",
                            fillColor: Colors.white70),
                      ),
                    ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 80),
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: TextButton(
                          onPressed: () async {
                            String res = validateStudent(roll: controller.text)
                                .getNetraID() as String;
                            if (res == "Roll Number not found") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const No()));
                            } else {
                              await getDetails(res);
                              await getAttendance(res);
                              setState(() {
                                loading = false;
                              });

                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Second(
                                            name: ans,
                                            id: controller.text,
                                            attendance: attendance,
                                            today: today,
                                            total_attendance: overatt,
                                            last: last,
                                            // img: img,
                                          )));
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    )
                  ]),
            )));
  }
}
