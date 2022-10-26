import 'package:flutter/material.dart';

@immutable
class EventTag {
  final DateTime startDate;
  final DateTime endDate;
  final int id;

  const EventTag(this.id, {required this.startDate, required this.endDate});
}
