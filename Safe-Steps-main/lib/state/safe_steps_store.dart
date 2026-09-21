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
        _visitorRepository =
            visitorRepository;

  final EntraHostService _hostService;
  final VisitorRepository
      _visitorRepository;

  List<Host> hosts = const [];
  List<Visitor> visitors = const [];

  bool hostSyncing = false;
  String? hostSyncError;
  DateTime? lastHostSync;

  String currentLocation =
      'Head Office';

  String get hostSourceLabel =>
      _hostService.sourceLabel;

  // ==========================================
  // INITIALISE
  // ==========================================

  Future<void> initialise() async {
    try {
      visitors =
          await _visitorRepository.load();
    } catch (e) {
      debugPrint(
        'Could not load visitors: $e',
      );

      visitors = const [];
    }

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
    final savedVisitor =
        await _visitorRepository.add(
      newVisitor,
    );

    // Reload so the app matches the database.
    visitors =
        await _visitorRepository.load();

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

    visitors =
        await _visitorRepository.load();

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
    // Find the latest version currently
    // loaded from the database.
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

    // IMPORTANT:
    // Complete is permanent.
    if (currentVisitor.status ==
        'Complete') {
      return;
    }

    // Our new database system only allows:
    //
    // Active -> Complete
    //
    // It intentionally does NOT allow:
    //
    // Complete -> Active
    //
    // Active visitors are already Active,
    // so there is nothing to save if
    // Active is selected.
    if (newStatus == 'Active') {
      return;
    }

    if (newStatus != 'Complete') {
      return;
    }

    await _visitorRepository.complete(
      currentVisitor.id,
    );

    // Reload from PostgreSQL.
    visitors =
        await _visitorRepository.load();

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