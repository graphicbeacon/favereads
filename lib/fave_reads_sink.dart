import 'fave_reads.dart';
import './controller/books_controller.dart';

class FaveReadsSink extends RequestSink {
  FaveReadsSink(ApplicationConfiguration appConfig) : super(appConfig) {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
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
  Future willOpen() async {}
}
