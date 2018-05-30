import 'harness/app.dart';
import 'package:fave_reads/model/book.dart';

Future main() async {
  TestApplication app = new TestApplication();

  setUpAll(() async {
    await app.start();
  });

  tearDownAll(() async {
    await app.stop();
  });

  setUp(() async {
    // Populate DB
    var books = [
      new Book()
        ..title = "Head First Design Patterns"
        ..author = "Eric Freeman"
        ..year = 2004,
      new Book()
        ..title = "Clean Code: A handbook of Agile Software Craftsmanship"
        ..author = "Robert C. Martin"
        ..year = 2008,
      new Book()
        ..title = "Code Complete: A Practical Handbook of Software Construction"
        ..author = "Steve McConnell"
        ..year = 2004
    ];

    await Future.forEach(books, (Book b) async {
      var query = new Query<Book>()..values = b;
      query.insert();
    });
  });

  tearDown(() async {
    await app.discardPersistentData();
  });

  group("books controller", () {
    test("GET /books returns list of books", () async {
      // Arrange
      var request = app.client.request("/books");

      // Act
      var response = await request.get();

      // Assert
      expectResponse(response, 200,
          body: everyElement(partial(
              {"title": isString, "author": isString, "year": isInteger})));
    });

    test("GET /books/:index returns a single book", () async {
      var request = app.client.request("/books/1");
      expectResponse(await request.get(), 200,
          body: partial({
            "title": "Head First Design Patterns",
            "author": "Eric Freeman",
            "year": 2004,
          }));
    });

    test("POST /books creates a new book", () async {
      var request = app.client.request("/books")
        ..json = {
          "title": "JavaScript: The Good Parts",
          "author": "Douglas Crockford",
          "year": 2008
        };
      expectResponse(await request.post(), 200,
          body: partial({
            "id": 4,
            "title": "JavaScript: The Good Parts",
          }));
    });

    test("PUT /books/:index updates a book", () async {
      var request = app.client.request("/books/1")
        ..json = {
          "title": "JavaScript: The Good Parts",
          "author": "Douglas Crockford",
          "year": 2008
        };
      expectResponse(await request.put(), 200,
          body: partial({"id": 1, "title": "JavaScript: The Good Parts"}));
    });

    test("DELETE /books/:index deletes a book", () async {
      var request = app.client.request("/books/1");
      expectResponse(await request.delete(), 200,
          body: "Successfully deleted book.");
      expectResponse(await request.get(), 404);
    });
  });
}
