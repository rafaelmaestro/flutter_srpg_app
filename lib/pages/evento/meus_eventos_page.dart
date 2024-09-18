import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/models/evento.dart';
import 'package:flutter_srpg_app/repositories/evento_repository.dart';
import 'package:flutter_srpg_app/widgets/evento_card.dart';
import 'package:flutter_srpg_app/widgets/navigation_bar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: implementar paginação vinda do backend
// TODO: implementar search bar realizando busca no backend
class MeusEventosPage extends StatefulWidget {
  MeusEventosPage({super.key});
  List<Evento> eventosOrganizados = [];
  List<Evento> eventosConvidado = [];

  @override
  _MeusEventosPageState createState() => _MeusEventosPageState();
}

class _MeusEventosPageState extends State<MeusEventosPage> {
  late Future<void> _futureMeusEventos;
  String searchQuery = '';
  bool isOrganizadosChecked = true;
  bool isConvidadosChecked = true;
  bool isFiltered = false;
  List<Widget> elementosExibidos = [];

  @override
  void initState() {
    super.initState();
    _futureMeusEventos = _loadMeusEventos();
    elementosExibidos = _handleElementosExibidos(searchQuery);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadMeusEventos() async {
    try {
      final eventos = await EventoRepository()
          .getEventosConvidadosEOrganizadosPendentesOuEmAndamento();

      final prefs = await SharedPreferences.getInstance();
      final cpf = prefs.get('cpf').toString();

      setState(() {
        widget.eventosOrganizados.clear();
        widget.eventosConvidado.clear();

        for (var element in eventos) {
          if (element.cpfOrganizador == cpf) {
            widget.eventosOrganizados.add(element);
          } else {
            widget.eventosConvidado.add(element);
          }
        }

        elementosExibidos.clear();
        elementosExibidos = _handleElementosExibidos(searchQuery);
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Column(
          children: [
            Text(
              'Meus Eventos',
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
      body: FutureBuilder<void>(
        future: _futureMeusEventos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return RefreshIndicator(
                onRefresh: _loadMeusEventos,
                color: const Color(0xFF0A6D92),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.only(left: 25, right: 25),
                      padding: const EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 10),
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
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      searchQuery = value;
                                      elementosExibidos.clear();
                                      elementosExibidos =
                                          _handleElementosExibidos(searchQuery);
                                    });
                                  },
                                  decoration: const InputDecoration(
                                      labelStyle:
                                          TextStyle(color: Color(0xFF0A6D92)),
                                      labelText: "Pesquisar",
                                      hintText:
                                          "Digite aqui o nome do evento...",
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Color(0xFF0A6D92),
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(0)),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.filter_alt,
                                  color: Color(0xFF0A6D92),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isFiltered = true;
                                  });
                                },
                              ),
                              _showCloseFilterIcon(),
                            ],
                          ),
                          ..._handleIsFiltered(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SafeArea(
                        top: false,
                        child: Scrollbar(
                          thickness:
                              8.0, // Define a espessura da barra de rolagem
                          radius: const Radius.circular(
                              10.0), // Define o raio da borda da barra de rolagem
                          scrollbarOrientation: ScrollbarOrientation
                              .right, // Define a orientação da barra de rolagem
                          child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  ...elementosExibidos,
                                ],
                              )),
                        ),
                      ),
                    ),
                  ],
                ));
          }
        },
      ),
      bottomNavigationBar: const SRPGNavigationBar(),
    );
  }

  _handleElementosExibidos(String? searchQuery) {
    if (widget.eventosOrganizados.isEmpty && widget.eventosConvidado.isEmpty) {
      elementosExibidos.add(const SizedBox(height: 20));
      elementosExibidos.add(
        const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Tudo tranquilo por aqui! 😎 \n\n Você ainda não foi convidado para nenhum evento. Que tal ser o protagonista e criar o seu próprio?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );
      elementosExibidos.add(const SizedBox(height: 500));

      return elementosExibidos;
    }

    // TODO: verficar se existe algum evento onde o usuário é organizador com status 'EM_ANDAMENTO'
    // Verificar se existe algum evento onde o usuário é organizador com status 'EM_ANDAMENTO'
    bool existeEventoEmAndamento = widget.eventosOrganizados
        .any((evento) => evento.status == 'EM_ANDAMENTO');

    if (existeEventoEmAndamento) {
      // Get.offAndToNamed('/evento/em-andamento');
    }

    List<Evento> eventosOrganizados = List.from(widget.eventosOrganizados);
    List<Evento> eventosConvidado = List.from(widget.eventosConvidado);
    List<Evento> todosEventos = [];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      eventosOrganizados = eventosOrganizados
          .where((evento) =>
              evento.nome.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
      eventosConvidado = eventosConvidado
          .where((evento) =>
              evento.nome.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    DateTime now = DateTime.now();

    int compareEventos(Evento a, Evento b) {
      if (a.status == 'EM_ANDAMENTO' && b.status != 'EM_ANDAMENTO') {
        return -1;
      } else if (a.status != 'EM_ANDAMENTO' && b.status == 'EM_ANDAMENTO') {
        return 1;
      } else {
        Duration diffA = a.dtInicioPrevista.difference(now);
        Duration diffB = b.dtInicioPrevista.difference(now);
        int dateComparison = diffA.compareTo(diffB);
        if (dateComparison == 0) {
          // Se as datas forem iguais, dar preferência aos eventos organizados pelo usuário
          bool aIsOrganizador = eventosOrganizados.contains(a);
          bool bIsOrganizador = eventosOrganizados.contains(b);
          if (aIsOrganizador && !bIsOrganizador) {
            return -1;
          } else if (!aIsOrganizador && bIsOrganizador) {
            return 1;
          }
        }
        return dateComparison;
      }
    }

    eventosOrganizados.sort(compareEventos);
    eventosConvidado.sort(compareEventos);

    if (isFiltered) {
      if (isOrganizadosChecked && isConvidadosChecked) {
        todosEventos = [...eventosOrganizados, ...eventosConvidado];
      } else if (isOrganizadosChecked) {
        elementosExibidos.addAll(
          eventosOrganizados.map((evento) {
            return EventoCard(evento: evento, isOrganizador: true);
          }).toList(),
        );
      } else if (isConvidadosChecked) {
        elementosExibidos.addAll(
          eventosConvidado.map((evento) {
            return EventoCard(evento: evento, isOrganizador: false);
          }).toList(),
        );
      }
    } else {
      todosEventos = [...eventosOrganizados, ...eventosConvidado];
    }

    todosEventos =
        todosEventos.where((evento) => evento.status != 'FINALIZADO').toList();

    todosEventos.sort(compareEventos);
    elementosExibidos.addAll(
      todosEventos.map((evento) {
        return EventoCard(
            evento: evento, isOrganizador: eventosOrganizados.contains(evento));
      }).toList(),
    );

    elementosExibidos.add(const SizedBox(height: 500));

    return elementosExibidos;
  }

  _showCloseFilterIcon() {
    if (isFiltered) {
      return IconButton(
        icon: const Icon(
          Icons.close,
          color: Color(0xFF0A6D92),
        ),
        onPressed: () {
          setState(() {
            isFiltered = false;
          });
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  List<Widget> _handleIsFiltered() {
    if (isFiltered) {
      return [
        Center(
          child: CheckboxListTile(
            title: const Text(
              "Organizados",
              style: TextStyle(fontSize: 16),
            ),
            value: isOrganizadosChecked,
            onChanged: (newValue) {
              setState(() {
                isOrganizadosChecked = newValue ?? false;
                elementosExibidos.clear();
                elementosExibidos = _handleElementosExibidos(searchQuery);
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: const Color(0xFF0A6D92),
          ),
        ),
        CheckboxListTile(
          title: const Text(
            "Convidados",
            style: TextStyle(fontSize: 16),
          ),
          value: isConvidadosChecked,
          onChanged: (newValue) {
            setState(() {
              isConvidadosChecked = newValue ?? false;
              elementosExibidos.clear();
              elementosExibidos = _handleElementosExibidos(searchQuery);
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: const Color(0xFF0A6D92),
        )
      ];
    } else {
      return [const SizedBox.shrink()];
    }
  }
}
