import 'dart:convert';

import 'package:flutter/material.dart';

import '../../database/database.dart';
import '../../models/docente.dart';
import '../../models/estudiante.dart';
import '../../models/libro.dart';
import '../../util/responsive.dart';
import '../books/libro_detallado/libro_detallado.dart';
import '../solicitudes/solicitudes_por_estudiante.dart';
import 'components/filtros_busqueda.dart';

class BusquedaPage extends StatefulWidget {
  const BusquedaPage({Key? key}) : super(key: key);

  @override
  State<BusquedaPage> createState() => _BusquedaPageState();
}

class _BusquedaPageState extends State<BusquedaPage> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'Libro';
  List<dynamic> _searchResults = [];
  Responsive? responsive;

  void _handleSearch() async {
    String searchText = _searchController.text;

    if (searchText.isEmpty) {
      return;
    }

    if (_selectedFilter == 'Libro') {
      List<Libro> libros = await DatabaseHelper.searchLibros(searchText);
      setState(() {
        _searchResults = libros;
      });
    } else if (_selectedFilter == 'Estudiante') {
      List<Estudiante> estudiantes =
          await DatabaseHelper.searchEstudiantes(searchText);
      setState(() {
        _searchResults = estudiantes;
      });
    } else if (_selectedFilter == 'Docente') {
      List<Docente> docentes = await DatabaseHelper.searchDocentes(searchText);
      setState(() {
        _searchResults = docentes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar',
            style:
                TextStyle(color: Colors.white, fontSize: responsive!.dp(2.8))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: responsive!.dp(2.8)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 750),
            child: Column(
              children: [
                TextFormField(
                  controller: _searchController,
                  style: TextStyle(fontSize: responsive!.dp(2.0)),
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(Icons.search,
                          color: Colors.black, size: responsive!.dp(2.8)),
                    ),
                    hintText: 'Escriba el elemento a buscar...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (value) {
                    _handleSearch();
                  },
                ),
                SizedBox(height: responsive!.hp(2)),
                FiltrosDeBusqueda(
                  onFiltroChanged: (filtro) {
                    setState(() {
                      _selectedFilter = filtro;
                      _searchResults = [];
                    });
                  },
                ),
                SizedBox(height: responsive!.hp(2)),
                Expanded(
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      if (_selectedFilter == 'Libro') {
                        return librosTile(_searchResults[index]);
                      } else if (_selectedFilter == 'Estudiante') {
                        return estudianteTile(_searchResults[index]);
                      } else if (_selectedFilter == 'Docente') {
                        return docenteTile(_searchResults[index]);
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.qr_code_scanner),
      ),*/
    );
  }

  Widget librosTile(Libro libro) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LibroDetallado(
                  libroId: libro.id,
                ),
              ),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: responsive!.wp(30),
                height: responsive!.hp(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: MemoryImage(
                      base64Decode(libro.picture),
                    ),
                  ),
                ),
              ),
              SizedBox(width: responsive!.wp(3)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        libro.titulo,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: responsive!.dp(3)),
                      ),
                      SizedBox(height: responsive!.hp(2)),
                      Text('Autor(a): ${libro.autor}',
                          style: TextStyle(fontSize: responsive!.dp(2))),
                      SizedBox(height: responsive!.hp(2)),
                      Text('Serie: ${libro.serie}',
                          style: TextStyle(fontSize: responsive!.dp(2))),
                      SizedBox(height: responsive!.hp(2)),
                      Text('Género: ${libro.genero}',
                          style: TextStyle(fontSize: responsive!.dp(2))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget estudianteTile(Estudiante estudiante) {
    return ListTile(
      leading: Icon(
        Icons.person,
        size: responsive!.dp(6),
      ),
      title: Text(
          '${estudiante.nombre} ${estudiante.apellidoPaterno} ${estudiante.apellidoMaterno}',
          style: TextStyle(fontSize: responsive!.dp(2.5))),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Grado: ${estudiante.grado} - Grupo: ${estudiante.grupo}',
              style: TextStyle(fontSize: responsive!.dp(2))),
          Text(estudiante.numControl,
              style: TextStyle(fontSize: responsive!.dp(2))),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SolicitudesPorEstudiante(
                numControl: estudiante.numControl, type: 'total'),
          ),
        );
      },
    );
  }

  Widget docenteTile(Docente docente) {
    return ListTile(
      leading: Icon(
        Icons.person,
        size: responsive!.dp(6),
      ),
      title: Text(
          '${docente.nombre} ${docente.apellidoPaterno} ${docente.apellidoMaterno}',
          style: TextStyle(fontSize: responsive!.dp(2.5))),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${docente.grado} - ${docente.grupo}',
              style: TextStyle(fontSize: responsive!.dp(2))),
          Text(docente.id!, style: TextStyle(fontSize: responsive!.dp(2))),
        ],
      ),
      onTap: () {
        // Navegar a la página de detalles del docente
        // Navigator.push(...);
      },
    );
  }
}
