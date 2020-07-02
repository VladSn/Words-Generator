import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _randomWordGroups = <WordPair>[];
  final _likeswordsGroups = Set<WordPair>();

  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, item) {
          if(item.isOdd) return Divider();

          final i = item ~/ 2;

          if(i >= _randomWordGroups.length) {
            _randomWordGroups.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_randomWordGroups[i]);
        }
    );
  }

  Widget _buildRow(pair) {
    final alreadySaved = _likeswordsGroups.contains(pair);
    
    return ListTile(
        title: Text(pair.asPascalCase, style: TextStyle(fontSize: 19)),
        trailing: Icon(alreadySaved ? Icons.favorite:
        Icons.favorite_border, color: alreadySaved ?
          Colors.red : null),
        onTap: () {
          setState(() {
            if(alreadySaved) {
              _likeswordsGroups.remove(pair);
            } else {
              _likeswordsGroups.add(pair);
            }
          });
        },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context){
            final Iterable<ListTile> tiles = 
                _likeswordsGroups.map((pair) {
                  return ListTile(
                    title: Text(
                        pair.asPascalCase,
                        style: TextStyle(fontSize:19))
                  );
                });

            final List<Widget> divided = ListTile.divideTiles(
            tiles: tiles,
            context: context
            ).toList();

            return Scaffold(
              appBar: AppBar(
                title: Text('Likes Words')),
              body: ListView(children: divided));
          }
      )
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WordGroup Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildList(),
    );
  }
}