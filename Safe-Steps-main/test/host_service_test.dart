import 'package:flutter_test/flutter_test.dart';
import 'package:safe_steps/services/host_service.dart';

void main() {
  test(
    'Local host service returns Safe Steps hosts',
    () async {
      final service =
          LocalHostService();

      final hosts =
          await service.fetchHosts();

      expect(
        hosts.length,
        5,
      );

      expect(
        service.sourceLabel,
        'Safe Steps Hosts',
      );

      expect(
        hosts.first.displayName,
        'John Smith',
      );
    },
  );
}