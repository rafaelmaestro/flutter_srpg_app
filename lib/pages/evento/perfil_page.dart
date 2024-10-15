import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/helpers/is_numeric_helper.dart';
import 'package:flutter_srpg_app/helpers/is_valid_email_helper.dart';
import 'package:flutter_srpg_app/helpers/is_valid_password_helper.dart';
import 'package:flutter_srpg_app/models/evento.dart';
import 'package:flutter_srpg_app/repositories/login_repository.dart';
import 'package:flutter_srpg_app/widgets/my_input_field.dart';
import 'package:flutter_srpg_app/widgets/navigation_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final _formKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController novaSenhaController = TextEditingController();

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
                nomeUsuario.isNotEmpty ? nomeUsuario[0] : 'N',
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
            textAlign: TextAlign.center,
          ),
          TextButton(
              onPressed: () {
                _handleLogout();
              },
              child: const Text(
                'Sair do SRPG',
                style: TextStyle(
                  color: const Color(0xFF0A6D92),
                ),
                textAlign: TextAlign.center,
              )),
          // const SizedBox(height: 10),
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
                                color: Color(0xFF0A6D92), // Cor do ícone
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'CPF: $cpfUsuario',
                      ),
                      const SizedBox(height: 20),
                      Text('E-mail: $emailUsuario'),
                      const SizedBox(height: 20),
                      Text(
                          'Entrou em: ${dtCriacaoUsuario.isNotEmpty ? formatter.format(DateTime.parse(dtCriacaoUsuario)) : 'dd/mm/yyyy'}'),
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
                                color: Color(0xFF0A6D92), // Cor do ícone
                              ),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _handleAlterarFotoBiometria();
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
                          _handleAlterarEmail();
                        },
                        child: const Text('Alterar e-mail',
                            style: TextStyle(color: Color(0xFF0A6D92))),
                      ),
                      TextButton(
                        onPressed: () {
                          _handleAlterarSenha();
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

      setState(() {
        cpfUsuario = cpf ?? '123.456.789-00';
      });

      if (cpf != null) {
        final usuario = await LoginRepository().getUser(cpf);

        setState(() {
          nomeUsuario = usuario.nome ?? 'No name';
          emailUsuario = usuario.email ?? 'noemail@email.com';
          dtCriacaoUsuario = usuario.dtCriacao.toString();
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

  _handleAlterarEmail() {
    // Adicione a lógica para alterar o e-mail
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
                      'Alterar e-mail 📧',
                      textAlign: TextAlign.center, // Centraliza o título
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20), // Torna o título em negrito
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Insira o novo e-mail que deseja utilizar para acessar o SRPG.',
                      textAlign: TextAlign.center, // Centraliza o conteúdo
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _emailFormKey,
                      child: Column(
                        children: [
                          MyInputField(
                            label: "Novo e-mail",
                            placeholder: "Insira seu novo e-mail",
                            onChange: (value) {
                              emailController.text = value;
                            },
                            isEmailOrCpfField: true,
                            validateFunction: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira o novo e-mail';
                              }

                              if (isNumeric(value)) {
                                if (value.length != 11) {
                                  return 'E-mail inválido';
                                } else {
                                  return null;
                                }
                              }

                              if (value.contains('@') == true ||
                                  isNumeric(value) == false) {
                                if (!isValidEmail(value)) {
                                  return 'E-mail inválido';
                                } else {
                                  return null;
                                }
                              }

                              if (value == emailUsuario) {
                                return 'O novo e-mail não pode ser igual ao e-mail atual';
                              }

                              return null;
                            },
                            prefixIcon: const Icon(Icons.person,
                                color: Color(0xFF0A6D92)),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              _alterarEmail();
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
                            child: const Text('Alterar e-mail',
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

  _handleAlterarSenha() {
    // Adicione a lógica para alterar a senha
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
                      'Alterar senha 🔑',
                      textAlign: TextAlign.center, // Centraliza o título
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20), // Torna o título em negrito
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Insira a sua senha atual e a nova senha que deseja utilizar para acessar o SRPG.',
                      textAlign: TextAlign.center, // Centraliza o conteúdo
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                MyInputField(
                                  isPasswordField: true,
                                  label: "Senha atual",
                                  placeholder: "Insira sua senha atual",
                                  onChange: (value) {
                                    senhaController.text = value;
                                  },
                                  isEmailOrCpfField: true,
                                  validateFunction: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira sua senha atual';
                                    }

                                    return null;
                                  },
                                  prefixIcon: const Icon(Icons.password,
                                      color: Color(0xFF0A6D92)),
                                ),
                                const SizedBox(height: 10),
                                MyInputField(
                                  isPasswordField: true,
                                  label: "Nova senha",
                                  placeholder: "Insira sua nova senha",
                                  onChange: (value) {
                                    novaSenhaController.text = value;
                                  },
                                  isEmailOrCpfField: true,
                                  validateFunction: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira sua nova senha';
                                    }

                                    if (isValidPassword(value) == false) {
                                      return 'A senha deve conter no mínimo 8 caracteres, uma letra maiúscula, uma letra minúscula, um caractere especial e um número';
                                    }

                                    if (senhaController.text == value) {
                                      return 'A nova senha não pode ser igual a senha atual';
                                    }

                                    return null;
                                  },
                                  prefixIcon: const Icon(
                                      Icons.password_outlined,
                                      color: Color(0xFF0A6D92)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              _alterarSenha();
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
                            child: const Text('Alterar senha',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          ),
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

  _handleAlterarFotoBiometria() {
    Get.snackbar(
      'Ainda não podemos alterar a foto de biometria! 😢',
      'Em breve teremos essa funcionalidade disponível e você será avisado!',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 10),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.orange,
      progressIndicatorValueColor: const AlwaysStoppedAnimation<Color>(
        Colors.white,
      ),
      isDismissible: true,
    );
  }

  _alterarSenha() async {
    // Adicione a lógica para alterar a senha
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final senhaAntiga = senhaController.text;
    final novaSenha = novaSenhaController.text;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await LoginRepository()
          .updateProfile(emailUsuario, null, novaSenha, senhaAntiga, null);
      prefs.clear();
      Get.offAllNamed('/login');
      Get.snackbar(
        'Senha alterada com sucesso! 🔒',
        'Por questões de segurança, você foi deslogado. Faça login novamente com a nova senha.',
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
        'Erro ao alterar a senha! 😢',
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

  _alterarEmail() async {
    // Adicione a lógica para alterar o e-mail
    if (!_emailFormKey.currentState!.validate()) {
      return;
    }

    final emailNovo = emailController.text;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await LoginRepository()
          .updateProfile(emailUsuario, emailNovo, null, null, null);

      prefs.clear();
      Get.offAllNamed('/login');

      Get.snackbar(
        'E-mail alterado com sucesso! 📧',
        'Seu e-mail foi alterado com sucesso para $emailNovo.\n\nPor questões de segurança, você foi deslogado.\nPor favor, faça login novamente.',
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
        'Erro ao alterar o e-mail! 😢',
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

  _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.offAllNamed('/');

    Get.snackbar(
      'Deslogado com sucesso! 🚪',
      'Você foi deslogado com sucesso.',
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
  }
}
