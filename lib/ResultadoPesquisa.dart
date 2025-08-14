import 'package:flutter/material.dart';

class ResultadoPesquisa extends StatelessWidget {
  final List<dynamic> produtos;

  const ResultadoPesquisa({super.key, required this.produtos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado da Pesquisa')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: produtos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 colunas
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            final produto = produtos[index];

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(produto['nome'] ?? 'Sem nome', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),
                    Text(produto['descricao'] ?? 'Sem descrição', maxLines: 3, overflow: TextOverflow.ellipsis),
                    const Spacer(),
                    Text('Valor: R\$ ${produto['valor'].toStringAsFixed(2)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    Text('Saldo: ${produto['saldo']}', style: const TextStyle(color: Colors.blueGrey)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
