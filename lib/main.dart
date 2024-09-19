import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_srpg_app/controllers/posicao_controller.dart';
import 'package:flutter_srpg_app/pages/cadastro/cadastro_page_1.dart';
import 'package:flutter_srpg_app/pages/evento/historico_eventos_page.dart';
import 'package:flutter_srpg_app/pages/evento/meus_eventos_page.dart';
import 'package:flutter_srpg_app/pages/evento/perfil_page.dart';
import 'package:flutter_srpg_app/pages/login/home_page.dart';
import 'package:flutter_srpg_app/pages/login/login_page.dart';
import 'package:flutter_srpg_app/repositories/evento_repository.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  const androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "App em execução",
      notificationText: "O aplicativo está sendo executado em segundo plano",
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon:
          AndroidResource(name: 'background_icon', defType: 'drawable'),
      shouldRequestBatteryOptimizationsOff: true);

  bool success =
      await FlutterBackground.initialize(androidConfig: androidConfig);

  if (!success) {
    print("Não foi possível inicializar o FlutterBackground");
  }

  bool hasPermissions = await FlutterBackground.hasPermissions;
  bool enabledBackgroundExecution = false;

  if (hasPermissions) {
    enabledBackgroundExecution =
        await FlutterBackground.enableBackgroundExecution();
  }

  print('---------------------------------------------------');
  print('Permissões: $hasPermissions');
  print('Execução em segundo plano: $enabledBackgroundExecution');
  print('---------------------------------------------------');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EventoRepository>(
          create: (_) => EventoRepository(),
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
          GetPage(name: '/meus-eventos', page: () => MeusEventosPage()),
          GetPage(name: '/historico', page: () => HistoricoEventosPage()),
          GetPage(name: '/perfil', page: () => PerfilPage())
        ],
      ),
    );
  }
}
