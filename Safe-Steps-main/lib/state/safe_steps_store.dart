import 'package:flutter/widgets.dart';

import '../models/activity_notification.dart';
import '../models/checkin_draft.dart';
import '../models/host.dart';
import '../models/visitor.dart';
import '../services/host_service.dart';
import '../services/visitor_repository.dart';

class SafeStepsStore extends ChangeNotifier {
  SafeStepsStore({
    required HostService hostService,
    required VisitorRepository visitorRepository,
  })  : _hostService = hostService,
        _visitorRepository = visitorRepository;

  final HostService _hostService;
  final VisitorRepository _visitorRepository;

  List<Host> hosts = const [];
  List<Visitor> visitors = const [];

  // Permanent notification/activity history
  // loaded from Railway PostgreSQL.
  List<ActivityNotification> notifications = const [];

  bool hostSyncing = false;
  String? hostSyncError;
  DateTime? lastHostSync;

  String currentLocation = 'Head Office';

  String get hostSourceLabel =>
      _hostService.sourceLabel;

  // ==========================================
  // INITIALISE
  // ==========================================

  Future<void> initialise() async {
    // Load visitors.
    try {
      visitors =
          await _visitorRepository.load();
    } catch (e) {
      debugPrint(
        'Could not load visitors: $e',
      );

      visitors = const [];
    }

    // Load notification history.
    try {
      notifications =
          await _visitorRepository
              .loadNotifications();
    } catch (e) {
      debugPrint(
        'Could not load notifications: $e',
      );

      notifications = const [];
    }

    // Load hosts.
    await syncHosts(
      silent: true,
    );

    notifyListeners();
  }

  // ==========================================
  // HOSTS
  // ==========================================

  Future<void> syncHosts({
    bool silent = false,
  }) async {
    hostSyncing = true;
    hostSyncError = null;

    if (!silent) {
      notifyListeners();
    }

    try {
      hosts =
          await _hostService.fetchHosts();

      lastHostSync =
          DateTime.now();
    } catch (e) {
      hostSyncError =
          e.toString().replaceFirst(
                'Exception: ',
                '',
              );
    } finally {
      hostSyncing = false;
      notifyListeners();
    }
  }

  // ==========================================
  // REFRESH VISITORS FROM RAILWAY
  // ==========================================

  Future<void> refreshVisitors() async {
    visitors =
        await _visitorRepository.load();

    notifyListeners();
  }

  // ==========================================
  // REFRESH NOTIFICATIONS FROM RAILWAY
  // ==========================================

  Future<void> refreshNotifications() async {
    notifications =
        await _visitorRepository
            .loadNotifications();

    notifyListeners();
  }

  // ==========================================
  // CHECK IN
  // ==========================================

  Future<Visitor> checkIn(
    CheckInDraft draft,
    Host? host,
  ) async {
    final newVisitor = Visitor(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),

      name:
          draft.name.trim(),

      email: draft.email
          .trim()
          .toLowerCase(),

      type:
          draft.type,

      purpose:
          draft.purpose.trim(),

      location:
          draft.location.trim(),

      hostName:
          host?.displayName ??
          'Other / Reception',

      contactNumber:
          draft.contactNumber.trim(),

      checkIn:
          DateTime.now(),

      status:
          'Active',
    );

    // Save visitor to Railway PostgreSQL.
    //
    // The backend also creates a permanent
    // "check_in" notification.
    final savedVisitor =
        await _visitorRepository.add(
      newVisitor,
    );

    // Reload visitors so the app matches
    // the database.
    visitors =
        await _visitorRepository.load();

    // Reload notifications so the new
    // check-in activity is immediately
    // available in this app.
    try {
      notifications =
          await _visitorRepository
              .loadNotifications();
    } catch (e) {
      debugPrint(
        'Could not refresh notifications '
        'after check-in: $e',
      );
    }

    notifyListeners();

    return savedVisitor;
  }

  // ==========================================
  // CHECK OUT BY EMAIL
  // ==========================================

  Future<bool> checkOutByEmail(
    String email,
  ) async {
    final success =
        await _visitorRepository
            .checkOutByEmail(
      email,
    );

    if (!success) {
      return false;
    }

    // Reload visitors.
    visitors =
        await _visitorRepository.load();

    // The backend creates a permanent
    // completion notification during
    // checkout, so reload notifications too.
    try {
      notifications =
          await _visitorRepository
              .loadNotifications();
    } catch (e) {
      debugPrint(
        'Could not refresh notifications '
        'after checkout: $e',
      );
    }

    notifyListeners();

    return true;
  }

  // ==========================================
  // UPDATE VISITOR STATUS
  // ==========================================

  Future<void> updateVisitorStatus(
    Visitor visitor,
    String newStatus,
  ) async {
    Visitor? currentVisitor;

    for (final item in visitors) {
      if (item.id == visitor.id) {
        currentVisitor = item;
        break;
      }
    }

    if (currentVisitor == null) {
      return;
    }

    // Complete is permanent.
    if (currentVisitor.status ==
        'Complete') {
      return;
    }

    // Only Active -> Complete is allowed.
    if (newStatus == 'Active') {
      return;
    }

    if (newStatus != 'Complete') {
      return;
    }

    await _visitorRepository.complete(
      currentVisitor.id,
    );

    // Reload visitors from PostgreSQL.
    visitors =
        await _visitorRepository.load();

    // The backend creates a NEW permanent
    // completion notification. Reload the
    // notification history so both the
    // check-in and completion remain.
    try {
      notifications =
          await _visitorRepository
              .loadNotifications();
    } catch (e) {
      debugPrint(
        'Could not refresh notifications '
        'after completion: $e',
      );
    }

    notifyListeners();
  }

  // ==========================================
  // FIND VISITOR BY EMAIL
  // ==========================================

  Visitor? findLatestByEmail(
    String email,
  ) {
    final normalized =
        email.trim().toLowerCase();

    for (final visitor
        in visitors) {
      if (visitor.email
              .toLowerCase() ==
          normalized) {
        return visitor;
      }
    }

    return null;
  }

  // ==========================================
  // LOCATION
  // ==========================================

  void setLocation(
    String location,
  ) {
    currentLocation =
        location;

    notifyListeners();
  }

  // ==========================================
  // DASHBOARD COUNTS
  // ==========================================

  int get currentVisitors {
    return visitors
        .where(
          (visitor) =>
              visitor.status ==
                  'Active' &&
              visitor.checkOut ==
                  null,
        )
        .length;
  }

  int get groupVisitors {
    return visitors
        .where(
          (visitor) =>
              visitor.type ==
                  'Group' &&
              visitor.status ==
                  'Active' &&
              visitor.checkOut ==
                  null,
        )
        .length;
  }

  int get flaggedVisitors => 1;

  int get totalVisitsToday {
    final now =
        DateTime.now();

    return visitors.where(
      (visitor) {
        final date =
            visitor.checkIn;

        return date.year ==
                now.year &&
            date.month ==
                now.month &&
            date.day ==
                now.day;
      },
    ).length;
  }
}

// ==========================================
// SAFE STEPS SCOPE
// ==========================================

class SafeStepsScope
    extends InheritedNotifier<
        SafeStepsStore> {
  const SafeStepsScope({
    super.key,
    required SafeStepsStore store,
    required super.child,
  }) : super(
          notifier: store,
        );

  static SafeStepsStore of(
    BuildContext context,
  ) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<
            SafeStepsScope>();

    assert(
      scope != null,
      'SafeStepsScope not found',
    );

    return scope!.notifier!;
  }
}