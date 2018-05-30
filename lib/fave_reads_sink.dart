import 'fave_reads.dart';
import './controller/books_controller.dart';
import './utils/utils.dart';

class FaveReadsSink extends RequestSink {
  FaveReadsConfiguration config;

  FaveReadsSink(ApplicationConfiguration appConfig) : super(appConfig) {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    var configFilePath = appConfig.configurationFilePath;
    config = new FaveReadsConfiguration(configFilePath);

    var managedDataModel = new ManagedDataModel.fromCurrentMirrorSystem();
    var persistentStore = new PostgreSQLPersistentStore.fromConnectionInfo(
        config.database.username,
        config.database.password,
        config.database.host,
        config.database.port,
        config.database.databaseName);

    ManagedContext.defaultContext =
        new ManagedContext(managedDataModel, persistentStore);
  }

  @override
  Future willOpen() async {
    await createDatabaseSchema(
        ManagedContext.defaultContext, config.database.isTemporary);
  }

  @override
  void setupRouter(Router router) {
    router.route('/').listen((request) async {
      return new Response.ok('<h1>Welcome to FaveReads</h1>')
        ..contentType = ContentType.HTML;
    });

    router.route('/books[/:index]').generate(() => new BooksController());
  }
}

class FaveReadsConfiguration extends ConfigurationItem {
  FaveReadsConfiguration(String fileName) : super.fromFile(fileName);

  DatabaseConnectionConfiguration database;
}
