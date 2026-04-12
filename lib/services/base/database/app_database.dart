import 'package:drift/drift.dart';
import 'package:flutter_template/services/base/database/migrations.dart';
export 'connection/connection.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [],
  daos: [])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => migrations();
}
