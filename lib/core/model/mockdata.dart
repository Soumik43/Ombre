// To parse this JSON data, do
//
//     final mockData = mockDataFromJson(jsonString);

import 'dart:convert';

MockData mockDataFromJson(String str) => MockData.fromJson(json.decode(str));

String mockDataToJson(MockData data) => json.encode(data.toJson());

class MockData {
  MockData({
    this.value,
  });

  List<Value> value;

  factory MockData.fromJson(Map<String, dynamic> json) => MockData(
        value: List<Value>.from(json["value"].map((x) => Value.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "value": List<dynamic>.from(value.map((x) => x.toJson())),
      };
}

class Value {
  Value({
    this.title,
    this.subtitle,
  });

  String title;
  String subtitle;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        title: json["title"],
        subtitle: json["subtitle"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
      };
}
