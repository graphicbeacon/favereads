import '../fave_reads.dart';
import '../model/book.dart';

// Note: State is kept in a single isolate, meaning
// that updates are not accessible in another isolate.
// This is by design since servers are meant to be stateless.
List books = [
  new Book(
      title: 'Head First Design Patterns', author: 'Eric Freeman', year: 2004),
  new Book(
      title: 'Clean Code: A handbook of Agile Software Craftsmanship',
      author: 'Robert C. Martin',
      year: 2008),
  new Book(
      title: 'Code Complete: A Practical Handbook of Software Construction',
      author: 'Steve McConnell',
      year: 2004),
];

class BooksController extends HTTPController {
  @httpGet
  Future<Response> getAllBooks() async {
    return new Response.ok(books);
  }

  @httpGet
  Future<Response> getBook(@HTTPPath("index") int idx) async {
    if (idx < 0 || idx > books.length - 1) {
      return new Response.notFound(body: 'Book does not exist');
    }
    return new Response.ok(books[idx]);
  }

  @httpPost
  Future<Response> addBook(@HTTPBody() Book book) async {
    books.add(book);
    return new Response.ok(book);
  }

  @httpPut
  Future<Response> updateBook(
      @HTTPPath("index") int idx, @HTTPBody() Book book) async {
    if (idx < 0 || idx > books.length - 1 || book == null) {
      return new Response.notFound(body: 'Book does not exist');
    }
    for (var i = 0; i < books.length; i++) {
      if (i == idx) {
        books[i] = book;
      }
    }
    return new Response.ok(book);
  }

  @httpDelete
  Future<Response> deleteBook(@HTTPPath("index") int idx) async {
    if (idx < 0 || idx > books.length - 1) {
      return new Response.notFound(body: 'Book does not exist');
    }
    books.removeAt(idx);
    return new Response.ok('Book successfully deleted.');
  }
}
