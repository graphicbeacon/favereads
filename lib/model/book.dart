import '../fave_reads.dart';
import './author.dart';

class Book extends ManagedObject<_Book> implements _Book {}

class _Book {
  @managedPrimaryKey
  int id;

  String title;
  int year;

  ManagedSet<Author> authors;
}
