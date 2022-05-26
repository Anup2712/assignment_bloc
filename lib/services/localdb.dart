import '../objectbox.g.dart';

class LocalDbService {
  late final Store store;

  LocalDbService._create(this.store);

  static Future<LocalDbService> create() async {
    final store = await openStore();
    return LocalDbService._create(store);
  }
}
