import 'package:go_router/go_router.dart';
import 'package:trackbook/pages/form_page.dart';
import 'package:trackbook/pages/home_page.dart';

final GoRouter appRoute = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'formPage',
          builder: (context, state) => FormPage(
            id: state.extra as int?,
          ),
        ),
      ],
    ),
  ],
);
