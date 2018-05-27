import 'fave_reads.dart';
import './controller/books_controller.dart';

class FaveReadsSink extends RequestSink {
  FaveReadsSink(ApplicationConfiguration appConfig) : super(appConfig) {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    var configFilePath = appConfig.configurationFilePath;
    var config = new FaveReadsConfiguration(configFilePath);

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
