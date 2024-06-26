import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/models/aula.dart';
import 'package:flutter_srpg_app/pages/login/home_page.dart';
import 'package:flutter_srpg_app/widgets/evento_checkin_bottomsheet.dart';
import 'package:flutter_srpg_app/widgets/evento_iniciar_bottomsheet.dart';
import 'package:intl/intl.dart';

// Card(
//             child: ListTile(
//               title: Text(evento.nome),
//               subtitle: Text('Organizador'),
//               // Adicione mais detalhes do evento aqui
//             ),
//           );

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
    String firstLetterAfterAulaDe = '';
    final RegExp regExp = RegExp(r'Aula de (\w)');
    final Match? match = regExp.firstMatch(evento.nome);
    if (match != null && match.groupCount >= 1) {
      firstLetterAfterAulaDe = match.group(1)!;
    }

    return Container(
      margin: EdgeInsets.only(left: 12, right: 12, top: 12),
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
                'Data: ${DateFormat('dd/MM/yyyy HH\'h\'mm').format(evento.dataInicio)}'),
            leading: CircleAvatar(
              backgroundColor: Color(0xFF0A6D92),
              foregroundColor: Colors.white,
              child: Text(firstLetterAfterAulaDe.toUpperCase()),
            ),
            onTap: () => {
              if (evento.status == StatusAula.emAndamento && !isOrganizador)
                {
                  showModalBottomSheet(
                      context: appKey.currentState!.context,
                      builder: (context) =>
                          EventoCheckInBottomSheet(aula: evento))
                }
              else if (evento.status == StatusAula.pendente && isOrganizador)
                {
                  showModalBottomSheet(
                      context: appKey.currentState!.context,
                      builder: (context) =>
                          EventoIniciarBottomSheet(aula: evento))
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
          child: Text(
            'Organizador',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    if (evento.status == StatusAula.emAndamento) {
      tags.add(
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Em andamento',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else if (evento.status == StatusAula.finalizado) {
      tags.add(
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
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
          child: Text(
            'Pendente',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return tags;
  }
}
