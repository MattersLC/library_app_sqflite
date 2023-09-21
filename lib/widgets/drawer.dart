import 'package:flutter/material.dart';
import 'package:flutter_library_app/util/responsive.dart';
import 'package:flutter_library_app/widgets/list_tile.dart';
import 'package:flutter_library_app/widgets/list_tile_composed.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:text_divider/text_divider.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onHomeTap;
  final void Function()? onBooksTap;
  final void Function()? onNewBookTap;
  final void Function()? onTopBooksTap;
  final void Function()? onStudentsTap;
  final void Function()? onNewStudentTap;
  final void Function()? onTopStudentsTap;
  final void Function()? onTeachersTap;
  final void Function()? onNewTeacherTap;
  final void Function()? onRequestsTap;
  final void Function()? onLateRequestsTap;
  final void Function()? onGenerateExcelTap;
  final void Function()? onDatabaseTap;
  const MyDrawer({
    super.key,
    required this.onHomeTap,
    required this.onBooksTap,
    required this.onNewBookTap,
    required this.onTopBooksTap,
    required this.onStudentsTap,
    required this.onNewStudentTap,
    required this.onTopStudentsTap,
    required this.onTeachersTap,
    required this.onNewTeacherTap,
    required this.onRequestsTap,
    required this.onLateRequestsTap,
    required this.onGenerateExcelTap,
    required this.onDatabaseTap,
  });

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    return Drawer(
      width: responsive.wp(70),
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/escuela.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.only(left: 20, bottom: 10),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 5.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
          MyListTile(
            width: responsive.wp(12),
            iconSize: responsive.dp(3.5),
            icon: Icons.home,
            fontSize: responsive.dp(1.8),
            title: 'Inicio',
            onTap: onHomeTap,
          ),
          TextDivider.horizontal(
            text: Text(
              'Libros',
              style: TextStyle(fontSize: responsive.dp(1.3)),
            ),
            color: Colors.grey,
            thickness: 2.0,
          ),
          MyListTile(
            width: responsive.wp(12),
            iconSize: responsive.dp(2.8),
            icon: FontAwesomeIcons.book,
            fontSize: responsive.dp(1.8),
            title: 'Libros',
            onTap: onBooksTap,
          ),
          MyListTileComposed(
            width: responsive.wp(12),
            iconSize: responsive.dp(2.8),
            icon: FontAwesomeIcons.book,
            secondIconSize: responsive.dp(1.8),
            secondIcon: Icons.add_circle,
            fontSize: responsive.dp(1.8),
            title: 'Nuevo libro',
            onTap: onNewBookTap,
          ),
          MyListTileComposed(
            width: responsive.wp(12),
            iconSize: responsive.dp(2.8),
            icon: FontAwesomeIcons.book,
            secondIconSize: responsive.dp(1.8),
            secondIcon: Icons.star,
            fontSize: responsive.dp(1.8),
            title: 'Top libros',
            onTap: onTopBooksTap,
          ),
          TextDivider.horizontal(
            text: Text(
              'Estudiantes',
              style: TextStyle(fontSize: responsive.dp(1.3)),
            ),
            color: Colors.grey,
            thickness: 2.0,
          ),
          MyListTile(
            width: responsive.wp(12),
            iconSize: responsive.dp(2.8),
            icon: FontAwesomeIcons.graduationCap,
            fontSize: responsive.dp(1.8),
            title: 'Estudiantes',
            onTap: onStudentsTap,
          ),
          MyListTileComposed(
            width: responsive.wp(12),
            iconSize: responsive.dp(2.8),
            icon: FontAwesomeIcons.graduationCap,
            secondIconSize: responsive.dp(1.8),
            secondIcon: Icons.add_circle,
            fontSize: responsive.dp(1.8),
            title: 'Nuevo estudiante',
            onTap: onNewStudentTap,
          ),
          MyListTileComposed(
            width: responsive.wp(12),
            iconSize: responsive.dp(2.8),
            icon: FontAwesomeIcons.graduationCap,
            secondIconSize: responsive.dp(1.8),
            secondIcon: Icons.star,
            fontSize: responsive.dp(1.8),
            title: 'Top estudiantes',
            onTap: onTopStudentsTap,
          ),
          TextDivider.horizontal(
            text: Text(
              'Docentes',
              style: TextStyle(fontSize: responsive.dp(1.3)),
            ),
            color: Colors.grey,
            thickness: 2.0,
          ),
          MyListTile(
            width: responsive.wp(12),
            iconSize: responsive.dp(2.8),
            icon: FontAwesomeIcons.userTie,
            fontSize: responsive.dp(1.8),
            title: 'Profesores',
            onTap: onTeachersTap,
          ),
          MyListTileComposed(
            width: responsive.wp(12),
            iconSize: responsive.dp(2.8),
            icon: FontAwesomeIcons.userTie,
            secondIconSize: responsive.dp(1.8),
            secondIcon: Icons.add_circle,
            fontSize: responsive.dp(1.8),
            title: 'Nuevo profesor',
            onTap: onNewTeacherTap,
          ),
          TextDivider.horizontal(
            text: Text(
              'Solicitudes',
              style: TextStyle(fontSize: responsive.dp(1.3)),
            ),
            color: Colors.grey,
            thickness: 2.0,
          ),
          MyListTile(
            width: responsive.wp(12),
            iconSize: responsive.dp(2.8),
            icon: FontAwesomeIcons.solidCalendar,
            fontSize: responsive.dp(1.8),
            title: 'Solicitudes',
            onTap: onRequestsTap,
          ),
          MyListTile(
            width: responsive.wp(12),
            iconSize: responsive.dp(2.8),
            icon: FontAwesomeIcons.solidCalendarXmark,
            fontSize: responsive.dp(1.8),
            title: 'Solicitudes tardías',
            onTap: onLateRequestsTap,
          ),
          TextDivider.horizontal(
            text: Text(
              'Extras',
              style: TextStyle(fontSize: responsive.dp(1.3)),
            ),
            color: Colors.grey,
            thickness: 2.0,
          ),
          MyListTile(
            width: responsive.wp(12),
            iconSize: responsive.dp(2.8),
            icon: FontAwesomeIcons.solidFileExcel,
            fontSize: responsive.dp(1.8),
            title: 'Generar Excel',
            onTap: onGenerateExcelTap,
          ),
          MyListTile(
            width: responsive.wp(12),
            iconSize: responsive.dp(2.8),
            icon: FontAwesomeIcons.database,
            fontSize: responsive.dp(1.8),
            title: 'Base de datos',
            onTap: onDatabaseTap,
          ),
        ],
      ),
    );
  }
}
