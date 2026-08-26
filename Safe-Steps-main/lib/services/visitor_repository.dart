import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/visitor.dart';

class VisitorRepository {
  static const _key = 'safe_steps_visitors_v1';

  Future<List<Visitor>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return _seed();
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .whereType<Map>()
          .map((e) => Visitor.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return _seed();
    }
  }

  Future<void> save(List<Visitor> visitors) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(visitors.map((e) => e.toJson()).toList()),
    );
  }

  List<Visitor> _seed() {
    final now = DateTime.now();
    return [
      Visitor(
        id: 'seed-1',
        name: 'Jane Smith',
        email: 'jane@example.com',
        type: 'Individual',
        purpose: 'Counselling',
        location: 'Head Office',
        hostName: 'John Smith',
        checkIn: DateTime(now.year, now.month, now.day, 8, 13),
        checkOut: DateTime(now.year, now.month, now.day, 9, 2),
        status: 'Completed',
      ),
      Visitor(
        id: 'seed-2',
        name: 'Organisation 1',
        email: 'org1@example.com',
        type: 'Group',
        purpose: 'Community Session',
        location: 'Head Office',
        hostName: 'Kate Spade',
        checkIn: DateTime(now.year, now.month, now.day, 8, 33),
        checkOut: DateTime(now.year, now.month, now.day, 10, 5),
        status: 'Completed',
      ),
      Visitor(
        id: 'seed-3',
        name: 'Organisation 2',
        email: 'org2@example.com',
        type: 'Group',
        purpose: 'Workshop',
        location: 'Head Office',
        hostName: 'Ben Sawyer',
        checkIn: DateTime(now.year, now.month, now.day, 12, 1),
        status: 'Group Active',
      ),
      Visitor(
        id: 'seed-4',
        name: 'Jane Doe',
        email: 'jane.doe@example.com',
        type: 'Individual',
        purpose: 'Crisis support',
        location: 'Head Office',
        hostName: 'Natasha Ford',
        checkIn: DateTime(now.year, now.month, now.day, 14, 0),
        status: 'Active',
      ),
    ];
  }
}
