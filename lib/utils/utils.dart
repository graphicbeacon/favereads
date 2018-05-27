import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

Future createDatabaseSchema(ManagedContext context, bool isTemporary) async {
  var builder = new SchemaBuilder.toSchema(
      context.persistentStore, new Schema.fromDataModel(context.dataModel),
      isTemporary: isTemporary);

  try {
    for (var cmd in builder.commands) {
      await context.persistentStore.execute(cmd);
    }
  } catch (e) {
    // Database may already exist
  }
}
