// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  Set<WordPair> _saved = Set<WordPair>();
  final List<WordPair> _suggestions = <WordPair>[];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  final ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _suggestions.setAll(
                    0, generateWordPairs().take(_suggestions.length));
              });
            },
          )
        ],
      ),
      body: _buildSuggestions(_scrollController),
      drawer: Drawer(
          child: Column(
        children: <Widget>[
          FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                  height: 180.0,
                  child: DrawerHeader(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Favorite Names",
                          style: TextStyle(fontSize: 25.0),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 15.0),
                            child: ButtonTheme(
                              minWidth: 160.0,
                              child: RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    _saved = Set<WordPair>();
                                  });
                                },
                                color: Colors.red[400],
                                child: Text(
                                  "DELETE ALL",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.grey[300],
                          offset: new Offset(0, 3.0),
                        )
                      ],
                    ),
                  ))),
          Expanded(
              child: ListView.separated(
                  controller: _scrollController,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(13.0),
                  itemCount: _saved.length,
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return (ListTile(
                      title: Text(_saved.elementAt(index).asPascalCase,
                          style: TextStyle(fontSize: 16.0)),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _saved.remove(_saved.elementAt(index));
                          });
                        },
                      ),
                    ));
                  }))
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
        },
        child: Icon(Icons.arrow_upward),
        backgroundColor: Colors.black,
      ),
    );
  }

  // Widget _buildFavorites(controller) {
  //   return
  // }

  Widget _buildSuggestions(controller) {
    return ListView.builder(
        controller: controller,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(20));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}
