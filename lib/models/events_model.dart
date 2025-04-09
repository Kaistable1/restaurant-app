class EventsModel {
  final int id;
  final String eventsName;
  final String location;
  final String eventType;
  final String date;
  final String time;
  final String status;
  final String photoUrl;

  EventsModel({
    required this.id,
    required this.eventsName,
    required this.location,
    required this.eventType,
    required this.date,
    required this.time,
    required this.status,
    required this.photoUrl,
  });
}