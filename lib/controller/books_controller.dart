import '../fave_reads.dart';
import '../model/book.dart';
import '../model/author.dart';

class BooksController extends HTTPController {
  @httpGet
  Future<Response> getAllBooks() async {
    var query = new Query<Book>()..join(set: (book) => book.authors);
    return new Response.ok(await query.fetch());
  }

  @httpGet
  Future<Response> getBook(@HTTPPath("index") int idx) async {
    var query = new Query<Book>()..where.id = whereEqualTo(idx);

    query.join(set: (book) => book.authors)
      ..returningProperties((Author author) => [author.name]);

    var book = await query.fetchOne();

    if (book == null) {
      return new Response.notFound(body: 'Book does not exist')
        ..contentType = ContentType.TEXT;
    }
    return new Response.ok(book);
  }

  @httpPost
  Future<Response> addBook(@HTTPBody() Book book) async {
    var query = new Query<Book>()..values = book;
    var insertedBook = await query.insert();

    // Insert authors from payload
    await Future.forEach(book.authors, (Author a) async {
      var author = new Query<Author>()
        ..values = a
        ..values.book = insertedBook; // set foreign key to inserted book

      return (await author.insert());
    });

    var insertedBookQuery = new Query<Book>()
      ..where.id = whereEqualTo(insertedBook.id);

    insertedBookQuery.join(set: (book) => book.authors)
      ..returningProperties((Author author) => [author.name]);

    return new Response.ok(await insertedBookQuery.fetchOne());
  }

  @httpPut
  Future<Response> updateBook(
      @HTTPPath("index") int idx, @HTTPBody() Book book) async {
    var query = new Query<Book>()
      ..values = book
      ..where.id = whereEqualTo(idx);
    var updatedBook = await query.updateOne();

    if (updatedBook == null) {
      return new Response.notFound(body: 'Book does not exist');
    }

    // Remove previous authors from db
    var deletePreviousAuthorsQuery = new Query<Author>()
      ..canModifyAllInstances = true
      ..where.book.id = whereEqualTo(updatedBook.id);

    await deletePreviousAuthorsQuery.delete();

    // Set new authors from payload
    await Future.forEach(book.authors, (Author a) async {
      var author = new Query<Author>()
        ..values = a
        ..values.book = updatedBook;

      return (await author.insert());
    });

    // Build and execute query for updated book
    var updatedBookQuery = new Query<Book>()
      ..where.id = whereEqualTo(updatedBook.id);

    updatedBookQuery.join(set: (book) => book.authors)
      ..returningProperties((Author author) => [author.name]);

    return new Response.ok(await updatedBookQuery.fetchOne());
  }

  @httpDelete
  Future<Response> deleteBook(@HTTPPath("index") int idx) async {
    var query = new Query<Book>()..where.id = whereEqualTo(idx);
    var deletedBookId = await query.delete();

    if (deletedBookId == 0) {
      return new Response.notFound(body: 'Book does not exist');
    }
    return new Response.ok('Successfully deleted book.');
  }
}
