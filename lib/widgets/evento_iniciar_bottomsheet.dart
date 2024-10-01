import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/controllers/posicao_controller.dart';
import 'package:flutter_srpg_app/helpers/format_duration.dart';
import 'package:flutter_srpg_app/models/evento.dart';
import 'package:flutter_srpg_app/pages/evento/evento_organizador_page.dart';
import 'package:flutter_srpg_app/repositories/evento_repository.dart';
import 'package:flutter_srpg_app/services/localizacao_service.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EventoIniciarBottomSheet extends StatefulWidget {
  Evento evento;

  EventoIniciarBottomSheet({super.key, required this.evento});

  @override
  _EventoIniciarBottomSheetState createState() =>
      _EventoIniciarBottomSheetState();
}

class _EventoIniciarBottomSheetState extends State<EventoIniciarBottomSheet> {
  bool isButtonClicked = false;
  late Future<void> _futurePosicao;
  late PosicaoController local;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final local = context.watch<PosicaoController>();
    local.getPosicao();
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                widget.evento.nome,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(widget.evento.descricao),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text('Local: ${widget.evento.local}'),
            ),
            RichText(
              textAlign: TextAlign.center, // Centraliza todo o texto
              text: TextSpan(
                style: DefaultTextStyle.of(context)
                    .style, // Usa o estilo de texto padrão do contexto
                children: <TextSpan>[
                  const TextSpan(
                      text:
                          'Este evento está marcado para iniciar em: \n'), // Texto seguido de quebra de linha
                  TextSpan(
                    text:
                        '${widget.evento.dtInicioPrevista.day.toString().padLeft(2, '0')}/${widget.evento.dtInicioPrevista.month.toString().padLeft(2, '0')}/${widget.evento.dtInicioPrevista.year} às ${widget.evento.dtInicioPrevista.hour}:${widget.evento.dtInicioPrevista.minute}h.', // Texto da data
                    style: const TextStyle(
                        fontWeight:
                            FontWeight.bold), // Estilo específico para a data
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16), // Espaçamento entre os textos
            Text(
                'A duração prevista é de: ${formatDuration(widget.evento.dtFimPrevista.difference(widget.evento.dtInicioPrevista))}.'),
            Text(
                'Este evento tem ${widget.evento.convidados.total} convidados.'),
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 24),
              // child: CircularProgressIndicator()
              child: ElevatedButton(
                onPressed: () {
                  handleInitEvento(local.lat, local.long);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A6D92),
                ),
                child: const Text('Iniciar evento',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  handleInitEvento(double lat, double long) async {
    setState(() {
      isButtonClicked = true;
    });

    if (lat == 0.0 || long == 0.0) {
      await Future.delayed(const Duration(seconds: 5));
    }

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Center(
            child: CircularProgressIndicator(color: Color(0xFF0A6D92)),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 5));

    try {
      final response =
          await EventoRepository().iniciarEvento(widget.evento.id, lat, long);

      setState(() {
        isButtonClicked = false;
      });

      final eventoAtualizado = Evento(
          id: response.evento.id,
          nome: response.evento.nome,
          status: response.evento.status,
          descricao: response.evento.descricao,
          dtCriacao: response.evento.dtCriacao,
          dtInicio: response.evento.dtInicio,
          latitude: response.evento.latitude,
          longitude: response.evento.longitude,
          dtFim: response.evento.dtFim,
          dtUltAtualizacao: response.evento.dtUltAtualizacao,
          dtInicioPrevista: response.evento.dtInicioPrevista,
          dtFimPrevista: response.evento.dtFimPrevista,
          local: response.evento.local,
          cpfOrganizador: response.evento.cpfOrganizador,
          convidados: response.evento.convidados,
          checkIns: response.evento.checkIns,
          checkOuts: response.evento.checkOuts);

      Get.to(() => EventoOrganizadorPage(
            evento: eventoAtualizado,
            atualizarStatus: false,
          ));
    } catch (err) {
      Get.snackbar(
        'Erro ao iniciar o evento! 😢',
        err.toString(),
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
      Navigator.pop(Get.context!);
    }
  }
}
