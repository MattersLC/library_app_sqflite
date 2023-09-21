import 'package:flutter/material.dart';
import 'package:flutter_library_app/models/estudiante.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../database/database.dart';

import 'package:flutter_emoji/flutter_emoji.dart';

import '../../util/responsive.dart';
import '../solicitudes/solicitudes_por_estudiante.dart';

class TopTenStudents extends StatefulWidget {
  const TopTenStudents({super.key});

  @override
  State<TopTenStudents> createState() => _TopTenStudentsState();
}

class _TopTenStudentsState extends State<TopTenStudents> {
  Future<List<Estudiante>>? _topTenStudentsFuture;
  var parser = EmojiParser();
  Responsive? responsive;

  @override
  void initState() {
    super.initState();
    _topTenStudentsFuture = DatabaseHelper.getTopTenStudents();
  }

  @override
  Widget build(BuildContext context) {
    responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Top 10 estudiantes lectores',
            style:
                TextStyle(color: Colors.white, fontSize: responsive!.dp(2.6))),
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
      ),
      body: FutureBuilder<List<Estudiante>>(
        future: _topTenStudentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var students = snapshot.data;
            return AnimationLimiter(
              child: ListView.builder(
                itemCount: students!.length,
                itemBuilder: (BuildContext context, int index) {
                  Estudiante student = students[index];
                  Widget rankWidget;

                  if (index == 0) {
                    rankWidget = Text(parser.get('first_place_medal').code,
                        style: TextStyle(fontSize: responsive!.dp(7))); // oro
                  } else if (index == 1) {
                    rankWidget = Text(parser.get('second_place_medal').code,
                        style: TextStyle(fontSize: responsive!.dp(6))); // plata
                  } else if (index == 2) {
                    rankWidget = Text(parser.get('third_place_medal').code,
                        style:
                            TextStyle(fontSize: responsive!.dp(5))); // bronce
                  } else {
                    rankWidget = Text('${index + 1}º',
                        style: TextStyle(fontSize: responsive!.dp(4)));
                  }

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SolicitudesPorEstudiante(
                                              numControl: student.numControl,
                                              type: 'total'),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: responsive!.wp(15),
                                      height: responsive!.hp(11),
                                      child: Center(child: rankWidget),
                                    ),
                                    SizedBox(width: responsive!.wp(3)),
                                    Icon(
                                      Icons.person,
                                      size: responsive!.dp(6),
                                    ),
                                    SizedBox(width: responsive!.wp(3)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${student.nombre} ${student.apellidoPaterno} ${student.apellidoMaterno}',
                                              style: TextStyle(
                                                  fontSize: responsive!.dp(2))),
                                          Text(
                                              'Grado: ${student.grado} - Grupo: ${student.grupo}',
                                              style: TextStyle(
                                                  fontSize: responsive!.dp(2))),
                                          Text(
                                              'Libros Leídos: ${student.librosLeidos}',
                                              style: TextStyle(
                                                  fontSize: responsive!.dp(2))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
