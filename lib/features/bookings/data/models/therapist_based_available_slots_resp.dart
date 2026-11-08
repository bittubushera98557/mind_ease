// To parse this JSON data, do
//
//     final therapistBasedAvailableSlotsResp = therapistBasedAvailableSlotsRespFromJson(jsonString);

import 'dart:convert';

TherapistBasedAvailableSlotsResp therapistBasedAvailableSlotsRespFromJson(String str) => TherapistBasedAvailableSlotsResp.fromJson(json.decode(str));

String therapistBasedAvailableSlotsRespToJson(TherapistBasedAvailableSlotsResp data) => json.encode(data.toJson());

class TherapistBasedAvailableSlotsResp {
  String therapistId;
  int sessionMinutes;
  List<Slot> slots;

  TherapistBasedAvailableSlotsResp({
    required this.therapistId,
    required this.sessionMinutes,
    required this.slots,
  });

  factory TherapistBasedAvailableSlotsResp.fromJson(Map<String, dynamic> json) => TherapistBasedAvailableSlotsResp(
    therapistId: json["therapistId"],
    sessionMinutes: json["sessionMinutes"],
    slots: List<Slot>.from(json["slots"].map((x) => Slot.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "therapistId": therapistId,
    "sessionMinutes": sessionMinutes,
    "slots": List<dynamic>.from(slots.map((x) => x.toJson())),
  };
}

class Slot {
  DateTime startsAt;
  DateTime endsAt;

  Slot({
    required this.startsAt,
    required this.endsAt,
  });

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
    startsAt: DateTime.parse(json["startsAt"]),
    endsAt: DateTime.parse(json["endsAt"]),
  );

  Map<String, dynamic> toJson() => {
    "startsAt": startsAt.toIso8601String(),
    "endsAt": endsAt.toIso8601String(),
  };
}
