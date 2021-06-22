import 'dart:async';
import 'package:cowin_app/data/adstate.dart';
import 'package:cowin_app/pages/centers_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PinPage extends StatefulWidget {
  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  DateTime selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();
  String _setDate;
  TextEditingController pinController = TextEditingController();
  int pin = 0;
  bool incorrect = false;
  String value = '000000';

  BannerAd banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        banner = BannerAd(
          adUnitId: adState.pinPageBannerAdUnitId,
          size: AdSize.banner,
          request: AdRequest(),
          listener: adState.adListener,
        )..load();
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 7)),
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  @override
  void initState() {
    dateController.text = DateFormat.yMd().format(DateTime.now());
    super.initState();
  }

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
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Color(0xFFB8C0FF),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0, top: 50),
                child: Container(
                  child: Text(
                    "Enter your pin",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextField(
                    controller: pinController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'pincode',
                      errorText: value.length != 6 ? 'Incorrect Pin' : null,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.numberWithOptions(),
                    onChanged: (val) {
                      setState(() {
                        value = val;
                      });
                    },
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: TextFormField(
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                  enabled: false,
                  keyboardType: TextInputType.text,
                  controller: dateController,
                  onSaved: (String val) {
                    _setDate = val;
                  },
                  decoration: InputDecoration(
                    hintText: 'Choose date',
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.only(top: 0.0),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF1B4965),
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  buttonFunction(context);
                },
                child: Text(
                  "Search",
                ),
              ),
              SizedBox(height: 380),
              if (banner == null)
                SizedBox(height: 50)
              else
                Container(
                  alignment: Alignment.center,
                  child: AdWidget(ad: banner),
                  width: banner.size.width.toDouble(),
                  height: banner.size.height.toDouble(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void buttonFunction(BuildContext context) {
    if (pinController.text.length == 6) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CentersPage(
            pin: int.tryParse(pinController.text),
            date: selectedDate,
          ),
        ),
      );
    }
  }
}
