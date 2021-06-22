import 'dart:async';
import 'package:cowin_app/data/adstate.dart';
import 'package:cowin_app/data/data.dart';
import 'package:cowin_app/models/district.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'centers_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedState;
  District selectedDistrict;
  List<dynamic> states = [];
  List<District> districts = [];
  List<String> statesList = [];

  bool isLoading = true;
  bool error = false;
  Data data = new Data();

  DateTime selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();
  String _setDate;

  BannerAd banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        banner = BannerAd(
          adUnitId: adState.districtPageBannerAdUnitId,
          size: AdSize.banner,
          request: AdRequest(),
          listener: adState.adListener,
        )..load();
      });
    });
  }

  void getDistricts(String state) async {
    districts = await data.getDistricts(state);
    setState(() {
      selectedDistrict = districts[0];
    });
  }

  void getStates() async {
    try {
      statesList = await data.getStates();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      error = true;
    }
  }

  @override
  void initState() {
    getStates();
    dateController.text = DateFormat.yMd().format(DateTime.now());
    super.initState();
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
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.black,
                ))
              : Container(
                  color: Color(0xFFB8C0FF),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: Container(
                          child: Text(
                            "Select your place",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          child: DropdownButton<String>(
                            autofocus: true,
                            value: selectedState,
                            hint: Text(
                              "Select States",
                              style: TextStyle(
                                color: Colors.grey[800],
                              ),
                            ),
                            onTap: () {
                              districts.clear();
                            },
                            onChanged: (String newValue) {
                              setState(() {
                                selectedState = newValue;
                                getDistricts(selectedState);
                                print(selectedState);
                              });
                            },
                            items: statesList.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          child: DropdownButton<District>(
                            value: selectedDistrict,
                            hint: Text(
                              "Select District                         ",
                              style: TextStyle(
                                color: Colors.grey[800],
                              ),
                            ),
                            onChanged: (District newValue) {
                              setState(() {
                                selectedDistrict = newValue;
                              });
                            },
                            items: districts.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value.districtName,
                                ),
                              );
                            }).toList(),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CentersPage(
                                districts: districts,
                                district: selectedDistrict,
                                date: selectedDate,
                              ),
                            ),
                          );
                        },
                        child: Text("Search"),
                      ),
                      SizedBox(height: 200),
                      // ignore: sdk_version_ui_as_code
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
    );
  }
}
