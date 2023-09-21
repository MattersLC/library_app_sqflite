import 'package:flutter/material.dart';
import 'package:flutter_library_app/widgets/drawer.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_library_app/util/responsive.dart';
//m
//import 'package:text_divider/text_divider.dart';

import '../../database/database.dart';
import '../../models/libro.dart';
import '../busqueda/busqueda.dart';
import 'components/interface_home.dart';

class _HomePageState extends State<HomePage> {
  List<Libro>? _libros = [];
  Responsive? responsive;

  @override
  void initState() {
    super.initState();
    _getLibrosFromDatabase();
    initialization();
  }

  void initialization() async {
    FlutterNativeSplash.remove();
  }

  Future<void> _getLibrosFromDatabase() async {
    final libros = await DatabaseHelper.getAllLibros();
    setState(() {
      if (_libros != null) {
        _libros = libros;
      }
    });
  }

  void goToHomePage() {
    // pop menu drawer
    Navigator.pop(context);
    // go to profile page
    Navigator.pushNamed(context, 'home');
  }

  void goToBooksPage() {
    // pop menu drawer
    Navigator.pop(context);
    // go to profile page
    Navigator.pushNamed(context, 'librosPage');
  }

  void goToPage(String route) {
    // pop menu drawer
    Navigator.pop(context);
    // go to profile page
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    responsive = Responsive.of(context);
    return Container(
      decoration: gradienteDePagina,
      child: Scaffold(
        appBar: buildAppBar(context),
        backgroundColor: Colors.transparent,
        body: InterfaceHome(libros: _libros),
        drawer: MyDrawer(
          onHomeTap: goToHomePage,
          onBooksTap: goToBooksPage,
          onNewBookTap: () => goToPage('nuevoLibro'),
          onTopBooksTap: () => goToPage('topLibros'),
          onStudentsTap: () => goToPage('estudiantesPage'),
          onNewStudentTap: () => goToPage('nuevoEstudiante'),
          onTopStudentsTap: () => goToPage('topEstudiantes'),
          onTeachersTap: () => goToPage('docentesPage'),
          onNewTeacherTap: () => goToPage('nuevoDocente'),
          onRequestsTap: () => goToPage('solicitudesPage'),
          onLateRequestsTap: () => goToPage('solicitudesRetrasadas'),
          onGenerateExcelTap: () => goToPage('booksToExcelPage'),
          onDatabaseTap: () => goToPage('exportDatabase'),
        ),
      ),
    );
  }
}

AppBar buildAppBar(BuildContext context) {
  final Responsive responsive = Responsive.of(context);
  return AppBar(
    centerTitle: true,
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: Icon(
            Icons.menu, // Icono del menú
            size: responsive.dp(3), // Cambiar el tamaño del icono aquí
          ),
          onPressed: () {
            // Abrir el Drawer
            Scaffold.of(context).openDrawer();
          },
        );
      },
    ),
    title: Column(
      children: [
        const SizedBox(height: 2),
        Material(
          type: MaterialType.transparency,
          child: Column(
            children: [
              Text(
                'BIBLIOTECA ESCOLAR',
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: responsive.dp(2.1),
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                'PRIMARIA VALENTÍN GÓMEZ FARÍAS',
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: responsive.dp(1.6),
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    backgroundColor: Colors.blue,
    elevation: 3,
    // Busqueda
    actions: <Widget>[
      Padding(
        padding: EdgeInsets.only(right: responsive.wp(2), top: 5.0),
        child: IconButton(
          icon: Icon(
            Icons.search,
            size: responsive.dp(3),
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BusquedaPage(),
              ),
            );
          },
        ),
      ),
    ],
    // Ajustar la altura del AppBar según el ancho de la pantalla
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(responsive.dp(1)),
      child: const SizedBox.shrink(),
    ),
  );
}

const gradienteDePagina = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white,
      Color.fromRGBO(239, 241, 248, 1),
    ],
  ),
);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class BirretePlusIcon extends StatelessWidget {
  const BirretePlusIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Icon(
          FontAwesomeIcons.graduationCap,
          size: 24.0,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              size: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}
