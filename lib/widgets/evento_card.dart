import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/models/evento.dart';
import 'package:flutter_srpg_app/widgets/evento_checkin_bottomsheet.dart';
import 'package:flutter_srpg_app/widgets/evento_iniciar_bottomsheet.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventoCard extends StatelessWidget {
  final Evento evento;
  final bool isOrganizador;
  const EventoCard({
    super.key,
    required this.evento,
    required this.isOrganizador,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              blurRadius: 32,
              color: Colors.grey.withOpacity(.1),
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(evento.nome),
            subtitle: Text(
                'Data: ${DateFormat('dd/MM/yyyy HH\'h\'mm').format(evento.dtInicioPrevista ?? DateTime.now())}'),
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF0A6D92),
              foregroundColor: Colors.white,
              child: Text(evento.nome[0]),
            ),
            onTap: () => {
              if (evento.status == 'EM_ANDAMENTO' && !isOrganizador)
                {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          EventoCheckInBottomSheet(evento: evento))
                }
              else if (evento.status == 'PENDENTE' && isOrganizador)
                {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          EventoIniciarBottomSheet(evento: evento))
                }
              else
                {
                  showDialog(
                    context: Get.context!,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          'Calma aí, viajante do tempo! ⌛',
                          textAlign: TextAlign.center, // Centraliza o título
                          style: TextStyle(
                              fontWeight:
                                  FontWeight.bold), // Torna o título em negrito
                        ),
                        content: Text(
                          'O evento ainda não começou, que tal aproveitar o tempo para pegar um café e relaxar? ☕ \n\n O evento deve começar em: \n ${evento.dtInicioPrevista.day.toString().padLeft(2, '0')}/${evento.dtInicioPrevista.month}/${evento.dtInicioPrevista.year} às ${evento.dtInicioPrevista.hour}:${evento.dtInicioPrevista.minute}h.',
                          textAlign: TextAlign.center, // Centraliza o conteúdo
                        ),
                        actions: <Widget>[
                          Center(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors
                                    .green, // Cor do texto do botão Cancelar
                                side: const BorderSide(
                                    color: Colors.green,
                                    width: 2), // Borda do botão Cancela
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('Ok, entendi!'),
                            ),
                          )
                        ],
                      );
                    },
                  )
                }
            },
            // Adicione mais detalhes do evento aqui
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...showTags(),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> showTags() {
    final List<Widget> tags = [];
    if (isOrganizador) {
      tags.add(
        Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'Organizador',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    if (evento.status == 'EM_ANDAMENTO') {
      tags.add(
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'Em andamento',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

      tags.add(
        Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 174, 20, 82),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${evento.checkIns.total} check-ins',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } else if (evento.status == 'FINALIZADO') {
      tags.add(
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'Finalizado',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      tags.add(
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'Pendente',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

      if (evento.dtInicioPrevista.isBefore(DateTime.now())) {
        tags.add(
          Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Atrasado',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    }

    return tags;
  }
}
