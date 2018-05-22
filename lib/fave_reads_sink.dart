import 'fave_reads.dart';
import './controller/books_controller.dart';

class FaveReadsSink extends RequestSink {
  FaveReadsSink(ApplicationConfiguration appConfig) : super(appConfig) {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    var managedDataModel = new ManagedDataModel.fromCurrentMirrorSystem();
    var persistentStore = new PostgreSQLPersistentStore.fromConnectionInfo(
        "dartuser", "dbpass123", "localhost", 5432, "fave_reads");

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

  @override
  Future willOpen() async {
    try {
      await createDatabaseSchema(ManagedContext.defaultContext);
    } catch (e) {}
  }

  Future createDatabaseSchema(ManagedContext context) async {
    var builder = new SchemaBuilder.toSchema(
        context.persistentStore, new Schema.fromDataModel(context.dataModel),
        isTemporary: false);

    for (var cmd in builder.commands) {
      await context.persistentStore.execute(cmd);
    }
  }
}
