import 'package:fave_reads/fave_reads.dart';
import 'package:fave_reads/utils/utils.dart';
import 'package:aqueduct/test.dart';

export 'package:fave_reads/fave_reads.dart';
export 'package:aqueduct/test.dart';
export 'package:test/test.dart';
export 'package:aqueduct/aqueduct.dart';

/// A testing harness for fave_reads.
///
/// Use instances of this class to start/stop the test fave_reads server. Use [client] to execute
/// requests against the test server.  This instance will use configuration values
/// from config.src.yaml.
class TestApplication {
  Application<FaveReadsSink> application;
  FaveReadsSink get sink => application.mainIsolateSink;
  TestClient client;

  Future start() async {
    RequestController.letUncaughtExceptionsEscape = true;
    application = new Application<FaveReadsSink>();
    application.configuration.port = 0;
    application.configuration.configurationFilePath = "config.src.yaml";

    await application.start(runOnMainIsolate: true);

    client = new TestClient(application);
  }

  Future stop() async {
    await application?.stop();
  }

  Future discardPersistentData() async {
    await ManagedContext.defaultContext.persistentStore.close();
    await createDatabaseSchema(ManagedContext.defaultContext, true);
  }
}
