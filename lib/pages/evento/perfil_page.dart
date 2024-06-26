import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/models/aula.dart';
import 'package:flutter_srpg_app/widgets/navigation_bar.dart';

class PerfilPage extends StatefulWidget {
  PerfilPage({super.key});
  List<Evento> eventosOrganizados = [];
  List<Evento> eventosConvidado = [];

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
              'Meu Perfil',
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
          Center(
            child: CircleAvatar(
              radius: 50, // Tamanho do avatar
              backgroundColor: Color(0xFF0A6D92),
              foregroundColor: Colors.white,
              child: Text(
                'A', // TODO: Substitua 'A' pela primeira letra do nome do usuário
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Nome do Usuário', // TODO: Substitua 'Nome do Usuário' pelo nome do usuário
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 20),
          Divider(
            color: Colors.grey.withOpacity(.3),
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize
                                .min, // Minimiza a largura da Row ao conteúdo
                            children: const [
                              Text(
                                'Informações Pessoais',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                  width: 8), // Espaço entre o ícone e o texto
                              Icon(
                                Icons.person, // Ícone de configurações
                                color: Colors.black, // Cor do ícone
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'CPF: 123.456.789-00', // TODO: Substitua '123.456.789-00' pelo CPF do usuário
                      ),
                      const SizedBox(height: 20),
                      Text('E-mail: email-exemplo@email.com'),
                      const SizedBox(height: 20),
                      Text('Entrou em: 01/01/2021'), // TODO: Alterar valores
                      const SizedBox(height: 20),
                      Divider(
                        color: Colors.grey.withOpacity(.3),
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize
                                .min, // Minimiza a largura da Row ao conteúdo
                            children: const [
                              Text(
                                'Configurações',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                  width: 8), // Espaço entre o ícone e o texto
                              Icon(
                                Icons.settings, // Ícone de configurações
                                color: Colors.black, // Cor do ícone
                              ),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Adicione a lógica para alterar a foto de biometria
                        },
                        child: Text(
                          'Alterar foto de biometria',
                          style: TextStyle(
                            color: Color(0xFF0A6D92),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Adicione a lógica para alterar a foto de biometria
                        },
                        child: Text('Alterar e-mail',
                            style: TextStyle(color: Color(0xFF0A6D92))),
                      ),
                      TextButton(
                        onPressed: () {
                          // Adicione a lógica para alterar a senha
                        },
                        child: Text('Alterar senha',
                            style: TextStyle(color: Color(0xFF0A6D92))),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SRPGNavigationBar(),
    );
  }
}
