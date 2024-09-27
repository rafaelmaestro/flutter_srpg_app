import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/models/evento.dart';
import 'package:flutter_srpg_app/repositories/login_repository.dart';
import 'package:flutter_srpg_app/widgets/navigation_bar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilPage extends StatefulWidget {
  PerfilPage({super.key});
  List<Evento> eventosOrganizados = [];
  List<Evento> eventosConvidado = [];

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  String nomeUsuario = '';
  String cpfUsuario = '';
  String emailUsuario = '';
  String dtCriacaoUsuario = '';

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
              backgroundColor: const Color(0xFF0A6D92),
              foregroundColor: Colors.white,
              child: Text(
                nomeUsuario[0],
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            nomeUsuario.toUpperCase(),
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
                      const Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize
                                .min, // Minimiza a largura da Row ao conteúdo
                            children: [
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
                        cpfUsuario,
                      ),
                      const SizedBox(height: 20),
                      const Text('E-mail: email-exemplo@email.com'),
                      const SizedBox(height: 20),
                      Text(dtCriacaoUsuario), // TODO: Alterar valores
                      const SizedBox(height: 20),
                      Divider(
                        color: Colors.grey.withOpacity(.3),
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize
                                .min, // Minimiza a largura da Row ao conteúdo
                            children: [
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
                        child: const Text(
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
                        child: const Text('Alterar e-mail',
                            style: TextStyle(color: Color(0xFF0A6D92))),
                      ),
                      TextButton(
                        onPressed: () {
                          // Adicione a lógica para alterar a senha
                        },
                        child: const Text('Alterar senha',
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

  _getUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cpf = prefs.getString('cpf');

      if (cpf != null) {
        final usuario = await LoginRepository().getUser(cpf);

        setState(() {
          nomeUsuario = usuario.nome ?? 'No name';
          cpfUsuario = usuario.cpf ?? '123.456.789-00';
          emailUsuario = usuario.email ?? 'noemail@email.com';
          dtCriacaoUsuario = usuario.dtCriacao ?? '01/01/2021';
        });
      }
    } catch (err) {
      Get.snackbar(
        'Erro ao buscar o usuário! 😢',
        'Erro desconhecido ao buscar usuário, tente novamente mais tarde ou entre em contato com o suporte em 4002-8922',
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
}
