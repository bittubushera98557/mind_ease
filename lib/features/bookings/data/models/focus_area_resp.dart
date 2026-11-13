// To parse this JSON data, do
//
//     final focusAreaResp = focusAreaRespFromJson(jsonString);

import 'dart:convert';

List<FocusAreaResp> focusAreaRespFromJson(String str) => List<FocusAreaResp>.from(json.decode(str).map((x) => FocusAreaResp.fromJson(x)));

String focusAreaRespToJson(List<FocusAreaResp> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FocusAreaResp {
  String key;
  String label;

  FocusAreaResp({
    required this.key,
    required this.label,
  });

  factory FocusAreaResp.fromJson(Map<String, dynamic> json) => FocusAreaResp(
    key: json["key"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "label": label,
  };
}
