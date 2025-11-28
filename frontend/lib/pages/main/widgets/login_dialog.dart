import 'package:flutter/material.dart';
import 'package:mapa/pages/main/controller/api_controller.dart';

class LoginDialog extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onOpenCadastro;

  const LoginDialog({
    super.key,
    required this.onLoginSuccess,
    required this.onOpenCadastro,
  });

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final ApiController api = ApiController();
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      // Aqui você faria autenticação real se quiser
      final sucesso =
          await api.login(_usuarioController.text, _senhaController.text);
      // final sucesso = true;
      if (sucesso) {
        // Fecha o diálogo e recarrega dados
        Navigator.pop(context);
        widget.onLoginSuccess();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Falha no login")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: LayoutBuilder(builder: (context, constraints) {
          return ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
              minWidth: 280,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Login",
                        style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _usuarioController,
                      decoration: const InputDecoration(labelText: 'Usuário'),
                      validator: (v) => v!.isEmpty ? 'Informe o usuário' : null,
                    ),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Senha'),
                      validator: (v) => v!.isEmpty ? 'Informe a senha' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text('Entrar'),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Não possui conta?"),
                        const SizedBox(
                          width: 8,
                        ),
                        TextButton(
                          onPressed: widget.onOpenCadastro,
                          child: const Text("Cadastre-se"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
