import 'package:flutter/material.dart';
import 'package:mapa/pages/main/controller/api_controller.dart';

class CadastroDialog extends StatefulWidget {
  final VoidCallback onCadastroSuccess;
  final VoidCallback onOpenLogin;

  const CadastroDialog({
    super.key,
    required this.onCadastroSuccess,
    required this.onOpenLogin,
  });

  @override
  State<CadastroDialog> createState() => _CadastroDialogState();
}

class _CadastroDialogState extends State<CadastroDialog> {
  final ApiController api = ApiController();
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  void _cadastrar() async {
    if (_formKey.currentState!.validate()) {
      // Aqui você faria autenticação real se quiser
      final sucesso = await api.register(_usuarioController.text,
          _emailController.text, _senhaController.text);
      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Cadastro realizado com sucesso!"),
            backgroundColor: Colors.green[700]!,
          ),
        );
        widget.onCadastroSuccess();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Falha no cadastro")),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
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
                      Text("Cadastrar",
                          style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _usuarioController,
                        decoration:
                            const InputDecoration(labelText: 'Nome de Usuário'),
                        validator: (v) =>
                            v!.isEmpty ? 'Informe o usuário' : null,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'E-mail'),
                        validator: (v) =>
                            v!.isEmpty ? 'Informe o e-mail' : null,
                      ),
                      TextFormField(
                        controller: _senhaController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Senha'),
                        validator: (v) => v!.isEmpty ? 'Informe a senha' : null,
                      ),
                      TextFormField(
                        controller: _confirmarSenhaController,
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: 'Confirmar Senha'),
                        validator: (v) {
                          if (v!.isEmpty) {
                            return 'A confirmação é necessária';
                          } else if (v != _senhaController.text) {
                            return 'As senhas não coincidem';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _cadastrar,
                        child: const Text('Cadastrar'),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Já tem uma conta?"),
                          const SizedBox(
                            width: 8,
                          ),
                          TextButton(
                            onPressed: widget.onOpenLogin,
                            child: const Text("Login"),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
