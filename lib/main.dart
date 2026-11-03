import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config.dart';
import 'core/routing/app_router.dart';
import 'core/theme/batik_theme.dart';

void main() {
  runApp(const ProviderScope(child: BatikApp()));
}

class BatikApp extends ConsumerWidget {
  const BatikApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: kShopName,
      debugShowCheckedModeBanner: false,
      theme: buildBatikTheme(),
      routerConfig: router,
    );
  }
}
