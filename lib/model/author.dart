import '../fave_reads.dart';
import './book.dart';

class Author extends ManagedObject<_Author> implements _Author {}

class _Author {
  @managedPrimaryKey
  int id;

  String name;

  @ManagedRelationship(#authors,
      onDelete: ManagedRelationshipDeleteRule.nullify)
  Book book;
}
