import 'dart:async';

import 'package:cowin_app/data/data.dart';
import 'package:cowin_app/models/calender_by_district.dart';
import 'package:cowin_app/models/district.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CentersPage extends StatefulWidget {
  final List<District> districts;
  final District district;
  final int pin;
  final date;

  CentersPage({this.districts, this.pin, this.district, this.date});

  @override
  _CentersPageState createState() => _CentersPageState();
}

class _CentersPageState extends State<CentersPage> {
  List<CenterData> centers = [];
  String url;
  String dose1 = '';
  String dose2 = '';
  Data data = new Data();
  bool isLoading = true;
  bool error = false;
  String fee = '';
  CenterData centerDetails;

  void _launchURL(String url) async => await launch(url);

  void getCenters(District district, var date) async {
    try {
      centers = await data.getCenters(widget.district, widget.date);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      error = true;
    }
  }

  void getCentersByPin(int pin, var date) async {
    try {
      centers = await data.getCentersByPin(widget.pin, widget.date);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      error = true;
    }
  }

  @override
  void initState() {
    if (widget.pin == null) {
      getCenters(widget.district, widget.date);
    } else {
      getCentersByPin(widget.pin, widget.date);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Available Centers",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 10,
      ),
      body: error
          ? Container(
              color: Color(0xFFB8C0FF),
              child: Center(
                child: Text(
                  "Server Unavailable, Try Again Later",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            )
          : isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.black))
              : Container(
                  color: Color(0xFFB8C0FF),
                  child: ListView.separated(
                    separatorBuilder: (context, _) => Divider(
                      height: 25,
                    ),
                    itemCount: centers.length,
                    itemBuilder: (context, index) => listTile(centers[index]),
                  ),
                ),
    );
  }

  Widget listTile(CenterData center) {
    fee = center.feeType;
    centerDetails = center;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            center.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1B4965),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _buildSessions(center.sessions),
        ),
      ],
    );
  }

  Widget _buildSessions(List<Sessions> sessions) {
    return Row(
      children: sessions.map((session) => _buildCard(session)).toList(),
    );
  }

  Widget _buildCard(Sessions session) {
    dose1 = session.availableCapacityDose1.toString();
    dose2 = session.availableCapacityDose2.toString();

    return GestureDetector(
      onTap: () => _showDialog(session),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 2.0,
          color: Color(0xFF90E0EF),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: session.minAgeLimit == 18
                          ? Color(0xFF4CC9F0)
                          : Color(0xFFF72585),
                      child: Text(
                        session.minAgeLimit.toString() + '+',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0),
                      radius: 15,
                      child: Text(''),
                    ),
                    CircleAvatar(
                      radius: 15,
                      backgroundColor:
                          fee == 'Free' ? Color(0xFF1B4332) : Color(0xFFB5179E),
                      child: Text(
                        fee,
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              _slots(session),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  session.vaccine,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  session.date,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _slots(Sessions session) {
    return session.availableCapacity != 0
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('  Dose 1' + '    ' + 'Dose 2  '),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(dose1 + '     |     ' + dose2,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          )
        : Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red[700],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Booked', style: TextStyle(color: Colors.white)),
                )),
          );
  }

  Future<void> _showDialog(Sessions session) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Center Details '),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  centerDetails.name,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(centerDetails.address + ',' + '${centerDetails.pincode}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Timing : ' +
                    centerDetails.from +
                    ' to ' +
                    centerDetails.to),
                SizedBox(height: 20),
                Text(
                  'Book Vaccination slots on: ',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              iconSize: 100,
              icon: Image.asset(
                'images/cowinlogo.png',
              ),
              onPressed: () {
                _launchURL("https://selfregistration.cowin.gov.in/");
              },
            ),
            IconButton(
              iconSize: 50,
              icon: Image.asset(
                'images/umanglogo.png',
              ),
              onPressed: () {
                _launchURL(
                    "https://web.umang.gov.in/web_new/login?redirect_to=department%3Furl%3Dcowin%2F%26dept_id%3D355%26dept_name%3DCo-WIN");
              },
            ),
            IconButton(
              iconSize: 50,
              icon: Image.asset(
                'images/arogyasetulogo.png',
              ),
              onPressed: () {
                _launchURL("https://www.aarogyasetu.gov.in/");
              },
            ),
          ],
        );
      },
    );
  }
}
