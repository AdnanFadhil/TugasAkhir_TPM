import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class KonversiWaktuPage extends StatefulWidget {
  @override
  _KonversiWaktuPageState createState() => _KonversiWaktuPageState();
}

class _KonversiWaktuPageState extends State<KonversiWaktuPage> {
  late tz.Location selectedLocation;
  String selectedZone = 'WIB';

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    selectedLocation = tz.getLocation('Asia/Jakarta');
  }

  void konversiWaktu(String zone) {
    setState(() {
      selectedZone = zone;
      if (zone == 'WIB') {
        selectedLocation = tz.getLocation('Asia/Jakarta');
      } else if (zone == 'WIT') {
        selectedLocation = tz.getLocation('Asia/Jayapura');
      } else if (zone == 'WITA') {
        selectedLocation = tz.getLocation('Asia/Makassar');
      } else if (zone == 'London') {
        selectedLocation = tz.getLocation('Europe/London');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konversi Waktu'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Pilih Zona Waktu:',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Center(
                        child: DropdownButton<String>(
                          value: selectedZone,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              konversiWaktu(newValue);
                            }
                          },
                          items: [
                            'WIB',
                            'WIT',
                            'WITA',
                            'London',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }).toList(),
                          dropdownColor: Colors.blue,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          underline: SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: StreamBuilder<DateTime>(
                    stream: Stream.periodic(
                      Duration(seconds: 1),
                      (_) => tz.TZDateTime.now(selectedLocation),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Text(
                                'Waktu Saat Ini:',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Center(
                              child: Text(
                                DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(snapshot.data!),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
