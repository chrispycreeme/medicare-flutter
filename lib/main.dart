import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'data_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF007BFF),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 60,
                    left: 30.0,
                    right: 30.0,
                    bottom: 16.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Image.asset(
                            'assets/logo/MedicareLogo.png',
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Medicare',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'Inter',
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Monitor your loved ones.',
                                      style: TextStyle(
                                        fontSize: 35,
                                        color: Colors.white,
                                        fontFamily: 'Inter',
                                      ),
                                      softWrap: true,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35.0),
                          child: Text(
                            'An ESP-32 Powered Smart Health Monitoring System',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _controller,
                                      decoration: InputDecoration(
                                        labelText: 'Log In',
                                        labelStyle: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF313131),
                                          fontFamily: 'Inter',
                                          height: 0.3,
                                        ),
                                        hintText: 'Enter your Medicare ID',
                                        hintStyle: TextStyle(
                                          fontFamily: 'Inter',
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        filled: true,
                                        fillColor: Color(0xFFD9D9D9),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            60,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 7.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            60,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 7.0,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            60,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 7.0,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 25,
                                          horizontal: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xFFFFFFFF),
                                            width: 10.0,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 65,
                                        height: 65,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xFFD9D9D9),
                                            width: 20.0,
                                          ),
                                        ),
                                      ),
                                      Builder(
                                        builder: (context) {
                                          return ElevatedButton(
                                            onPressed: () async {
                                              final key = _controller.text;
                                              final response = await http.get(
                                                Uri.parse(
                                                    'https://composed-apparent-arachnid.ngrok-free.app/health_monitoring.php?key=$key'),
                                              );

                                              if (response.statusCode == 200) {
                                                final data = jsonDecode(response.body);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DataPage(dataKey: key),
                                                  ),
                                                );
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: Text('Error'),
                                                    content: Text('Invalid Medicare ID'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text('OK'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(0xFF007BFF),
                                              shape: CircleBorder(),
                                              padding: EdgeInsets.all(
                                                15,
                                              ), // Adjust the padding as needed
                                            ),
                                            child: Icon(
                                              Icons.arrow_outward,
                                              color: Colors.white,
                                              size: 27,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 180,
                      backgroundColor: Color(0xFF006DDA),
                    ),
                    Transform.rotate(
                      angle: 0.2,
                      child: Image.asset(
                        'assets/images/medicare-model.png',
                        width: 480,
                        height: 480,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final TextEditingController _controller = TextEditingController();