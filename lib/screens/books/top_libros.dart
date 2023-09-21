import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../database/database.dart';
import '../../models/libro.dart';

import 'package:flutter_emoji/flutter_emoji.dart';

import '../../util/responsive.dart';

class TopTenBooks extends StatefulWidget {
  const TopTenBooks({super.key});

  @override
  State<TopTenBooks> createState() => _TopTenBooksState();
}

class _TopTenBooksState extends State<TopTenBooks> {
  Future<List<Libro>>? _topTenBooksFuture;
  var parser = EmojiParser();
  Responsive? responsive;

  @override
  void initState() {
    super.initState();
    _topTenBooksFuture = DatabaseHelper.getTopTenBooks();
  }

  @override
  Widget build(BuildContext context) {
    responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Top 10 libros más solicitados',
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
      body: FutureBuilder<List<Libro>>(
        future: _topTenBooksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var books = snapshot.data;
            return AnimationLimiter(
              child: ListView.builder(
                itemCount: books!.length,
                itemBuilder: (BuildContext context, int index) {
                  Libro book = books[index];
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
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: responsive!.wp(15),
                                    height: responsive!.hp(11),
                                    child: Center(child: rankWidget),
                                  ),
                                  SizedBox(width: responsive!.wp(3)),
                                  Container(
                                    //width: 100,
                                    //height: 150,
                                    width: responsive!.wp(15),
                                    height: responsive!.hp(11),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: MemoryImage(
                                          base64Decode(book.picture),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: responsive!.wp(3)),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(book.titulo,
                                            style: TextStyle(
                                                fontSize: responsive!.dp(2))),
                                        Text('Solicitudes: ${book.solicitudes}',
                                            style: TextStyle(
                                                fontSize: responsive!.dp(2))),
                                      ],
                                    ),
                                  ),
                                  //Icon(Icons.arrow_forward),
                                ],
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
