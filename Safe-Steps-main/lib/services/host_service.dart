import '../models/host.dart';

abstract class HostService {
  Future<List<Host>> fetchHosts();

  String get sourceLabel;
}

class LocalHostService implements HostService {
  @override
  String get sourceLabel => 'Safe Steps Hosts';

  @override
  Future<List<Host>> fetchHosts() async {
    return const [
      Host(
        id: 'host-1001',
        displayName: 'John Smith',
        email: 'john.smith@safesteps.demo',
        jobTitle: 'Counsellor',
      ),
      Host(
        id: 'host-1002',
        displayName: 'Kate Spade',
        email: 'kate.spade@safesteps.demo',
        jobTitle: 'Team Lead',
      ),
      Host(
        id: 'host-1003',
        displayName: 'Ben Sawyer',
        email: 'ben.sawyer@safesteps.demo',
        jobTitle: 'Case Worker',
      ),
      Host(
        id: 'host-1004',
        displayName: 'Barbara Palvin',
        email: 'barbara.palvin@safesteps.demo',
        jobTitle: 'Coordinator',
      ),
      Host(
        id: 'host-1005',
        displayName: 'Natasha Ford',
        email: 'natasha.ford@safesteps.demo',
        jobTitle: 'Practitioner',
      ),
    ];
  }
}