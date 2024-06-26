// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JadwalSholatPage extends StatelessWidget {
  const JadwalSholatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Sholat'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'Jadwal Sholat 30 Hari',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            PrayerTimesWidget(),
          ],
        ),
      ),
    );
  }
}

class PrayerTimesWidget extends StatefulWidget {
  const PrayerTimesWidget({super.key});

  @override
  _PrayerTimesWidgetState createState() => _PrayerTimesWidgetState();
}

class _PrayerTimesWidgetState extends State<PrayerTimesWidget> {
  List<Map<String, dynamic>> _prayerTimes = [];

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes();
  }

  Future<void> fetchPrayerTimes() async {
    final response = await http.get(Uri.parse(
        'http://api.aladhan.com/v1/calendarByCity/2024/6?city=Samarinda&country=ID&state=Kalimantan%20Timur'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _prayerTimes = List<Map<String, dynamic>>.from(data['data']);
      });
    } else {
      throw Exception('Failed to load prayer times');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _prayerTimes.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
                5: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    TableCell(
                        child: Center(
                            child: Text('Tanggal',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                    TableCell(
                        child: Center(
                            child: Text('Subuh',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                    TableCell(
                        child: Center(
                            child: Text('Dzuhr',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                    TableCell(
                        child: Center(
                            child: Text('Asr',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                    TableCell(
                        child: Center(
                            child: Text('Magrib',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                    TableCell(
                        child: Center(
                            child: Text('Isha',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                  ],
                ),
                ..._prayerTimes.map((day) {
                  final timings = day['timings'] ?? {};
                  return TableRow(
                    children: [
                      TableCell(
                          child: Center(
                              child: Text(day['date']['readable'] ?? 'N/A'))),
                      TableCell(
                          child:
                              Center(child: Text(timings['Subuh'] ?? 'N/A'))),
                      TableCell(
                          child:
                              Center(child: Text(timings['Dhuhr'] ?? 'N/A'))),
                      TableCell(
                          child: Center(child: Text(timings['Asr'] ?? 'N/A'))),
                      TableCell(
                          child:
                              Center(child: Text(timings['Magrib'] ?? 'N/A'))),
                      TableCell(
                          child: Center(child: Text(timings['Isha'] ?? 'N/A'))),
                    ],
                  );
                }).toList(),
              ],
            ),
          );
  }
}
