import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_srpg_app/helpers/format_duration.dart';
import 'package:flutter_srpg_app/helpers/is_numeric_helper.dart';
import 'package:flutter_srpg_app/helpers/is_valid_email_helper.dart';
import 'package:flutter_srpg_app/models/evento.dart';
import 'package:flutter_srpg_app/repositories/evento_repository.dart';
import 'package:flutter_srpg_app/widgets/evento_checkin_bottomsheet.dart';
import 'package:flutter_srpg_app/widgets/evento_iniciar_bottomsheet.dart';
import 'package:flutter_srpg_app/widgets/my_input_field.dart';
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
  final _presencaFormKey = GlobalKey<FormState>();
  TextEditingController presencaController = TextEditingController();

  List<bool> _isExpandedList1 = [false]; // Ajustar conforme o número de painéis
  List<bool> _isExpandedList2 = [false]; // Ajustar conforme o número de painéis
  List<Presenca> presentes = [];
  List<String> ausentes = [];
  bool _relatorioGerado = false;

  @override
  void initState() {
    super.initState();
    _getRegistros();
  }

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
              backgroundColor: Colors.blueGrey,
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
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Center(
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
                              // Seção superior com informações do evento
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
                                        '⏱️ Duração: ${formatDuration(widget.evento.dtFim!.difference(widget.evento.dtInicio!))}',
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                      Divider(
                                        color: Colors.grey.withOpacity(.3),
                                        thickness: 1,
                                        indent: 20,
                                        endIndent: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Seção intermediária, deve ter um scroll e ficar logo após a seção superior
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Aqui você pode visualizar os presentes e ausentes. Além de realizar o check-in de novos convidados. \n Clique nos títulos para expandir.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic),
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
                                            headerBuilder:
                                                (BuildContext context,
                                                    bool isExpanded) {
                                              return const ListTile(
                                                title: Text('Presentes',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              );
                                            },
                                            body: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                children: [
                                                  Column(
                                                    children: List.generate(
                                                        presentes.length,
                                                        (index) {
                                                      return Card(
                                                        color: Colors.white,
                                                        margin: const EdgeInsets
                                                            .only(bottom: 5),
                                                        shadowColor: Colors.grey
                                                            .withOpacity(.3),
                                                        child: ListTile(
                                                          leading: const Icon(
                                                            Icons.person,
                                                            color: Colors.green,
                                                          ),
                                                          title: Text(
                                                              presentes[index]
                                                                  .email),
                                                          subtitle: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .access_time,
                                                                color:
                                                                    Colors.grey,
                                                                size: 16,
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                presentes[index]
                                                                    .permanencia,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  )
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
                                            headerBuilder:
                                                (BuildContext context,
                                                    bool isExpanded) {
                                              return const ListTile(
                                                title: Text('Ausentes',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              );
                                            },
                                            body: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                children: [
                                                  Column(
                                                    children: List.generate(
                                                        ausentes.length,
                                                        (index) {
                                                      return Card(
                                                        color: Colors.white,
                                                        margin: const EdgeInsets
                                                            .only(bottom: 5),
                                                        shadowColor: Colors.grey
                                                            .withOpacity(.3),
                                                        child: ListTile(
                                                          leading: const Icon(
                                                            Icons.person,
                                                            color: Colors.red,
                                                          ),
                                                          title: Text(
                                                              ausentes[index]),
                                                          trailing: IconButton(
                                                            icon: const Icon(
                                                              Icons.add_circle,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                _isExpandedList2[
                                                                        0] =
                                                                    !_isExpandedList2[
                                                                        0];
                                                              });
                                                              _handleRealizarCheckInConvidado(
                                                                  ausentes[
                                                                      index]);
                                                            },
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
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),
                              // Seção inferior com botões, deve ficar fixa na parte inferior
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: _relatorioGerado
                                      ? null
                                      : () {
                                          _handleGerarRelatorio();
                                        },
                                  icon: const Icon(Icons.mail,
                                      color: Colors.white),
                                  label: const Text(
                                    'Gerar relatório',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _relatorioGerado
                                        ? Colors.grey
                                        : Colors.green,
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                    minimumSize:
                                        const Size(double.infinity, 50),
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
                    }),
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

  _getRegistros() async {
    try {
      final EventoRepository eventoRepository = EventoRepository();
      final response =
          await eventoRepository.getEventoFinalizadoPresentes(widget.evento.id);

      setState(() {
        presentes = response.presentes;
        ausentes = response.ausentes;
      });
    } catch (err) {
      Get.snackbar(
        'Erro ao buscar os registros dos convidados presentes/ausentes! 😢',
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
    }
  }

  _handleRealizarCheckInConvidado(String email) async {
    String _selectedPercentage = '100%';
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.only(left: 20, right: 20),
          child: Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Atribuir presença',
                      textAlign: TextAlign.center, // Centraliza o título
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20), // Torna o título em negrito
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Este evento teve duração de: ${formatDuration(widget.evento.dtFim!.difference(widget.evento.dtInicio!))}',
                      textAlign: TextAlign.center, // Centraliza o conteúdo
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Insira a porcentagem com relação à duração do evento que o convidado ficou presente. Exemplo: 50%.',
                      textAlign: TextAlign.center, // Centraliza o conteúdo
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _presencaFormKey,
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: "Selecione a porcentagem",
                              labelStyle: const TextStyle(
                                color: Color(0xFF0A6D92),
                              ),
                              prefixIcon: const Icon(Icons.percent,
                                  color: Color(0xFF0A6D92)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Color(0xFF0A6D92),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Color(0xFF0A6D92),
                                ),
                              ),
                            ),
                            value: _selectedPercentage,
                            items: ['25%', '50%', '75%', '100%']
                                .map((percentage) => DropdownMenuItem<String>(
                                      value: percentage,
                                      child: Text(percentage),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              _selectedPercentage = value!;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, selecione uma porcentagem';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              _callCheckInConvidado(_selectedPercentage, email);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0A6D92),
                                minimumSize: const Size(double.infinity, 50),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16)),
                                )),
                            child: const Text('Atribuir presença',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _callCheckInConvidado(String porcentagemPresenca, String email) async {
    if (!_presencaFormKey.currentState!.validate()) {
      return;
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

    try {
      final porcentagemPresencaNumber =
          porcentagemPresenca.substring(0, porcentagemPresenca.length - 1);

      final porcentagemPresenca0a1 =
          double.parse(porcentagemPresencaNumber) / 100;

      final EventoRepository eventoRepository = EventoRepository();
      await eventoRepository.realizarCheckIn(
          idEvento: widget.evento.id,
          emailConvidado: email,
          porcentagemPresenca: porcentagemPresenca0a1);

      Get.snackbar(
        'Check-in realizado com sucesso! 🎉',
        'O convidado $email foi marcado como presente.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 10),
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.green,
        progressIndicatorValueColor: const AlwaysStoppedAnimation<Color>(
          Colors.white,
        ),
        isDismissible: true,
      );

      _getRegistros();
      Navigator.of(Get.context!).pop();
    } catch (err) {
      Get.snackbar(
        'Erro ao realizar o check-in do convidado! 😢',
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
    } finally {
      Navigator.of(Get.context!).pop();
    }
  }

  _handleGerarRelatorio() async {
    try {
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

      final EventoRepository eventoRepository = EventoRepository();
      await eventoRepository.gerarRelatorio(widget.evento.id);

      setState(() {
        _relatorioGerado = true;
      });

      Navigator.of(Get.context!).pop();

      Get.snackbar(
        'Relatório gerado com sucesso! 🎉',
        'O relatório foi enviado para o seu e-mail.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 10),
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.green,
        progressIndicatorValueColor: const AlwaysStoppedAnimation<Color>(
          Colors.white,
        ),
        isDismissible: true,
      );
    } catch (err) {
      Get.snackbar(
        'Erro ao gerar o relatório! 😢',
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
    } finally {
      Navigator.of(Get.context!).pop();
    }
  }
}
