import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/models/evento.dart';
import 'package:flutter_srpg_app/widgets/evento_checkin_bottomsheet.dart';
import 'package:flutter_srpg_app/widgets/evento_iniciar_bottomsheet.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventoFinalizadoCard extends StatefulWidget {
  const EventoFinalizadoCard(
      {required this.evento, required this.isOrganizador, super.key});
  final Evento evento;
  final bool isOrganizador;

  @override
  _EventoFinalizadoCardState createState() => _EventoFinalizadoCardState();
}

class _EventoFinalizadoCardState extends State<EventoFinalizadoCard> {
  bool _isExpanded = false;
  final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');

  // Inicialize as listas com o número de painéis (ajuste conforme necessário)
  final List<bool> _isExpandedList1 = List.generate(1, (_) => false);
  final List<bool> _isExpandedList2 = List.generate(1, (_) => false);

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
            title: Text(widget.evento.nome),
            subtitle: Text(
                'Data: ${DateFormat('dd/MM/yyyy HH\'h\'mm').format(widget.evento.dtInicioPrevista ?? DateTime.now())}'),
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF0A6D92),
              foregroundColor: Colors.white,
              child: Text(widget.evento.nome[0]),
            ),
            onTap: () => {
              showDialog(
                barrierDismissible: true,
                context: Get.context!,
                builder: (BuildContext context) {
                  return Dialog(
                    insetPadding: EdgeInsets.zero, // Remove o padding padrão
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Cabeçalho com título e botão de fechar
                          Stack(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          ),
                          // Conteúdo centralizado
                          Expanded(
                            child: Center(
                              child: Column(
                                children: [
                                  Text(widget.evento.nome,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text(
                                    widget.evento.descricao,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text('📍 ${widget.evento.local}',
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(height: 10),
                                  Text(
                                    '📅 Iniciou em: ${formatter.format(widget.evento.dtInicio ?? DateTime.now())}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '📅 Terminou em: ${formatter.format(widget.evento.dtFim ?? DateTime.now())}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '🧑‍🎓 Convidados: ${widget.evento.convidados.total}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Divider(
                                    color: Colors.grey.withOpacity(.3),
                                    thickness: 1,
                                    indent: 20,
                                    endIndent: 20,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Check-ins: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${widget.evento.checkIns.total}',
                                        style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      const SizedBox(width: 20),
                                      const Text(
                                        'Check-outs: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${widget.evento.checkOuts.total}',
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  ExpansionPanelList(
                                    expansionCallback:
                                        (int index, bool isExpanded) {
                                      setState(() {
                                        _isExpandedList1[index] =
                                            !_isExpandedList1[index];
                                      });
                                    },
                                    children: [
                                      ExpansionPanel(
                                        canTapOnHeader: true,
                                        headerBuilder: (BuildContext context,
                                            bool isExpanded) {
                                          return const ListTile(
                                            title: Text('Presentes',
                                                style: TextStyle(fontSize: 16)),
                                          );
                                        },
                                        body: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceEvenly, // Adicione esta linha,
                                            children: [
                                              Text(
                                                widget.evento.nome,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                widget.evento.descricao,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text('📍 ${widget.evento.local}'),
                                              const SizedBox(height: 10),
                                              Text(
                                                  '📅 Iniciou em: ${formatter.format(widget.evento.dtInicio ?? DateTime.now())}'),
                                              Text(
                                                  '📅 Fim previsto: ${formatter.format(widget.evento.dtFimPrevista)}'),
                                              const SizedBox(height: 10),
                                              Text(
                                                  '🧑‍🎓 Convidados: ${widget.evento.convidados.total}'),
                                            ],
                                          ),
                                        ),
                                        isExpanded: _isExpandedList1[0],
                                      ),
                                    ],
                                  ),
                                  ExpansionPanelList(
                                    expansionCallback:
                                        (int index, bool isExpanded) {
                                      setState(() {
                                        _isExpandedList2[index] =
                                            !_isExpandedList2[index];
                                      });
                                    },
                                    children: [
                                      ExpansionPanel(
                                        canTapOnHeader: true,
                                        headerBuilder: (BuildContext context,
                                            bool isExpanded) {
                                          return const ListTile(
                                            title: Text('Ausentes',
                                                style: TextStyle(fontSize: 16)),
                                          );
                                        },
                                        body: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              Column(
                                                children: List.generate(
                                                    widget.evento.checkIns
                                                        .total, (index) {
                                                  return Card(
                                                    color: Colors.white,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 5),
                                                    shadowColor: Colors.grey
                                                        .withOpacity(.3),
                                                    child: ListTile(
                                                      leading: const Icon(
                                                        Icons.person,
                                                        color: Colors.green,
                                                      ),
                                                      title: Text(widget
                                                          .evento
                                                          .checkIns
                                                          .emails[index]),
                                                      trailing: IconButton(
                                                        icon: const Icon(
                                                          Icons.remove_circle,
                                                          color: Colors.red,
                                                        ),
                                                        onPressed: () {},
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              )
                                            ],
                                          ),
                                        ),
                                        isExpanded: _isExpandedList2[0],
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    'Aqui você pode colocar os detalhes do evento.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Botão Voltar no fundo
                          Center(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Color(0xFF0A6D92),
                                foregroundColor: Color(0xFF0A6D92),
                                side: const BorderSide(
                                  color: Color(0xFF0A6D92),
                                  width: 2,
                                ),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Voltar',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            },
            // Adicione mais detalhes do evento aqui
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     ...showTags(),
          //   ],
          // ),
          Center(
            child: Wrap(
              spacing: 8.0, // Espaçamento horizontal entre os widgets
              runSpacing: 4.0, // Espaçamento vertical entre as linhas
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: showTags(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> showTags() {
    final List<Widget> tags = [];
    if (widget.evento.status == 'FINALIZADO') {
      tags.add(
        Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${widget.evento.convidados.total} convidados',
            // '9999 convidados',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );

      tags.add(
        Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${widget.evento.checkIns.total} check-ins',
            // '9999 check-ins',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );

      tags.add(
        Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${widget.evento.checkOuts.total} check-outs',
            // '99999 check-outs',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return tags;
  }
}
