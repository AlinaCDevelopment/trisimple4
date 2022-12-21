import 'package:flutter/material.dart';

@immutable
class EventTag {
  final DateTime startDate;
  final DateTime endDate;
  final String internalId;
  final int ticketId;
  final String title;
  final int eventID;

  const EventTag(this.internalId, this.eventID,
      {required this.startDate,
      required this.title,
      required this.ticketId,
      required this.endDate});

  @override
  bool operator ==(Object other) {
    return other is EventTag &&
        other.internalId == internalId &&
        other.ticketId == ticketId;
  }

  @override
  int get hashCode => super.hashCode;
}
