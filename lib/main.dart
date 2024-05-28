import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importe o pacote Services
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));
}

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Variáveis para armazenar os valores dos campos de entrada
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  String email = '';
  String senha = '';

  // Referência para a coleção de usuários no Firestore
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(27),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Color(0xff6940ff)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Text(
              "Economizando",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              "Digite os dados de acesso nos campos abaixo.",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 30),
            _buildTextField(context, "Digite o seu e-mail", emailController,
                onChanged: (value) {
              setState(() {
                email =
                    value; // Atualize a variável email conforme o usuário digita
              });
            }),
            const SizedBox(height: 5),
            _buildTextField(context, "Digite sua senha", senhaController,
                obscureText: true, onChanged: (value) {
              setState(() {
                senha =
                    value; // Atualize a variável senha conforme o usuário digita
              });
            }),
            const SizedBox(height: 30),
            _buildButton(context, "Acessar", () {
              _showDialog(context, 'Acesso',
                  'Bem vindo(a)! Email: $email, Senha: $senha');

              // Enviar os dados do usuário para o Firestore
              _addUser(email, senha);
            }),
            const SizedBox(height: 7),
            _buildButton(context, "Crie sua conta", () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Cadastro()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String placeholder,
      TextEditingController controller,
      {bool obscureText = false, Function(String)? onChanged}) {
    return TextField(
      controller: controller,
      cursorColor: const Color(0xff000000),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
        filled: true,
        fillColor: Colors.black12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }

  Widget _buildButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.greenAccent,
          onPrimary: Colors.black45,
          padding: const EdgeInsets.all(17),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Janeiro()));
              },
              child: const Text("Continuar"),
            ),
          ],
        );
      },
    );
  }

  // Função para adicionar um usuário ao Firestore
  Future<void> _addUser(String email, String senha) {
    // Adicione os dados do usuário à coleção 'users'
    return users
        .add({
          'email': email,
          'senha': senha,
        })
        .then((value) => print("Usuário adicionado com ID: ${value.id}"))
        .catchError((error) => print("Erro ao adicionar usuário: $error"));
  }
}

class Cadastro extends StatefulWidget {
  Cadastro({Key? key}) : super(key: key);

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  // Controladores para os campos de texto
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController repetirSenhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(27),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Color(0xff6940ff)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Preencha os campos abaixo com seus dados",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 30),
            _buildTextField(
              context,
              "Digite o seu nome",
              nomeController,
            ),
            const SizedBox(height: 5),
            _buildTextField(
              context,
              "Digite seu e-mail",
              emailController,
              onChanged: (value) {
                // Você pode adicionar lógica aqui para lidar com a alteração do campo de e-mail
              },
            ),
            const SizedBox(height: 5),
            _buildTextField(
              context,
              "Digite sua senha",
              senhaController,
              obscureText: true,
              onChanged: (value) {
                // Você pode adicionar lógica aqui para lidar com a alteração do campo de senha
              },
            ),
            const SizedBox(height: 5),
            _buildTextField(
              context,
              "Repita sua senha",
              repetirSenhaController,
              obscureText: true,
              onChanged: (value) {
                // Você pode adicionar lógica aqui para lidar com a alteração do campo de repetir senha
              },
            ),
            const SizedBox(height: 30),
            _buildButton(context, "Acessar", () {
              _showDialog(context, 'Acesso',
                  '${nomeController.text} finalizou seu cadastro!');
            }),
            const SizedBox(height: 7),
            _buildButton(context, "Voltar", () {
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String placeholder,
      TextEditingController controller,
      {bool obscureText = false, Function(String)? onChanged}) {
    return TextField(
      controller: controller,
      cursorColor: const Color(0xff000000),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
        filled: true,
        fillColor: Colors.black12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }

  Widget _buildButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.greenAccent,
          onPrimary: Colors.black45,
          padding: const EdgeInsets.all(17),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Janeiro()));
              },
              child: const Text("Continuar"),
            ),
          ],
        );
      },
    );
  }
}

class Task {
  final String titulo;
  final String valor;

  Task({required this.titulo, required this.valor});
}

class Janeiro extends StatefulWidget {
  Janeiro({Key? key}) : super(key: key);

  @override
  _JaneiroState createState() => _JaneiroState();
}

class _JaneiroState extends State<Janeiro> {
  List<Task> tasks = [];

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _showAddTaskDialog(BuildContext context) {
    String titulo = '';
    String valor = '';

    showDialog(
      context: context,
      builder: (context) {
        TextEditingController tituloController = TextEditingController();
        TextEditingController valorController = TextEditingController();

        return AlertDialog(
          title: Text('Adicionar Despesas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle:
                      TextStyle(color: Color(0xff000000)), // Cor do título
                ),
                style: TextStyle(color: Color(0xff000000)), // Cor do texto
                onChanged: (value) {
                  titulo = value;
                },
              ),
              TextField(
                controller: valorController,
                decoration: InputDecoration(
                  labelText: 'Valor',
                  labelStyle:
                      TextStyle(color: Color(0xff000000)), // Cor do título
                ),
                style: TextStyle(color: Color(0xff000000)), // Cor do texto
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true), // Apenas números e ponto
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*[\.,]?\d{0,2}'))
                ], // Formato de dinheiro com até duas casas decimais
                onChanged: (value) {
                  valor = value.replaceAll(
                      ',', '.'); // Substituir vírgula por ponto
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (titulo.isNotEmpty && valor.isNotEmpty) {
                  setState(() {
                    tasks.add(Task(titulo: titulo, valor: 'R\$ $valor'));
                  });
                  Navigator.of(context)
                      .pop(); // Fecha o diálogo após adicionar a despesa
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Despesa adicionada com sucesso!'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, preencha todos os campos.'),
                    ),
                  );
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task, int index) {
    _tituloController.text = task.titulo;
    _valorController.text = task.valor.substring(3); // Remove o "R$ "

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Despesa'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _tituloController,
                    decoration: InputDecoration(
                      labelText: 'Título',
                      labelStyle:
                          TextStyle(color: Color(0xff000000)), // Cor do título
                    ),
                    style: TextStyle(color: Color(0xff000000)), // Cor do texto
                    onChanged: (value) {
                      // Não é necessário atualizar a variável titulo
                    },
                  ),
                  TextField(
                    controller: _valorController,
                    decoration: InputDecoration(
                      labelText: 'Valor',
                      labelStyle:
                          TextStyle(color: Color(0xff000000)), // Cor do título
                    ),
                    style: TextStyle(color: Color(0xff000000)), // Cor do texto
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true), // Apenas números e ponto
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*[\.,]?\d{0,2}'))
                    ], // Formato de dinheiro com até duas casas decimais
                    onChanged: (value) {
                      // Não é necessário atualizar a variável valor
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                String titulo = _tituloController.text;
                String valor = 'R\$ ${_valorController.text}';

                if (titulo.isNotEmpty && valor.isNotEmpty) {
                  setState(() {
                    tasks[index] = Task(titulo: titulo, valor: valor);
                  });
                  Navigator.of(context)
                      .pop(); // Fecha o diálogo após editar a despesa
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Despesa editada com sucesso!'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, preencha todos os campos.'),
                    ),
                  );
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Janeiro'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Fevereiro()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Color(0xff6940ff)],
          ),
        ),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Dismissible(
              key: Key(task.titulo),
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  _showEditTaskDialog(context, task, index);
                } else if (direction == DismissDirection.startToEnd) {
                  setState(() {
                    tasks.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Despesa removida'),
                    ),
                  );
                }
              },
              background: Container(
                color: Colors.red,
                child: Icon(Icons.delete),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
              ),
              secondaryBackground: Container(
                color: Colors.blue,
                child: Icon(Icons.edit),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20),
              ),
              confirmDismiss: (direction) async {
                return true; // Permite que o usuário arraste para qualquer direção para editar ou excluir
              },
              child: ListTile(
                title: Text(
                  task.titulo,
                  style: TextStyle(color: Colors.white), // Cor do título
                ),
                subtitle: Text(
                  task.valor,
                  style: TextStyle(color: Colors.white), // Cor do valor
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _buildTextField {}

class Fevereiro extends StatefulWidget {
  Fevereiro({Key? key}) : super(key: key);

  @override
  _FevereiroState createState() => _FevereiroState();
}

class _FevereiroState extends State<Fevereiro> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
  }

  void _showAddTaskDialog(BuildContext context) {
    String titulo = '';
    String valor = '';

    showDialog(
      context: context,
      builder: (context) {
        TextEditingController tituloController = TextEditingController();
        TextEditingController valorController = TextEditingController();

        return AlertDialog(
          title: Text('Adicionar Despesas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle:
                      TextStyle(color: Color(0xff000000)), // Cor do título
                ),
                style: TextStyle(color: Color(0xff000000)), // Cor do texto
                onChanged: (value) {
                  titulo = value;
                },
              ),
              TextField(
                controller: valorController,
                decoration: InputDecoration(
                  labelText: 'Valor',
                  labelStyle:
                      TextStyle(color: Color(0xff000000)), // Cor do título
                ),
                style: TextStyle(color: Color(0xff000000)), // Cor do texto
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true), // Apenas números e ponto
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*[\.,]?\d{0,2}'))
                ], // Formato de dinheiro com até duas casas decimais
                onChanged: (value) {
                  valor = value.replaceAll(
                      ',', '.'); // Substituir vírgula por ponto
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (titulo.isNotEmpty && valor.isNotEmpty) {
                  setState(() {
                    tasks.add(Task(titulo: titulo, valor: 'R\$ $valor'));
                  });
                  Navigator.of(context)
                      .pop(); // Fecha o diálogo após adicionar a despesa
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Despesa adicionada com sucesso!'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, preencha todos os campos.'),
                    ),
                  );
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task, int index) {
    String titulo = task.titulo;
    String valor = task.valor.substring(3); // Remove o "R$ "

    showDialog(
      context: context,
      builder: (context) {
        TextEditingController tituloController =
            TextEditingController(text: titulo);
        TextEditingController valorController =
            TextEditingController(text: valor);

        return AlertDialog(
          title: Text('Editar Despesa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle:
                      TextStyle(color: Color(0xff000000)), // Cor do título
                ),
                style: TextStyle(color: Color(0xff000000)), // Cor do texto
                onChanged: (value) {
                  titulo = value;
                },
              ),
              TextField(
                controller: valorController,
                decoration: InputDecoration(
                  labelText: 'Valor',
                  labelStyle:
                      TextStyle(color: Color(0xff000000)), // Cor do título
                ),
                style: TextStyle(color: Color(0xff000000)), // Cor do texto
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true), // Apenas números e ponto
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*[\.,]?\d{0,2}'))
                ], // Formato de dinheiro com até duas casas decimais
                onChanged: (value) {
                  valor = value.replaceAll(
                      ',', '.'); // Substituir vírgula por ponto
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (titulo.isNotEmpty && valor.isNotEmpty) {
                  setState(() {
                    tasks[index] = Task(titulo: titulo, valor: 'R\$ $valor');
                  });
                  Navigator.of(context)
                      .pop(); // Fecha o diálogo após editar a despesa
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Despesa editada com sucesso!'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, preencha todos os campos.'),
                    ),
                  );
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Fevereiro'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Marco()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Color(0xff6940ff)],
          ),
        ),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Dismissible(
              key: Key(task.titulo),
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  _showEditTaskDialog(context, task, index);
                } else if (direction == DismissDirection.startToEnd) {
                  setState(() {
                    tasks.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Despesa removida'),
                    ),
                  );
                }
              },
              background: Container(
                color: Colors.red,
                child: Icon(Icons.delete),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
              ),
              secondaryBackground: Container(
                color: Colors.blue,
                child: Icon(Icons.edit),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20),
              ),
              confirmDismiss: (direction) async {
                return true; // Permite que o usuário arraste para qualquer direção para editar ou excluir
              },
              child: ListTile(
                title: Text(
                  task.titulo,
                  style: TextStyle(color: Colors.white), // Cor do título
                ),
                subtitle: Text(
                  task.valor,
                  style: TextStyle(color: Colors.white), // Cor do valor
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class Marco extends StatefulWidget {
  Marco({Key? key}) : super(key: key);

  @override
  _MarcoState createState() => _MarcoState();
}

class _MarcoState extends State<Marco> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
  }

  void _showAddTaskDialog(BuildContext context) {
    String titulo = '';
    String valor = '';

    showDialog(
      context: context,
      builder: (context) {
        TextEditingController tituloController = TextEditingController();
        TextEditingController valorController = TextEditingController();

        return AlertDialog(
          title: Text('Adicionar Despesas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle:
                      TextStyle(color: Color(0xff000000)), // Cor do título
                ),
                style: TextStyle(color: Color(0xff000000)), // Cor do texto
                onChanged: (value) {
                  titulo = value;
                },
              ),
              TextField(
                controller: valorController,
                decoration: InputDecoration(
                  labelText: 'Valor',
                  labelStyle:
                      TextStyle(color: Color(0xff000000)), // Cor do título
                ),
                style: TextStyle(color: Color(0xff000000)), // Cor do texto
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true), // Apenas números e ponto
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*[\.,]?\d{0,2}'))
                ], // Formato de dinheiro com até duas casas decimais
                onChanged: (value) {
                  valor = value.replaceAll(
                      ',', '.'); // Substituir vírgula por ponto
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (titulo.isNotEmpty && valor.isNotEmpty) {
                  setState(() {
                    tasks.add(Task(titulo: titulo, valor: 'R\$ $valor'));
                  });
                  Navigator.of(context)
                      .pop(); // Fecha o diálogo após adicionar a despesa
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Despesa adicionada com sucesso!'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, preencha todos os campos.'),
                    ),
                  );
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task, int index) {
    String titulo = task.titulo;
    String valor = task.valor.substring(3); // Remove o "R$ "

    showDialog(
      context: context,
      builder: (context) {
        TextEditingController tituloController =
            TextEditingController(text: titulo);
        TextEditingController valorController =
            TextEditingController(text: valor);

        return AlertDialog(
          title: Text('Editar Despesa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle:
                      TextStyle(color: Color(0xff000000)), // Cor do título
                ),
                style: TextStyle(color: Color(0xff000000)), // Cor do texto
                onChanged: (value) {
                  titulo = value;
                },
              ),
              TextField(
                controller: valorController,
                decoration: InputDecoration(
                  labelText: 'Valor',
                  labelStyle:
                      TextStyle(color: Color(0xff000000)), // Cor do título
                ),
                style: TextStyle(color: Color(0xff000000)), // Cor do texto
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true), // Apenas números e ponto
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*[\.,]?\d{0,2}'))
                ], // Formato de dinheiro com até duas casas decimais
                onChanged: (value) {
                  valor = value.replaceAll(
                      ',', '.'); // Substituir vírgula por ponto
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (titulo.isNotEmpty && valor.isNotEmpty) {
                  setState(() {
                    tasks[index] = Task(titulo: titulo, valor: 'R\$ $valor');
                  });
                  Navigator.of(context)
                      .pop(); // Fecha o diálogo após editar a despesa
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Despesa editada com sucesso!'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, preencha todos os campos.'),
                    ),
                  );
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Março'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Abril()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Color(0xff6940ff)],
          ),
        ),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Dismissible(
              key: Key(task.titulo),
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  _showEditTaskDialog(context, task, index);
                } else if (direction == DismissDirection.startToEnd) {
                  setState(() {
                    tasks.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Despesa removida'),
                    ),
                  );
                }
              },
              background: Container(
                color: Colors.red,
                child: Icon(Icons.delete),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
              ),
              secondaryBackground: Container(
                color: Colors.blue,
                child: Icon(Icons.edit),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20),
              ),
              confirmDismiss: (direction) async {
                return true; // Permite que o usuário arraste para qualquer direção para editar ou excluir
              },
              child: ListTile(
                title: Text(
                  task.titulo,
                  style: TextStyle(color: Colors.white), // Cor do título
                ),
                subtitle: Text(
                  task.valor,
                  style: TextStyle(color: Colors.white), // Cor do valor
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class Abril extends StatelessWidget {
  Abril({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Color(0xff6940ff)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Marco()));
                      },
                    ),
                    Expanded(
                      child: Text(
                        "Abril",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => Maio()));
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: const [
                    Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Maio extends StatelessWidget {
  Maio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Color(0xff6940ff)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Abril()));
                      },
                    ),
                    Expanded(
                      child: Text(
                        "Maio",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Junho()));
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: const [
                    Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Junho extends StatelessWidget {
  Junho({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Color(0xff6940ff)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => Maio()));
                      },
                    ),
                    Expanded(
                      child: Text(
                        "Junho",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Julho()));
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: const [
                    Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Julho extends StatelessWidget {
  Julho({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Color(0xff6940ff)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Junho()));
                      },
                    ),
                    Expanded(
                      child: Text(
                        "Julho",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Agosto()));
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: const [
                    Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Agosto extends StatelessWidget {
  Agosto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Color(0xff6940ff)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Julho()));
                      },
                    ),
                    Expanded(
                      child: Text(
                        "Agosto",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Setembro()));
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: const [
                    Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Setembro extends StatelessWidget {
  Setembro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Color(0xff6940ff)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Agosto()));
                      },
                    ),
                    Expanded(
                      child: Text(
                        "Setembro",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Outubro()));
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: const [
                    Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Outubro extends StatelessWidget {
  Outubro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Color(0xff6940ff)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Setembro()));
                      },
                    ),
                    Expanded(
                      child: Text(
                        "Outubro",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Novembro()));
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: const [
                    Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Novembro extends StatelessWidget {
  Novembro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Color(0xff6940ff)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Outubro()));
                      },
                    ),
                    Expanded(
                      child: Text(
                        "Novembro",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Dezembro()));
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: const [
                    Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Dezembro extends StatelessWidget {
  Dezembro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Color(0xff6940ff)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Novembro()));
                      },
                    ),
                    Expanded(
                      child: Text(
                        "Dezembro",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Janeiro()));
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: const [
                    Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
