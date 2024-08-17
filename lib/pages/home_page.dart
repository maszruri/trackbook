import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:trackbook/providers/home_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<HomeProvider>().loadBooks();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trackbook"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Consumer<HomeProvider>(
            builder: (context, provider, child) {
              return ExpansionListTile(
                provider: provider,
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final String? form = await context.push('/formPage');
          if (form == 'add') {
            if (context.mounted) {
              context.read<HomeProvider>().loadBooks();
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ExpansionListTile extends StatelessWidget {
  final HomeProvider provider;
  const ExpansionListTile({
    required this.provider,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList.radio(
      children: provider.books.map<ExpansionPanelRadio>(
        (Map book) {
          return ExpansionPanelRadio(
            canTapOnHeader: true,
            value: book['id'],
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Slidable(
                key: ValueKey(book['id']),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        provider.removeBook(book['id']);
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        context.push('/formPage', extra: book['id']);
                      },
                      backgroundColor: const Color(0xFF21B7CA),
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text("${book['title']} [Page ${book['lastRead']}]"),
                  subtitle: Text(
                    'Total Pages : ${book['pages']}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text("Description :"),
                  subtitle: Text(book['description'] ?? '-'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Last Read : ${book['lastRead']}",
                        style: const TextStyle(fontSize: 15),
                      ),
                      IconButton(
                        onPressed: () {
                          if (book['lastRead'] < book['pages']) {
                            context
                                .read<HomeProvider>()
                                .updatePage(book['id'], book['lastRead'] + 1);
                          }
                        },
                        icon: const Icon(Icons.plus_one),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
