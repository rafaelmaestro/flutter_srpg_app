import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/controllers/posicao_controller.dart';
import 'package:flutter_srpg_app/helpers/format_duration.dart';
import 'package:flutter_srpg_app/models/evento.dart';
import 'package:flutter_srpg_app/services/localizacao_service.dart';
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
  XFile arquivo = XFile('');
  LocalizacaoService service = LocalizacaoService();
  bool isButtonClicked = false;

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
                  handleCheckIn();
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

  handleCheckIn() async {
    setState(() {
      isButtonClicked = true;
    });

    showDialog(
      context: context,
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

    Navigator.pop(context); // fecha o Dialog
  }
}
