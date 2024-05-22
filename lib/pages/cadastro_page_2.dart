import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/pages/camera_page.dart';
import 'package:get/get.dart';

// cpf
// nome
// Email
// foto
// senha
class CadastroPage2 extends StatefulWidget {
  @override
  _CadastroPage2State createState() => _CadastroPage2State();
}

class _CadastroPage2State extends State<CadastroPage2> {
  XFile arquivo = XFile('');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF0A6D92),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: const Color(0xFF0A6D92),
              ),
              child: SafeArea(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                    Container(
                      height: 100,
                      child: Image(
                        image: AssetImage('lib/assets/app/icon.png'),
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.white, // Adicione uma cor ao Container
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(64)),
                ),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Cadastre-se",
                          style: TextStyle(fontSize: 28),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              height: 100,
                              child: Image(
                                image: AssetImage('lib/assets/app/user_m.png'),
                                width: 100,
                              ),
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: Text(
                                'Vamos precisar de uma foto sua para continuar, ok?',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            ),
                            Center(
                              child: Text("📸", style: TextStyle(fontSize: 20)),
                            ),
                            SizedBox(height: 70),
                            Center(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            '*Não se preocupe, ela servirá apenas para ',
                                        style: TextStyle(fontSize: 16)),
                                    TextSpan(
                                        text: 'identificação',
                                        style: TextStyle(fontSize: 16)),
                                    TextSpan(
                                        text: ' e não será divulgada. 😉',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 80),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_box,
                                  color: Colors.green,
                                ),
                                Icon(
                                  Icons.looks_two_outlined,
                                  color: const Color(0xFF0A6D92),
                                ),
                              ],
                            ),
                            SizedBox(height: 40),
                            _botaoBottom()
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  _botaoBottom() {
    if (arquivo != null) {
      return ElevatedButton(
        onPressed: () {
          _handleCadastroBiometria();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A6D92),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16)),
            )),
        child: const Text('Vamos lá!',
            style: TextStyle(
              color: Colors.white,
            )),
      );
    } else {
      return ElevatedButton(
          onPressed: () {
            _handleCadastroBiometria();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A6D92),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
              )),
          child: CircularProgressIndicator(
            color: Colors.white,
          ));
    }
  }

  _handleCadastroBiometria() async {
    var fotoBiometria = await Get.to(() => CameraPage());

    if (fotoBiometria != null) {
      // Adicione a lógica de envio da foto para o servidor
      print(fotoBiometria);
      setState(() {
        arquivo = fotoBiometria;
      });

      // TODO: chamar o backend para cadastrar o usuário
    }
  }
}
