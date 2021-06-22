import 'package:cowin_app/pages/district_page.dart';
import 'package:cowin_app/pages/pin_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPage extends StatelessWidget {
  void _launchURL(String url) async => await launch(url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Center(
          child: Text(
            "Cowin Slot Finder",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFBBD0FF),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 105.0),
                child: Text(
                  'Cowin Slot Finder',
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                _launchURL(
                    "https://play.google.com/store/apps/details?id=com.arundev.cowin_slot_finder");
              },
              title: Text(
                'Write a review',
                style: TextStyle(fontSize: 12.0),
              ),
              leading: Icon(
                Icons.reviews_outlined,
                color: Colors.black,
              ),
            ),
            ListTile(
              onTap: () {
                _launchURL(
                    "https://play.google.com/store/apps/developer?id=Trendstar+Technologies");
              },
              title: Text(
                'More Apps by TrendStar',
                style: TextStyle(fontSize: 12.0),
              ),
              leading: Icon(
                Icons.apps_outlined,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('images/clip-949.png')),
          color: Color(0xFFB8C0FF),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              ElevatedButton(
                child: Text(
                  'Search by District',
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF1B4965),
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: Text(
                  'Search by Pin',
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF1B4965),
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PinPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
