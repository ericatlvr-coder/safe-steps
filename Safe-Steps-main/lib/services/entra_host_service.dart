import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/host.dart';

abstract class EntraHostService {
  Future<List<Host>> fetchHosts();
  String get sourceLabel;
}

/// Uses a secure backend/proxy to call Microsoft Graph.
/// Never put a client secret inside a Flutter application.
class ApiEntraHostService implements EntraHostService {
  ApiEntraHostService(this.endpoint);

  final String endpoint;

  @override
  String get sourceLabel => 'Microsoft Entra ID';

  @override
  Future<List<Host>> fetchHosts() async {
    final response = await http
        .get(Uri.parse(endpoint), headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Entra sync failed (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body);
    final raw = decoded is Map<String, dynamic> ? decoded['hosts'] : decoded;
    if (raw is! List) {
      throw Exception('Unexpected Entra host response');
    }
    return raw
        .whereType<Map>()
        .map((item) => Host.fromJson(Map<String, dynamic>.from(item)))
        .where((host) => host.enabled)
        .toList();
  }
}

/// Makes the Iteration 1 prototype runnable without tenant credentials.
/// The same UI/service boundary switches to live Entra using ENTRA_SYNC_URL.
class DemoEntraHostService implements EntraHostService {
  @override
  String get sourceLabel => 'Entra ID demo mirror';

  @override
  Future<List<Host>> fetchHosts() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return const [
      Host(id: 'u-1001', displayName: 'John Smith', email: 'john.smith@safesteps.demo', jobTitle: 'Counsellor'),
      Host(id: 'u-1002', displayName: 'Kate Spade', email: 'kate.spade@safesteps.demo', jobTitle: 'Team Lead'),
      Host(id: 'u-1003', displayName: 'Ben Sawyer', email: 'ben.sawyer@safesteps.demo', jobTitle: 'Case Worker'),
      Host(id: 'u-1004', displayName: 'Barbara Palvin', email: 'barbara.palvin@safesteps.demo', jobTitle: 'Coordinator'),
      Host(id: 'u-1005', displayName: 'Natasha Ford', email: 'natasha.ford@safesteps.demo', jobTitle: 'Practitioner'),
    ];
  }
}

EntraHostService buildEntraHostService() {
  const endpoint = String.fromEnvironment('ENTRA_SYNC_URL', defaultValue: '');
  if (endpoint.trim().isNotEmpty) {
    return ApiEntraHostService(endpoint.trim());
  }
  return DemoEntraHostService();
}
