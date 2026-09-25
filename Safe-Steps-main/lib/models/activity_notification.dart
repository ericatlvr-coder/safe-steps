class ActivityNotification {
  const ActivityNotification({
    required this.id,
    required this.visitorId,
    required this.visitorName,
    required this.activityType,
    required this.location,
    required this.createdAt,
  });

  final String id;
  final String visitorId;
  final String visitorName;
  final String activityType;
  final String location;
  final DateTime createdAt;

  factory ActivityNotification.fromJson(
    Map<String, dynamic> json,
  ) {
    return ActivityNotification(
      id: json['id'].toString(),
      visitorId:
          json['visitorId']?.toString() ?? '',
      visitorName:
          json['visitorName']?.toString() ?? '',
      activityType:
          json['activityType']?.toString() ?? '',
      location:
          json['location']?.toString() ?? '',
      createdAt: DateTime.parse(
        json['createdAt'].toString(),
      ),
    );
  }
}