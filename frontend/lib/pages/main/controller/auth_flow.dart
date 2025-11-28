import 'package:flutter/material.dart';
import 'package:mapa/pages/main/widgets/cadastro_dialog.dart';
import 'package:mapa/pages/main/widgets/login_dialog.dart';

class AuthFlow {
  static Future<void> start(
    BuildContext context, {
    required VoidCallback onLoginSuccess,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoginDialog(
        onLoginSuccess: onLoginSuccess,
        onOpenCadastro: () {
          Navigator.pop(context); // fecha login
          startCadastro(context, onLoginSuccess: onLoginSuccess);
        },
      ),
    );
  }

  static Future<void> startCadastro(
    BuildContext context, {
    required VoidCallback onLoginSuccess,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CadastroDialog(
        onCadastroSuccess: () {
          Navigator.pop(context); // fecha cadastro
          start(context, onLoginSuccess: onLoginSuccess); // volta p/ login
        },
        onOpenLogin: () {
          Navigator.pop(context); // fecha cadastro
          start(context, onLoginSuccess: onLoginSuccess);
        },
      ),
    );
  }
}
