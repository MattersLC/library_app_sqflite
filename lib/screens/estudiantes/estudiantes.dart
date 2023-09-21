import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_library_app/screens/solicitudes/solicitudes_por_estudiante.dart';
import '../../util/responsive.dart';

import '../../database/database.dart';
import '../../models/estudiante.dart';
import '../busqueda/busqueda.dart';

class EstudiantesPage extends StatefulWidget {
  const EstudiantesPage({super.key});

  @override
  State<EstudiantesPage> createState() => _EstudiantesPageState();
}

class _EstudiantesPageState extends State<EstudiantesPage> {
  List<Estudiante> _estudiantesPage = [];
  final List<bool> _gradePanelExpanded = List.generate(6, (index) => false);
  Responsive? responsive;

  @override
  void initState() {
    super.initState();
    _getEstudiantes();
  }

  Future<void> _getEstudiantes() async {
    final estudiantes = await DatabaseHelper.getAllEstudiantes();
    if (estudiantes != null) {
      setState(() {
        _estudiantesPage = estudiantes;
      });
    }
  }

  List<ExpansionPanel> _buildGradePanels() {
    List<ExpansionPanel> gradePanels = [];

    for (int i = 1; i <= 6; i++) {
      String grade = '$i°'; // Cambia el formato del grado aquí

      List<Estudiante> gradeStudents = _estudiantesPage
          .where((estudiante) =>
              estudiante.grado ==
              grade) // Compara con 'grade' en el formato correcto
          .toList();

      gradePanels.add(ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            title: Text(
              'Grado $grade',
              style: TextStyle(fontSize: responsive!.dp(3)),
            ),
          );
        },
        body: Column(
          children: _buildGroupListTiles(gradeStudents),
        ),
        isExpanded: _gradePanelExpanded[i - 1],
      ));
    }

    return gradePanels;
  }

  List<Widget> _buildGroupListTiles(List<Estudiante> gradeStudents) {
    List<Widget> groupListTiles = [];
    List<String> groups = ['A', 'B', 'C'];

    for (String group in groups) {
      List<Estudiante> groupStudents = gradeStudents
          .where((estudiante) => estudiante.grupo == group)
          .toList();

      groupListTiles.add(ExpansionTile(
        title: Text(
          'Grupo $group',
          style: TextStyle(fontSize: responsive!.dp(2.3)),
        ),
        children: groupStudents
            .map((estudiante) => estudiantesTile(estudiante))
            .toList(),
      ));
    }

    return groupListTiles;
  }

  @override
  Widget build(BuildContext context) {
    responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Estudiantes',
            style:
                TextStyle(color: Colors.white, fontSize: responsive!.dp(2.8))),
        backgroundColor: Colors.blue,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: responsive!.dp(2.8)),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              'home', // Reemplaza 'ruta_inicial' con el nombre de la ruta de la página inicial
              (Route<dynamic> route) => false,
            );
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.search, size: responsive!.dp(2.8)),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      //** Redireciona o utilizador para a página de detalhes do livro */
                      //builder: (context) => const BusquedaDeLibro(),
                      builder: (context) => const BusquedaPage()),
                );
              },
            ),
          ),
        ],
      ),
      body: _estudiantesPage.isEmpty
          ? Center(
              child: Text(
                'Sin estudiantes para mostrar',
                style: TextStyle(fontSize: responsive!.dp(2.5)),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _gradePanelExpanded[index] = !isExpanded;
                    });
                  },
                  children: _buildGradePanels(),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        onPressed: () {
          Navigator.pushNamed(context, 'nuevoEstudiante');
        },
        child: Icon(Icons.add, size: responsive!.dp(2.8)),
      ),
    );
  }

  Widget estudiantesTile(Estudiante estudiante) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(
          Icons.person,
          size: responsive!.dp(6),
        ),
        title: Text(
          "${estudiante.nombre} ${estudiante.apellidoPaterno} ${estudiante.apellidoMaterno}",
          style: TextStyle(fontSize: responsive!.dp(1.8)),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              estudiante.numControl,
              style: TextStyle(fontSize: responsive!.dp(1.8)),
            ),
            Text(
              "${estudiante.grado} - ${estudiante.grupo}",
              style: TextStyle(fontSize: responsive!.dp(1.8)),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SolicitudesPorEstudiante(
                      numControl: estudiante.numControl, type: 'total')));
        },
        trailing: IconButton(
          icon: Icon(Icons.delete, size: responsive!.dp(2.8)),
          onPressed: () => deleteEstudiante(estudiante),
        ),
      ),
    );
  }

  // MODIFICAR -> Antes de eliminar deslizando, preguntar si está seguro de eliminar
  deleteEstudiante(Estudiante estudiante) {
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('¿Estás seguro de eliminar a este estudiante?'),
            actions: <Widget>[
              MaterialButton(
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancelar'),
              ),
              MaterialButton(
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () async {
                  await DatabaseHelper.deleteEstudiante(estudiante);
                  setState(() {
                    _estudiantesPage.remove(estudiante);
                    Navigator.of(context).pop(true);
                  });
                },
                child: const Text('Eliminar'),
              )
            ],
          );
        },
      ).then((confirmed) {
        if (!confirmed) {
          setState(() {});
        }
      });
    }

    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: const Text('¿Estás seguro de eliminar a este docente?'),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                await DatabaseHelper.deleteEstudiante(estudiante);
                setState(() {
                  _estudiantesPage.remove(estudiante);
                  Navigator.of(context).pop(true);
                });
              },
              child: const Text('Add'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            )
          ],
        );
      },
    );
  }
}
