import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'src/core/theme/app_theme.dart';
import 'src/data/repositories/txn_repository.dart';
import 'src/data/datasources/local_txn_store.dart';
import 'src/state/txn_provider.dart';
import 'src/ui/home_screen.dart';

// imports cho Category
import 'src/data/repositories/cat_repository.dart';
import 'src/data/datasources/local_cat_store.dart';
import 'src/state/cat_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await LocalTxnStore.ensureOpened();
  await LocalCatStore.ensureOpened();

  final repo = TxnRepositoryImpl(LocalTxnStore());
  final catRepo = CatRepositoryImpl(LocalCatStore());

  runApp(SpendLiteApp(repo: repo, catRepo: catRepo));
}

class SpendLiteApp extends StatelessWidget {
  final TxnRepository repo;
  final CatRepository catRepo; // <-- thêm
  const SpendLiteApp({super.key, required this.repo, required this.catRepo});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TxnRepository>.value(value: repo),
        ChangeNotifierProvider(create: (_) => TxnProvider(repo)..load()),
        ChangeNotifierProvider(create: (_) => CatProvider(catRepo)..load()), // <-- thêm
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
