import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbook/sql_helper.dart';

class FormProvider extends ChangeNotifier {
  addBook(String title, String? description, int pages, int lastRead,
      BuildContext context) async {
    await SQLHelper.createBooks(title, description, pages, lastRead);
    notifyListeners();
    if (context.mounted) context.pop('add');
  }
}
