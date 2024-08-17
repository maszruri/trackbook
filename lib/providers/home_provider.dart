import 'package:flutter/material.dart';
import 'package:trackbook/sql_helper.dart';

class HomeProvider extends ChangeNotifier {
  List<Map<String, dynamic>> books = [];
  bool isLoading = true;

  Future<List> loadBooks() async {
    final data = await SQLHelper.getBooks();
    books = data;
    isLoading = false;
    notifyListeners();
    return books;
  }

  removeBook(int id) async {
    await SQLHelper.deleteBook(id);
    loadBooks();
    notifyListeners();
  }

  updatePage(int id, int lastRead) async {
    final book = await SQLHelper.getBook(id);
    final existingBook = book.firstWhere((element) => element['id'] == id);
    await SQLHelper.updateBook(id, existingBook['title'],
            existingBook['description'], existingBook['pages'], lastRead)
        .whenComplete(
      () => loadBooks(),
    );
  }
}
