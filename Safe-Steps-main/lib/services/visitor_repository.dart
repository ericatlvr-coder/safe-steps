import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/visitor.dart';

class VisitorRepository {
  const VisitorRepository();

  static const String _baseUrl =
      String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:3000',
  );

  String get _visitorsUrl =>
      '$_baseUrl/api/visitors';

  // ==========================================
  // LOAD ALL VISITORS
  // ==========================================

  Future<List<Visitor>> load() async {
    final response = await http
        .get(
          Uri.parse(_visitorsUrl),
          headers: {
            'Accept': 'application/json',
          },
        )
        .timeout(
          const Duration(seconds: 15),
        );

    if (response.statusCode != 200) {
      throw Exception(
        'Unable to load visitors. '
        'HTTP ${response.statusCode}: '
        '${response.body}',
      );
    }

    final decoded =
        jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception(
        'Invalid response from visitor server.',
      );
    }

    final rawVisitors =
        decoded['visitors'];

    if (rawVisitors is! List) {
      throw Exception(
        'Visitor list was not returned by the server.',
      );
    }

    return rawVisitors
        .map(
          (item) => Visitor.fromJson(
            Map<String, dynamic>.from(
              item as Map,
            ),
          ),
        )
        .toList();
  }

  // ==========================================
  // ADD / CHECK IN VISITOR
  // ==========================================

  Future<Visitor> add(
    Visitor visitor,
  ) async {
    final response = await http
        .post(
          Uri.parse(_visitorsUrl),
          headers: {
            'Content-Type':
                'application/json',
            'Accept':
                'application/json',
          },
          body: jsonEncode(
            visitor.toJson(),
          ),
        )
        .timeout(
          const Duration(seconds: 15),
        );

    if (response.statusCode != 201) {
      throw Exception(
        'Unable to save visitor. '
        'HTTP ${response.statusCode}: '
        '${response.body}',
      );
    }

    final decoded =
        jsonDecode(response.body);

    if (decoded is! Map<String, dynamic> ||
        decoded['visitor'] == null) {
      throw Exception(
        'Visitor was saved but the server '
        'returned an invalid response.',
      );
    }

    return Visitor.fromJson(
      Map<String, dynamic>.from(
        decoded['visitor'] as Map,
      ),
    );
  }

  // ==========================================
  // MARK VISITOR COMPLETE
  // ==========================================

  Future<void> complete(
    String visitorId,
  ) async {
    final response = await http
        .put(
          Uri.parse(
            '$_visitorsUrl/'
            '$visitorId/complete',
          ),
          headers: {
            'Accept': 'application/json',
          },
        )
        .timeout(
          const Duration(seconds: 15),
        );

    // Already complete is okay.
    // Complete is final.
    if (response.statusCode == 409) {
      return;
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Unable to complete visitor. '
        'HTTP ${response.statusCode}: '
        '${response.body}',
      );
    }
  }

  // ==========================================
  // CHECK OUT USING EMAIL
  // ==========================================

  Future<bool> checkOutByEmail(
    String email,
  ) async {
    final response = await http
        .post(
          Uri.parse(
            '$_baseUrl/api/visitors/checkout',
          ),
          headers: {
            'Content-Type':
                'application/json',
            'Accept':
                'application/json',
          },
          body: jsonEncode({
            'email':
                email.trim().toLowerCase(),
          }),
        )
        .timeout(
          const Duration(seconds: 15),
        );

    // No active visit for this email.
    if (response.statusCode == 404) {
      return false;
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Unable to check out visitor. '
        'HTTP ${response.statusCode}: '
        '${response.body}',
      );
    }

    return true;
  }
}