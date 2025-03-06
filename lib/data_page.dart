import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataPage extends StatefulWidget {
  final String dataKey;

  const DataPage({super.key, required this.dataKey});

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late Stream<List<dynamic>> _dataStream;
  String assignedProfessional = 'Loading...';

  @override
  void initState() {
    super.initState();
    _dataStream = _fetchDataPeriodically();
  }

  Stream<List<dynamic>> _fetchDataPeriodically() async* {
    while (true) {
      final response = await http.get(
        Uri.parse(
          'https://composed-apparent-arachnid.ngrok-free.app/health_monitoring.php?key=${widget.dataKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        data.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
        if (data.isNotEmpty) {
          setState(() {
            assignedProfessional = data.first['assigned_professional'];
          });
        }
        yield data;
      } else {
        setState(() {
          assignedProfessional = 'Error fetching caregiving info';
        });
        yield [];
      }

      await Future.delayed(Duration(seconds: 10));
    }
  }

  num _parseValue(dynamic value) {
    if (value is String) {
      return num.tryParse(value) ?? 0;
    } else if (value is num) {
      return value;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<dynamic>>(
        stream: _dataStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Server error. Please check your internet connection.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            final latestData = snapshot.data!.first;
            final titles = [
              'Heart Rate (BPM)',
              'Oxygen Saturation',
              'Body Temperature',
            ];
            final keys = [
              'heartRate_bpm',
              'oxygenSat_per',
              'bodyTemp_c',
            ];
            final units = [
              ' bpm',
              '%',
              '°C',
            ];
            final icons = [Icons.favorite, Icons.opacity, Icons.thermostat];
            final values = [
              '${latestData['heartRate_bpm']} bpm',
              '${latestData['oxygenSat_per']}%',
              '${latestData['bodyTemp_c']}°C',
            ];

            return SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: double.infinity,
                      height: 400,
                      decoration: BoxDecoration(
                        color: Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 100,
                              left: 35,
                              right: 35,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/logo/MedicareLogoRed.png',
                                          width: 35,
                                          height: 35,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Medicare',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1B2021),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'Physiological Health Report',
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black,
                                            fontFamily: 'Inter',
                                          ),
                                          softWrap: true,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Color(0xFF1B2021),
                                      size: 20,
                                    ),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Assigned Professional',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF1B2021),
                                            fontWeight: FontWeight.w200,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          assignedProfessional,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Flexible(
                                  child: Text(
                                    'How are you\nfeeling today?',
                                    style: TextStyle(
                                      fontSize: 39,
                                      color: Colors.black,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w200,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 52,
                            left: 30,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: Text(
                        'Health Report',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Wrap(
                          spacing: 20.0,
                          runSpacing: 20.0,
                          children: List.generate(3, (index) {
                            return SizedBox(
                              width:
                                  (MediaQuery.of(context).size.width - 60) / 2,
                              child: Card(
                                color: Color(0xFFF5F5F5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 5,
                                shadowColor: Colors.black26,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Icon(
                                            icons[index],
                                            color: Colors.red,
                                            size: 75,
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            titles[index],
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 5,
                                        bottom: 5,
                                        left: 10,
                                        right: 10,
                                      ),
                                      padding: EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFECECEC),
                                        border: Border.all(
                                          color: Color(0xFFFFFFFF),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(35),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                10.0,
                                              ),
                                              child: Text(
                                                values[index],
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                softWrap: true,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (
                                                  BuildContext context,
                                                ) {
                                                  return Container(
                                                    height: 600,
                                                    padding: EdgeInsets.all(
                                                      16.0,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          titles[index],
                                                          style: TextStyle(
                                                            fontSize: 24,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily: 'Inter',
                                                          ),
                                                        ),
                                                        SizedBox(height: 20),
                                                        Expanded(
                                                          child:
                                                              ListView.builder(
                                                            itemCount: snapshot
                                                                .data!.length,
                                                            itemBuilder:
                                                                (context, i) {
                                                              final data = snapshot
                                                                  .data![i];
                                                              final timestamp =
                                                                  DateTime.parse(
                                                                      data[
                                                                          'timestamp']);
                                                              final value = _parseValue(
                                                                  data[keys[
                                                                      index]]);
                                                              final previousValue = i <
                                                                      snapshot
                                                                              .data!
                                                                              .length -
                                                                          1
                                                                  ? _parseValue(snapshot
                                                                          .data![i +
                                                                              1][keys[
                                                                      index]])
                                                                  : null;
                                                              final isUp = previousValue !=
                                                                      null &&
                                                                  value >
                                                                      previousValue;
                                                              return Card(
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            8.0),
                                                                child: ListTile(
                                                                  title: Text(
                                                                    '${timestamp.toLocal()}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          'Inter',
                                                                    ),
                                                                  ),
                                                                  subtitle:
                                                                      Row(
                                                                    children: [
                                                                      Text(
                                                                        value !=
                                                                                null
                                                                            ? value.toString() +
                                                                                units[index]
                                                                            : 'N/A',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontFamily:
                                                                              'Inter',
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              8),
                                                                      Icon(
                                                                        isUp
                                                                            ? Icons.arrow_upward
                                                                            : Icons.arrow_downward,
                                                                        color: isUp
                                                                            ? Colors.green
                                                                            : Colors.red,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              width: 45,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Icon(
                                                Icons.timeline,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}