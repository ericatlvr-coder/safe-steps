import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../models/checkin_draft.dart';
import '../models/host.dart';
import '../models/visitor.dart';
import '../services/entra_host_service.dart';
import '../services/visitor_repository.dart';

class SafeStepsStore extends ChangeNotifier {
  SafeStepsStore({
    required EntraHostService hostService,
    required VisitorRepository visitorRepository,
  })  : _hostService = hostService,
        _visitorRepository = visitorRepository;

  final EntraHostService _hostService;
  final VisitorRepository _visitorRepository;

  List<Host> hosts = const [];
  List<Visitor> visitors = const [];
  bool hostSyncing = false;
  String? hostSyncError;
  DateTime? lastHostSync;
  String currentLocation = 'Head Office';

  String get hostSourceLabel => _hostService.sourceLabel;

  Future<void> initialise() async {
    visitors = await _visitorRepository.load();
    await syncHosts(silent: true);
    notifyListeners();
  }

  Future<void> syncHosts({bool silent = false}) async {
    hostSyncing = true;
    hostSyncError = null;
    if (!silent) notifyListeners();
    try {
      hosts = await _hostService.fetchHosts();
      lastHostSync = DateTime.now();
    } catch (e) {
      hostSyncError = e.toString().replaceFirst('Exception: ', '');
    } finally {
      hostSyncing = false;
      notifyListeners();
    }
  }

  Future<Visitor> checkIn(CheckInDraft draft, Host? host) async {
    final visitor = Visitor(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: draft.name.trim(),
      email: draft.email.trim().toLowerCase(),
      type: draft.type,
      purpose: draft.purpose.trim(),
      location: draft.location.trim(),
      hostName: host?.displayName ?? 'Other / Reception',
      contactNumber: draft.contactNumber.trim(),
      checkIn: DateTime.now(),
      status: draft.type == 'Group' ? 'Group Active' : 'Active',
    );
    visitors = [...visitors, visitor];
    await _visitorRepository.save(visitors);
    notifyListeners();
    return visitor;
  }

  Future<bool> checkOutByEmail(String email) async {
    final normalized = email.trim().toLowerCase();
    final index = visitors.lastIndexWhere(
      (v) => v.email.toLowerCase() == normalized && v.checkOut == null,
    );
    if (index < 0) return false;

    final copy = [...visitors];
    copy[index] = copy[index].copyWith(
      checkOut: DateTime.now(),
      status: 'Completed',
    );
    visitors = copy;
    await _visitorRepository.save(visitors);
    notifyListeners();
    return true;
  }

  Visitor? findLatestByEmail(String email) {
    final normalized = email.trim().toLowerCase();
    for (final visitor in visitors.reversed) {
      if (visitor.email.toLowerCase() == normalized) return visitor;
    }
    return null;
  }

  void setLocation(String location) {
    currentLocation = location;
    notifyListeners();
  }

  int get currentVisitors => visitors.where((v) => v.checkOut == null).length;
  int get groupVisitors => visitors.where((v) => v.type == 'Group' && v.checkOut == null).length;
  int get flaggedVisitors => 1;
  int get totalVisitsToday {
    final now = DateTime.now();
    return visitors.where((v) {
      final d = v.checkIn;
      return d.year == now.year && d.month == now.month && d.day == now.day;
    }).length;
  }
}

class SafeStepsScope extends InheritedNotifier<SafeStepsStore> {
  const SafeStepsScope({
    super.key,
    required SafeStepsStore store,
    required super.child,
  }) : super(notifier: store);

  static SafeStepsStore of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SafeStepsScope>();
    assert(scope != null, 'SafeStepsScope not found');
    return scope!.notifier!;
  }
}
