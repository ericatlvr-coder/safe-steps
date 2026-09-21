class Visitor {
  const Visitor({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    required this.purpose,
    required this.location,
    required this.hostName,
    required this.checkIn,
    required this.status,
    this.contactNumber = '',
    this.checkOut,
  });

  final String id;
  final String name;
  final String email;
  final String type;
  final String purpose;
  final String location;
  final String hostName;
  final String contactNumber;
  final DateTime checkIn;
  final DateTime? checkOut;
  final String status;

  Visitor copyWith({
    DateTime? checkOut,
    String? status,
    bool clearCheckOut = false,
  }) {
    return Visitor(
      id: id,
      name: name,
      email: email,
      type: type,
      purpose: purpose,
      location: location,
      hostName: hostName,
      contactNumber: contactNumber,
      checkIn: checkIn,

      // If changing back to Active,
      // this clears the previous checkout time.
      checkOut: clearCheckOut
          ? null
          : checkOut ?? this.checkOut,

      status: status ?? this.status,
    );
  }

  factory Visitor.fromJson(
    Map<String, dynamic> json,
  ) {
    return Visitor(
      id: json['id'].toString(),
      name: json['name'].toString(),
      email: json['email'].toString(),
      type: json['type'].toString(),
      purpose: json['purpose'].toString(),
      location: json['location'].toString(),
      hostName: json['hostName'].toString(),
      contactNumber:
          (json['contactNumber'] ?? '').toString(),
      checkIn: DateTime.parse(
        json['checkIn'].toString(),
      ),
      checkOut: json['checkOut'] == null
          ? null
          : DateTime.tryParse(
              json['checkOut'].toString(),
            ),
      status: json['status'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'type': type,
      'purpose': purpose,
      'location': location,
      'hostName': hostName,
      'contactNumber': contactNumber,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut?.toIso8601String(),
      'status': status,
    };
  }
}