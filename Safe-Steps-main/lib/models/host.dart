class Host {
  const Host({
    required this.id,
    required this.displayName,
    required this.email,
    this.jobTitle,
    this.enabled = true,
  });

  final String id;
  final String displayName;
  final String email;
  final String? jobTitle;
  final bool enabled;

  factory Host.fromJson(Map<String, dynamic> json) => Host(
        id: (json['id'] ?? '').toString(),
        displayName: (json['displayName'] ?? 'Unknown host').toString(),
        email: (json['mail'] ?? json['email'] ?? json['userPrincipalName'] ?? '')
            .toString(),
        jobTitle: json['jobTitle']?.toString(),
        enabled: json['accountEnabled'] is bool ? json['accountEnabled'] as bool : true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'email': email,
        'jobTitle': jobTitle,
        'accountEnabled': enabled,
      };
}
