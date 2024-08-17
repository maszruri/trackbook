import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trackbook/providers/form_provider.dart';
import 'package:trackbook/sql_helper.dart';

class FormPage extends StatefulWidget {
  final int? id;
  const FormPage({super.key, this.id});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final totalPagesController = TextEditingController();
  final lastReadController = TextEditingController();

  _getExistingBook() async {
    final book = await SQLHelper.getBook(widget.id!);
    final existingBook =
        book.firstWhere((element) => element['id'] == widget.id!);
    titleController.text = existingBook['title'];
    descriptionController.text = existingBook['description'];
    totalPagesController.text = existingBook['pages'].toString();
    lastReadController.text = existingBook['lastRead'].toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.id != null) {
      _getExistingBook();
    } else {
      titleController.clear();
      descriptionController.clear();
      totalPagesController.clear();
      lastReadController.clear();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? "Add Book" : "Edit Book"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: descriptionController,
              decoration:
                  const InputDecoration(labelText: "Description (optional)"),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: totalPagesController,
              decoration: const InputDecoration(labelText: "Total Pages"),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: lastReadController,
              decoration: const InputDecoration(labelText: "Last Read Page"),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                if (widget.id == null) {
                  if (context.mounted) {
                    context.read<FormProvider>().addBook(
                        titleController.text.trim(),
                        descriptionController.text.trim(),
                        int.parse(totalPagesController.text.trim()),
                        int.parse(lastReadController.text.trim()),
                        context);
                  }
                }
              },
              child: Text(widget.id == null ? "Add" : "Edit"),
            ),
          ],
        ),
      ),
    );
  }
}
