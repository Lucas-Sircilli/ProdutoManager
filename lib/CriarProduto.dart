import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CriarProduto extends StatefulWidget {
  const CriarProduto({super.key});

  @override
  State<CriarProduto> createState() => _CriarProdutoState();
}

class _CriarProdutoState extends State<CriarProduto> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  bool ativo = true;
  final TextEditingController valorController = TextEditingController();
  final TextEditingController saldoController = TextEditingController();
  final TextEditingController eanController = TextEditingController();

  bool isLoading = false;

  Future<void> enviarProduto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final Map<String, dynamic> produto = {
      "nome": nomeController.text.trim(),
      "descricao": descricaoController.text.trim(),
      "ativo": ativo,
      "valor": double.parse(valorController.text.trim()),
      "saldo": int.parse(saldoController.text.trim()),
      "ean": eanController.text.trim(),
    };

    const url = 'https://produtonetcoreapi-a3h3apdvdgfbaeg0.brazilsouth-01.azurewebsites.net/Produto';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(produto),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto criado com sucesso!')),
        );
        Navigator.pop(context, true); // volta para tela anterior, pode mandar true para indicar sucesso
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ${response.statusCode}: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro na requisição: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    valorController.dispose();
    saldoController.dispose();
    eanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Produto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) => (value == null || value.isEmpty) ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) => (value == null || value.isEmpty) ? 'Informe a descrição' : null,
              ),
              SwitchListTile(
                title: const Text('Ativo'),
                value: ativo,
                onChanged: (val) {
                  setState(() {
                    ativo = val;
                  });
                },
              ),
              TextFormField(
                controller: valorController,
                decoration: const InputDecoration(labelText: 'Valor'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o valor';
                  final val = double.tryParse(value);
                  if (val == null) return 'Valor inválido';
                  return null;
                },
              ),
              TextFormField(
                controller: saldoController,
                decoration: const InputDecoration(labelText: 'Saldo'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o saldo';
                  final val = int.tryParse(value);
                  if (val == null) return 'Saldo inválido';
                  return null;
                },
              ),
              TextFormField(
                controller: eanController,
                decoration: const InputDecoration(labelText: 'EAN'),
                keyboardType: TextInputType.number,
                validator: (value) => (value == null || value.isEmpty) ? 'Informe o EAN' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : enviarProduto,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
