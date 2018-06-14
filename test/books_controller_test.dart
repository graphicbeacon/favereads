import 'harness/app.dart';
import 'package:fave_reads/model/book.dart';
import 'package:fave_reads/model/author.dart';

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
        ..authors = (new ManagedSet()
          ..add(new Author()..name = "Bert Bates")
          ..add(new Author()..name = "Kathy Sierra")
          ..add(new Author()..name = "Eric Freeman"))
        ..year = 2004,
      new Book()
        ..title = "Clean Code: A handbook of Agile Software Craftsmanship"
        ..authors =
            (new ManagedSet()..add(new Author()..name = "Robert C. Martin"))
        ..year = 2008,
      new Book()
        ..title = "Code Complete: A Practical Handbook of Software Construction"
        ..authors =
            (new ManagedSet()..add(new Author()..name = "Steve McConnell"))
        ..year = 2004
    ];

    await Future.forEach(books, (Book b) async {
      var query = new Query<Book>()..values = b;
      var insertedBook = await query.insert();

      await Future.forEach(b.authors, (Author a) async {
        var query = new Query<Author>()
          ..values = a
          ..values.book = insertedBook;
        return (await query.insert());
      });
      return insertedBook;
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
          body: allOf([
            hasLength(greaterThan(0)),
            everyElement(partial(
                {"title": isString, "year": isInteger, "authors": isList}))
          ]));
    });

    test("GET /books/:index returns a single book", () async {
      var request = app.client.request("/books/1");
      expectResponse(await request.get(), 200, body: {
        "id": 1,
        "title": "Head First Design Patterns",
        "authors": allOf(everyElement(partial({"name": isString}))),
        "year": 2004,
      });
    });

    test("POST /books creates a new book", () async {
      var request = app.client.request("/books")
        ..json = {
          "title": "JavaScript: The Good Parts",
          "year": 2008,
          "authors": [
            {"name": "Douglas Crockford"},
          ],
        };
      expectResponse(await request.post(), 200, body: {
        "id": 4,
        "title": "JavaScript: The Good Parts",
        "year": 2008,
        "authors": [
          partial({"name": "Douglas Crockford"}),
        ]
      });
    });

    test("PUT /books/:index updates a book", () async {
      var request = app.client.request("/books/1")
        ..json = {
          "title": "JavaScript: The Good Parts",
          "year": 2008,
          "authors": [
            {"name": "Douglas Crockford"}
          ],
        };
      expectResponse(await request.put(), 200, body: {
        "id": 1,
        "title": "JavaScript: The Good Parts",
        "year": 2008,
        "authors": [
          partial({"name": "Douglas Crockford"})
        ]
      });
    });

    test("DELETE /books/:index deletes a book", () async {
      var request = app.client.request("/books/1");
      expectResponse(await request.delete(), 200,
          body: "Successfully deleted book.");
      expectResponse(await request.get(), 404);
    });
  });
}
