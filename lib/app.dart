import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'src/presentation/pages/task_list_page.dart';
import 'src/presentation/pages/task_detail_page.dart';
import 'src/presentation/pages/settings_page.dart';
import 'src/presentation/providers/theme_provider.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const TaskListPage(),
    ),
    GoRoute(
      path: '/task/:id',
      builder: (context, state) =>
          TaskDetailPage(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Planner+',
      routerConfig: _router,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,

      // Локализации
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
      ],
    );
  }
}
