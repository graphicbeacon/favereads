import 'fave_reads.dart';

class FaveReadsSink extends RequestSink {
  FaveReadsSink(ApplicationConfiguration appConfig) : super(appConfig) {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  @override
  void setupRouter(Router router) {
    router.route("/example").listen((request) async {
      return new Response.ok({"key": "value"});
    });

    router.route('/').listen((request) async {
      return new Response.ok('Hello world')..contentType = ContentType.TEXT;
    });
  }

  @override
  Future willOpen() async {}
}
