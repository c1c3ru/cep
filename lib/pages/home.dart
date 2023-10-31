import 'dart:io';

import 'package:cep/models/endereco.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../repos/cep_repo_impl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required String title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepReposImp cep = CepReposImp();
  Endereco? endereco;
  bool loading = false;

  final formKey = GlobalKey<FormState>();
  final cepControl = TextEditingController();

  @override
  void dispose() {
    cepControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CEP'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: cepControl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "digite um CEP";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final valido = formKey.currentState?.validate() ?? false;
                  if (valido) {
                    try {
                      setState(() {
                        loading = true;
                      });
                      final endereco2 = await cep.getCep(cepControl.text);
                      setState(() {
                        loading = false;
                        endereco = endereco2;
                      });
                    } on SocketException catch (e) {
                      setState(() {
                        loading = false;
                        endereco = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('erro ao tentar buscar endereço!')));
                    }
                  }
                },
                child: const Text('Buscar CEP'),
              ),
             Visibility(
                visible: loading,
                child: const CircularProgressIndicator(),),
              Visibility(
                visible: endereco != null,
                child: Text(
                    'Rua: ${endereco?.logradouro} - ${endereco?.complemento}  - Bairro: ${endereco?.bairro}  - Cidade: ${endereco?.localidade} - Estado - ${endereco?.uf} -DDD ${endereco?.ddd}'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
