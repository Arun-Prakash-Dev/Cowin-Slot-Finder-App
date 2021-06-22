import 'dart:async';
import 'dart:convert';
import 'package:cowin_app/models/calender_by_district.dart';
import 'package:cowin_app/models/district.dart';
import 'package:cowin_app/models/state.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Data {
  List<String> statesList = [];
  List<dynamic> states = [];
  List<String> districtsList = [];
  var responseOfStates;
  var responseOfDistricts;

  Future<void> getAPIStates() async {
    responseOfStates = await http.get(
        Uri.parse("https://cdn-api.co-vin.in/api/v2/admin/location/states"));
  }

  Future<void> getAPIDistricts(int stateId) async {
    print(stateId);
    responseOfDistricts = await http.get(Uri.parse(
        "https://cdn-api.co-vin.in/api/v2/admin/location/districts/$stateId"));
  }

  Future<List<String>> getStates() async {
    try {
      await getAPIStates();
      Map<String, dynamic> jsonData = jsonDecode(responseOfStates.body);
      StateList stateModel = StateList.fromMap(jsonData);

      states = stateModel.toMap()['states'];
      for (int i = 0; i < states.length; i++) {
        statesList.add(states[i]["state_name"]);
      }

      return statesList;
    } catch (e) {
      return null;
    }
  }

  Future<List<District>> getDistricts(String state) async {
    var stateId;
    bool contain;
    for (int i = 0; i < statesList.length; i++) {
      contain = states[i].containsValue(state);
      if (contain) {
        stateId = states[i]['state_id'];
        print('$stateId');
        break;
      }
    }

    await getAPIDistricts(stateId);

    Map<String, dynamic> jsonData = jsonDecode(responseOfDistricts.body);

    Districts districtModel = Districts.fromJson(jsonData);
    return districtModel.districts;
  }

  Future<List<CenterData>> getCenters(District district, var date) async {
    var districtId = district.districtId;
    var day = DateFormat.d().format(date);
    var month = DateFormat.M().format(date);
    var year = DateFormat.y().format(date);
    var url =
        "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=$districtId&date=$day-$month-$year";

    var responseOfCenters = await http.get(Uri.parse(url));
    Map<String, dynamic> jsonData = jsonDecode(responseOfCenters.body);
    Centers centerModel = Centers.fromJson(jsonData);
    return centerModel.centers;
  }

  Future<List<CenterData>> getCentersByPin(int pin, var date) async {
    var day = DateFormat.d().format(date);
    var month = DateFormat.M().format(date);
    var year = DateFormat.y().format(date);
    var url =
        "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=$pin&date=$day-$month-$year";

    var responseOfCenters = await http.get(Uri.parse(url));
    Map<String, dynamic> jsonData = jsonDecode(responseOfCenters.body);
    Centers centerModel = Centers.fromJson(jsonData);
    return centerModel.centers;
  }
}
