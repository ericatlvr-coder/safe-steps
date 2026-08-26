import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safe_steps/models/visitor.dart';
import 'package:safe_steps/services/visitor_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('visitor repository persists records', () async {
    SharedPreferences.setMockInitialValues({});
    final repository = VisitorRepository();
    final now = DateTime(2026, 8, 20, 10, 0);
    final visitors = [
      Visitor(
        id: 'test-1',
        name: 'Test Visitor',
        email: 'test@example.com',
        type: 'Individual',
        purpose: 'Meeting',
        location: 'Head Office',
        hostName: 'John Smith',
        checkIn: now,
        status: 'Active',
      ),
    ];

    await repository.save(visitors);
    final loaded = await repository.load();

    expect(loaded, hasLength(1));
    expect(loaded.single.email, 'test@example.com');
    expect(loaded.single.hostName, 'John Smith');
  });
}
