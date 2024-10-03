import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/controllers/posicao_controller.dart';
import 'package:flutter_srpg_app/models/evento.dart';
import 'package:flutter_srpg_app/pages/evento/evento_organizador_page.dart';
import 'package:flutter_srpg_app/repositories/evento_repository.dart';
import 'package:flutter_srpg_app/widgets/navigation_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final mapKey = GlobalKey();
  String limiteEventosPagina = '99';

  @override
  void initState() {
    _loadEventos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Column(
          children: [
            Text(
              'Minha Localização',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0A6D92),
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32),
        )),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        // padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
          ],
        ),
        child: ChangeNotifierProvider<PosicaoController>(
          create: (context) => PosicaoController(loadEventosBool: true),
          child: Builder(builder: (context) {
            final local = context.watch<PosicaoController>();

            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GoogleMap(
                key: mapKey,
                initialCameraPosition: CameraPosition(
                    target: LatLng(local.lat, local.long), zoom: 21),
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                myLocationEnabled: true,
                onMapCreated: local.onMapCreated,
                markers: local.markers,
              ),
            );
          }),
        ),
      ),
      extendBody: false,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: const CustomFloatingActionButton(),
      bottomNavigationBar: const SRPGNavigationBar(),
    );
  }

  Future<void> _loadEventos() async {
    try {
      final eventos = await EventoRepository()
          .getEventosConvidadosEOrganizadosPendentesOuEmAndamento(
              limiteEventosPagina);

      final prefs = await SharedPreferences.getInstance();
      final cpf = prefs.get('cpf').toString();

      for (var element in eventos) {
        if (element.cpfOrganizador == cpf &&
            (element.status == 'EM_ANDAMENTO' || element.status == 'PAUSADO')) {
          final eventoEmAndamento = Evento(
              id: element.id,
              nome: element.nome,
              status: element.status,
              descricao: element.descricao,
              dtCriacao: element.dtCriacao,
              dtInicio: element.dtInicio,
              latitude: element.latitude,
              longitude: element.longitude,
              dtFim: element.dtFim,
              dtUltAtualizacao: element.dtUltAtualizacao,
              dtInicioPrevista: element.dtInicioPrevista,
              dtFimPrevista: element.dtFimPrevista,
              local: element.local,
              cpfOrganizador: element.cpfOrganizador,
              convidados: element.convidados,
              checkIns: element.checkIns,
              checkOuts: element.checkOuts);

          Get.to(() => EventoOrganizadorPage(
                evento: eventoEmAndamento,
                atualizarStatus: true,
              ));
          Get.snackbar(
            'Parece que você já tem um evento em andamento! ⌛',
            'Não é possível gerenciar, participar ou iniciar outros eventos enquanto você está com um EM ANDAMENTO.\n\nVocê será redirecionado para a página do evento, se desejar sair do evento, clique em "Encerrar evento" no menu do evento.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 10),
            showProgressIndicator: true,
            progressIndicatorBackgroundColor: Colors.orange,
            progressIndicatorValueColor: const AlwaysStoppedAnimation<Color>(
              Colors.white,
            ),
            isDismissible: true,
          );
        }
      }
    } catch (err) {
      Get.snackbar(
        'Falha ao buscar seus eventos! 😢',
        'Por favor, tente novamente mais tarde.\nCaso o erro persista, entre em contato com o suporte em 📞 4002-8922 e informe o seguinte código: \n\n${err.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 10),
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.red,
        progressIndicatorValueColor: const AlwaysStoppedAnimation<Color>(
          Colors.white,
        ),
        isDismissible: true,
      );
      return;
    }
  }
}
