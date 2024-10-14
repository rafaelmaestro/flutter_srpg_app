import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  var deviceData = <String, dynamic>{};
  final deviceInfoPlugin = DeviceInfoPlugin();

  bool isEmulator = false;
  bool validadeEmulator =
      FlutterConfig.get('VALIDATE_EMULATOR_BOOLEAN') == 'true';

  if (validadeEmulator) {
    if (GetPlatform.isAndroid) {
      var androidInfo = await deviceInfoPlugin.androidInfo;
      deviceData = _readAndroidBuildData(androidInfo);
      isEmulator = !androidInfo.isPhysicalDevice;
    } else if (GetPlatform.isIOS) {
      var iosInfo = await deviceInfoPlugin.iosInfo;
      deviceData = _readIosDeviceInfo(iosInfo);
      isEmulator = !iosInfo.isPhysicalDevice;
    }
  }

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

  if (isEmulator) {
    runApp(EmulatorWarningApp());
  } else {
    runApp(const MyApp());
  }
}

Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'version.securityPatch': build.version.securityPatch,
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'version.previewSdkInt': build.version.previewSdkInt,
    'version.incremental': build.version.incremental,
    'version.codename': build.version.codename,
    'version.baseOS': build.version.baseOS,
    'board': build.board,
    'bootloader': build.bootloader,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'fingerprint': build.fingerprint,
    'hardware': build.hardware,
    'host': build.host,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    'supported32BitAbis': build.supported32BitAbis,
    'supported64BitAbis': build.supported64BitAbis,
    'supportedAbis': build.supportedAbis,
    'tags': build.tags,
    'type': build.type,
    'isPhysicalDevice': build.isPhysicalDevice,
    'systemFeatures': build.systemFeatures,
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'systemName': data.systemName,
    'systemVersion': data.systemVersion,
    'model': data.model,
    'localizedModel': data.localizedModel,
    'identifierForVendor': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
    'utsname.sysname:': data.utsname.sysname,
    'utsname.nodename:': data.utsname.nodename,
    'utsname.release:': data.utsname.release,
    'utsname.version:': data.utsname.version,
    'utsname.machine:': data.utsname.machine,
  };
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

class EmulatorWarningApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0A6D92),
        body: Center(
          child: AlertDialog(
            title: const Text(
              'Emulador detectado 🚫',
              textAlign: TextAlign.center, // Centraliza o título
              style: TextStyle(
                  fontWeight: FontWeight.bold), // Torna o título em negrito
            ),
            content: const Text(
              'Este aplicativo não pode ser executado em emuladores. Por favor, instale-o em um dispositivo físico.',
              textAlign: TextAlign.center, // Centraliza o conteúdo
            ),
            actions: <Widget>[
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        Colors.red, // Cor do texto do botão Cancelar
                    side: const BorderSide(
                        color: Colors.red, width: 2), // Borda do botão Cancela
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    // Fecha o aplicativo
                    SystemNavigator.pop();
                  },
                  child: const Text('Fechar'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
