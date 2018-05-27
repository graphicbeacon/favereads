import 'dart:io' show Platform;
import 'package:fave_reads/fave_reads.dart';
import 'package:fave_reads/utils/utils.dart';

Future main() async {
  var app = new Application<FaveReadsSink>()
    ..configuration.configurationFilePath = "config.yaml"
    ..configuration.port = 8000;

  await app.start(numberOfInstances: Platform.numberOfProcessors);

  await createDatabaseSchema(ManagedContext.defaultContext, false);

  print("Application started on port: ${app.configuration.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}
