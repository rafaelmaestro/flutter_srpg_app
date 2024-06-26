import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/controllers/posicao_controller.dart';
import 'package:flutter_srpg_app/models/aula.dart';
import 'package:flutter_srpg_app/services/localizacao_service.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EventoIniciarBottomSheet extends StatefulWidget {
  Evento aula;

  EventoIniciarBottomSheet({super.key, required this.aula});

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
                widget.aula.nome,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(widget.aula.descricao),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text('Local: ${widget.aula.local}'),
            ),
            RichText(
              textAlign: TextAlign.center, // Centraliza todo o texto
              text: TextSpan(
                style: DefaultTextStyle.of(context)
                    .style, // Usa o estilo de texto padrão do contexto
                children: <TextSpan>[
                  TextSpan(
                      text:
                          'Este evento está marcado para iniciar em: \n'), // Texto seguido de quebra de linha
                  TextSpan(
                    text: 'dd/mm/yyyy hh:mm', // Texto da data
                    style: TextStyle(
                        fontWeight:
                            FontWeight.bold), // Estilo específico para a data
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16), // Espaçamento entre os textos
            Text('A duração prevista é de: x horas.'),
            Text('Este evento tem X convidados.'),
            Text('Você está a ${LocalizacaoService().calcularDistancia(
              {'latitude': local.lat, 'longitude': local.long, 'elevacao': 0},
              {
                'latitude': widget.aula.latitude!,
                'longitude': widget.aula.longitude!,
                'elevacao': 0
              },
            )}km de distância desse evento.'), // Novo texto adicionado
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
