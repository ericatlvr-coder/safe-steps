import 'package:flutter_test/flutter_test.dart';
import 'package:safe_steps/services/entra_host_service.dart';

void main() {
  test('demo Entra service returns enabled hosts', () async {
    final service = DemoEntraHostService();
    final hosts = await service.fetchHosts();

    expect(hosts, isNotEmpty);
    expect(hosts.every((host) => host.enabled), isTrue);
    expect(hosts.any((host) => host.displayName == 'John Smith'), isTrue);
  });
}
