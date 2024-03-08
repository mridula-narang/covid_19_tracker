import 'dart:convert';

import 'package:covid_19_tracker/models/world_stats_model.dart';
import 'package:covid_19_tracker/services/utilities/app_urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StatesServices {
  Future<WorldStatesModel> fetchWorldStatesRecords() async {
    final response = await http.get(Uri.parse(AppUrl.worldStatesApi));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return WorldStatesModel.fromJson(data);
    } else {
      throw Exception('Error');
    }
  }
}
