import 'package:flutter/material.dart';

@immutable
class Bilhete {
  final DateTime startDate;
  final DateTime endDate;
  final String internalId;
  final int ticketId;
  final String title;
  final int eventID;

  const Bilhete(this.internalId, this.eventID,
      {required this.startDate,
      required this.title,
      required this.ticketId,
      required this.endDate});

  @override
  bool operator ==(Object other) {
    return other is Bilhete &&
        other.internalId == internalId &&
        other.ticketId == ticketId;
  }

  @override
  int get hashCode => super.hashCode;
}
