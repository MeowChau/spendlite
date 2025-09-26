import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'src/core/theme/app_theme.dart';
import 'src/data/repositories/txn_repository.dart';
import 'src/data/datasources/local_txn_store.dart';
import 'src/state/txn_provider.dart';
import 'src/ui/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await LocalTxnStore.ensureOpened();

  final repo = TxnRepositoryImpl(LocalTxnStore());

  runApp(SpendLiteApp(repo: repo));
}

class SpendLiteApp extends StatelessWidget {
  final TxnRepository repo;
  const SpendLiteApp({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TxnRepository>.value(value: repo),               // <-- để StatsPage đọc repo
        ChangeNotifierProvider(create: (_) => TxnProvider(repo)..load()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SpendLite',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
