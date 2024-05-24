import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/controllers/posicao_controller.dart';
import 'package:flutter_srpg_app/pages/cadastro/cadastro_page_1.dart';
import 'package:flutter_srpg_app/pages/login/home_page.dart';
import 'package:flutter_srpg_app/pages/login/login_page.dart';
import 'package:flutter_srpg_app/repositories/postos_repository.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AulasRepository>(
          create: (_) => AulasRepository(),
        ),
        ChangeNotifierProvider<PosicaoController>(
          create: (_) => PosicaoController(),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const LogIn()),
          GetPage(name: '/home', page: () => const HomePage()),
          GetPage(name: '/cadastrar', page: () => const CadastroPage1()),
        ],
      ),
    );
  }
}
