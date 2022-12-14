import 'package:flutter/material.dart';

@immutable
class EventTag {
  final DateTime startDate;
  final DateTime endDate;
  final String id;
  //TODO ADD TITLE
  final String eventID;

  const EventTag(this.id, this.eventID,
      {required this.startDate, required this.endDate});
}
