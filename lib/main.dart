import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'AtualizarProduto.dart';
import 'CriarProduto.dart';
import 'ResultadoPesquisa.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Produto Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(enabled: true),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.enabled});
  final bool enabled;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String resultado = 'Resultado aparecerá aqui';
  final TextEditingController _controller = TextEditingController();

  Future<void> fazerPesquisa({String? codigoProduto}) async {
    setState(() {
      resultado = 'Pesquisando...';
    });

    final baseUrl = 'coloque seu link aqui junto do sufixo a seguir /Produto';
    // Exemplo de base Url : https://api123.net/Produto
    final url = (codigoProduto != null && codigoProduto.isNotEmpty)
        ? Uri.parse('$baseUrl?id=$codigoProduto')
        : Uri.parse(baseUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is List && jsonData.isNotEmpty) {
          setState(() {
            resultado = ''; // Limpa ANTES de sair da tela
          });
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultadoPesquisa(produtos: jsonData),
            ),
          );
        } else if (jsonData is Map && jsonData.isNotEmpty) {
          setState(() {
            resultado = '';
          });
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultadoPesquisa(produtos: [jsonData]),
            ),
          );
        } else {
          setState(() {
            resultado = 'Nenhum produto encontrado.';
          });
        }
      } else {
        setState(() {
          resultado = 'Erro ${response.statusCode}: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        resultado = 'Erro na requisição: $e';
      });
    }
  }

  Future<void> _buscarProdutoParaAtualizar(String id) async {
    final url =
        'https://produtonetcoreapi-a3h3apdvdgfbaeg0.brazilsouth-01.azurewebsites.net/Produto?id=$id';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(json.decode(response.body));
        if (data is Map && data.isNotEmpty) {
          final resultadoAtualizacao = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => AtualizarProduto(produto: data),
            ),
          );
          if (resultadoAtualizacao == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Produto atualizado com sucesso!')),
            );
            setState(() {
              resultado = '';
            });
          }
        } else {
          _mostrarErro('Produto não encontrado.');
        }
      } else {
        _mostrarErro('Erro ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      _mostrarErro('Erro ao buscar produto: $e');
    }
  }

  Future<void> _deletarProduto(String id) async {
    final url = 'https://produtonetcoreapi-a3h3apdvdgfbaeg0.brazilsouth-01.azurewebsites.net/Produto/$id';

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produto $id deletado com sucesso!')),
        );
        setState(() {
          resultado = ''; // limpa mensagem antiga
        });
      } else if (response.statusCode == 404) {
        _mostrarErro('Produto com ID $id não encontrado.');
      } else {
        _mostrarErro('Erro ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      _mostrarErro('Erro ao deletar: $e');
    }
  }


  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  void mostrarDialogoPesquisa() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Deseja informar um produto específico?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                mostrarCampoProduto();
              },
              child: const Text('Sim'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                fazerPesquisa();
              },
              child: const Text('Não'),
            ),
          ],
        );
      },
    );
  }

  void mostrarCampoProduto() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Informe o código do produto'),
          content: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Código do produto',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final codigo = _controller.text.trim();
                Navigator.pop(context);
                fazerPesquisa(codigoProduto: codigo);
              },
              child: const Text('Pesquisar'),
            ),
          ],
        );
      },
    );
  }

  void _solicitarIdParaAtualizacao() {
    final TextEditingController idController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Informe o ID do produto para atualizar'),
          content: TextField(
            controller: idController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'ID'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final id = idController.text.trim();

                if (id.isNotEmpty) {
                  await _buscarProdutoParaAtualizar(id);
                }
              },
              child: const Text('Buscar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmarDelecao() {
    final TextEditingController idController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Informe o ID do produto a deletar'),
          content: TextField(
            controller: idController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'ID'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final id = idController.text.trim();
                Navigator.pop(context);

                if (id.isNotEmpty) {
                  _mostrarConfirmacaoDelecao(id);
                }
              },
              child: const Text('Avançar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarConfirmacaoDelecao(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Deleção'),
          content: Text('Tem certeza que deseja deletar o produto com ID $id?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deletarProduto(id);
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final largura = size.width;
    final altura = size.height;
    final VoidCallback? onPressed = widget.enabled ? () {} : null;

    final ButtonStyle estiloBotao = FilledButton.styleFrom(
      minimumSize: Size(largura * 0.9, altura * 0.05),
      backgroundColor: Colors.orangeAccent,
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: largura,
            height: altura,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade400, Colors.deepOrange.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: largura * 0.20,
                vertical: altura * 0.10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FilledButton(
                    onPressed: mostrarDialogoPesquisa,
                    child: const Text('Pesquisa'),
                    style: estiloBotao,
                  ),
                  FilledButton(
                    onPressed: widget.enabled
                        ? () async {
                      final resultadoCriacao = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(builder: (_) => const CriarProduto()),
                      );
                      if (resultadoCriacao == true) {
                        setState(() {
                          resultado = '';
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Produto criado com sucesso!')),
                        );
                      }
                    } : null,
                    child: const Text('Criação'),
                    style: estiloBotao,
                  ),
                  FilledButton(
                    onPressed: widget.enabled ? () => _solicitarIdParaAtualizacao() : null,
                    child: const Text('Atualização'),
                    style: estiloBotao,
                  ),
                  FilledButton(
                    onPressed: widget.enabled ? _confirmarDelecao : null,
                    child: const Text('Deleção'),
                    style: estiloBotao,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    resultado,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
