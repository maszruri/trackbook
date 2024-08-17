import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackbook/providers/form_provider.dart';
import 'package:trackbook/providers/home_provider.dart';
import 'package:trackbook/route.dart';

main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FormProvider(),
        )
      ],
      child: MaterialApp.router(
        routerConfig: appRoute,
      ),
    );
  }
}
