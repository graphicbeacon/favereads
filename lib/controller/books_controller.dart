import '../fave_reads.dart';
import '../model/book.dart';

class BooksController extends HTTPController {
  @httpGet
  Future<Response> getAllBooks() async {
    var query = new Query<Book>();
    return new Response.ok(await query.fetch());
  }

  @httpGet
  Future<Response> getBook(@HTTPPath("index") int idx) async {
    var query = new Query<Book>()..where.id = whereEqualTo(idx);
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
    return new Response.ok(await query.insert());
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
    return new Response.ok(updatedBook);
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
