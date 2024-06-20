import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/models/aula.dart';
import 'package:flutter_srpg_app/repositories/evento_repository.dart';
import 'package:flutter_srpg_app/widgets/evento_card.dart';
import 'package:flutter_srpg_app/widgets/navigation_bar.dart';

class MeusEventosPage extends StatefulWidget {
  MeusEventosPage({super.key});
  List<Evento> eventosOrganizados = [];
  List<Evento> eventosConvidado = [];

  @override
  _MeusEventosPageState createState() => _MeusEventosPageState();
}

class _MeusEventosPageState extends State<MeusEventosPage> {
  String searchQuery = '';
  bool isOrganizadosChecked = true;
  bool isConvidadosChecked = true;
  bool isFiltered = false;

  @override
  void initState() {
    super.initState();
    _loadMeusEventos();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadMeusEventos() {
    // TODO: Implementar a busca dos eventos do usuário
    final eventos =
        EventoRepository().getEventosConvidadosEOrganizados(1, 5, null);

    eventos.forEach((element) {
      if (element['organizador'] == true) {
        Evento eventoRetornado = Evento(
          cpfOrganizador: element['cpfOrganizador'],
          dataFim: element['dataFim'],
          dataInicio: element['dataInicio'],
          descricao: element['descricao'],
          latitude: element['latitude'],
          longitude: element['longitude'],
          local: element['local'],
          nome: element['nome'],
          status: element['status'],
          convidados: element['convidados'],
        );
        widget.eventosOrganizados.add(eventoRetornado);
      } else {
        Evento eventoRetornado = Evento(
          cpfOrganizador: element['cpfOrganizador'],
          dataFim: element['dataFim'],
          dataInicio: element['dataInicio'],
          descricao: element['descricao'],
          latitude: element['latitude'],
          longitude: element['longitude'],
          local: element['local'],
          nome: element['nome'],
          status: element['status'],
          convidados: element['convidados'],
        );
        widget.eventosConvidado.add(eventoRetornado);
      }
    });
  }

  // nome do evento
  // descrição do evento
  // data e hora do evento
  // endereco do evento (cep, cidade, estado, rua, numero, complemento?)

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
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25),
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
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
                          });
                        },
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(color: Color(0xFF0A6D92)),
                            labelText: "Pesquisar",
                            hintText: "Digite aqui o nome do evento...",
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
          // TODO: Implementar checkbox para filtrar eventos organizados e convidados se os dois forem selecionados mostrar tudo, caso contrário mostrar apenas o que foi selecionado, se o que foi seleciona está vazio mostrar mensagem dizendo que não encontrou nada os os filtros especificados
          const SizedBox(height: 20),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ..._handleElementosExibidos(),
                      // ...widget.eventosOrganizados.map((evento) {
                      //   return Card(
                      //     child: ListTile(
                      //       title: Text(evento.nome),
                      //       subtitle: Text('Organizador'),
                      //       // Adicione mais detalhes do evento aqui
                      //     ),
                      //   );
                      // }).toList(),
                      // ...widget.eventosConvidado.map((evento) {
                      //   return Card(
                      //     child: ListTile(
                      //       title: Text(evento.nome),
                      //       // Adicione mais detalhes do evento aqui
                      //     ),
                      //   );
                      // }).toList(),
                    ],
                  )),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SRPGNavigationBar(),
    );
  }

  _handleElementosExibidos() {
    List<Widget> elementosExibidos = [];

    if (widget.eventosOrganizados.isEmpty && widget.eventosConvidado.isEmpty) {
      return elementosExibidos.add(
        const Center(
          child: Text(
            'Nenhum evento encontrado',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    if (isFiltered) {
      if (isOrganizadosChecked && isConvidadosChecked) {
        elementosExibidos.addAll(
          widget.eventosOrganizados.map((evento) {
            return Card(
              child: ListTile(
                title: Text(evento.nome),
                subtitle: Text('Organizador'),
                // Adicione mais detalhes do evento aqui
              ),
            );
          }).toList(),
        );
        elementosExibidos.addAll(
          widget.eventosConvidado.map((evento) {
            return Card(
              child: ListTile(
                title: Text(evento.nome),
                // Adicione mais detalhes do evento aqui
              ),
            );
          }).toList(),
        );
      } else if (isOrganizadosChecked) {
        elementosExibidos.addAll(
          widget.eventosOrganizados.map((evento) {
            return Card(
              child: ListTile(
                title: Text(evento.nome),
                subtitle: Text('Organizador'),
                // Adicione mais detalhes do evento aqui
              ),
            );
          }).toList(),
        );
      } else if (isConvidadosChecked) {
        elementosExibidos.addAll(
          widget.eventosConvidado.map((evento) {
            return Card(
              child: ListTile(
                title: Text(evento.nome),
                // Adicione mais detalhes do evento aqui
              ),
            );
          }).toList(),
        );
      }
    } else {
      elementosExibidos.addAll(
        widget.eventosOrganizados.map((evento) {
          return EventoCard(evento: evento, isOrganizador: true);
        }).toList(),
      );
      elementosExibidos.addAll(
        widget.eventosConvidado.map((evento) {
          return EventoCard(evento: evento, isOrganizador: false);
        }).toList(),
      );
    }

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
            title: Text(
              "Organizados",
              style: TextStyle(fontSize: 16),
            ),
            value: isOrganizadosChecked,
            onChanged: (newValue) {
              setState(() {
                isOrganizadosChecked = newValue ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Color(0xFF0A6D92),
          ),
        ),
        CheckboxListTile(
          title: Text(
            "Convidados",
            style: TextStyle(fontSize: 16),
          ),
          value: isConvidadosChecked,
          onChanged: (newValue) {
            setState(() {
              isConvidadosChecked = newValue ?? false;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: Color(0xFF0A6D92),
        )
      ];
    } else {
      return [SizedBox.shrink()];
    }
  }
}
