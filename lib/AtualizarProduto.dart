import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AtualizarProduto extends StatefulWidget {
  final Map<String, dynamic> produto;
  const AtualizarProduto({super.key, required this.produto});

  @override
  State<AtualizarProduto> createState() => _AtualizarProdutoState();
}

class _AtualizarProdutoState extends State<AtualizarProduto> {
  late TextEditingController nomeController;
  late TextEditingController descricaoController;
  late bool ativo;
  late TextEditingController valorController;
  late TextEditingController saldoController;
  late TextEditingController eanController;

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final produto = widget.produto;

    nomeController = TextEditingController(text: produto['nome']);
    descricaoController = TextEditingController(text: produto['descricao']);
    ativo = produto['ativo'] ?? true;
    valorController = TextEditingController(text: produto['valor'].toString());
    saldoController = TextEditingController(text: produto['saldo'].toString());
    eanController = TextEditingController(text: produto['ean']);
  }

  Future<void> atualizarProduto() async {
    if (!_formKey.currentState!.validate()) return;

    final id = widget.produto['id'];

    final Map<String, dynamic> produtoAtualizado = {
      "id": id,
      "nome": nomeController.text.trim(),
      "descricao": descricaoController.text.trim(),
      "ativo": ativo,
      "valor": double.parse(valorController.text.trim()),
      "saldo": int.parse(saldoController.text.trim()),
      "ean": eanController.text.trim(),
    };

    final url = 'https://produtonetcoreapi-a3h3apdvdgfbaeg0.brazilsouth-01.azurewebsites.net/Produto/$id';

    setState(() => isLoading = true);

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(produtoAtualizado),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto atualizado com sucesso!')),
        );
        Navigator.pop(context, true); // volta com sucesso
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar: $e')),
      );
    } finally {
      setState(() => isLoading = false);
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
      appBar: AppBar(title: const Text('Atualizar Produto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) => value == null || value.isEmpty ? 'Informe a descrição' : null,
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
                keyboardType: TextInputType.number,
                validator: (value) => value == null || double.tryParse(value) == null
                    ? 'Valor inválido'
                    : null,
              ),
              TextFormField(
                controller: saldoController,
                decoration: const InputDecoration(labelText: 'Saldo'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || int.tryParse(value) == null
                    ? 'Saldo inválido'
                    : null,
              ),
              TextFormField(
                controller: eanController,
                decoration: const InputDecoration(labelText: 'EAN'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o EAN' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : atualizarProduto,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Salvar Atualização'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
