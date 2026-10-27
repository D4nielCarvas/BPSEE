import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'features/selecao/selecao_page.dart';

class BPSEEApp extends StatelessWidget {
  const BPSEEApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BPSEE',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const SelecaoPage(),
    );
  }
}
