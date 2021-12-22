// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Post.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {


String _urlBase = "https://jsonplaceholder.typicode.com";

Future<List<Post>> _recuperarPostagens() async{

  http.Response response = await http.get(Uri.parse(_urlBase + "/posts"));
  var dadosJson = json.decode( response.body );

  List<Post> postagens = List();
  for(var post in dadosJson){
    print("post: " + post["title"]);
    Post p = Post(post["userId"],post["id"],post["title"],post["body"]);
    postagens.add ( p );
  }
  return postagens;
}

_post() async {

  Post post = new Post(120, null, "Título", "Corpo da postagem");
  var corpo = json.encode(
    post.toJson()
  );
  http.Response response = await http.post(Uri.parse(
      _urlBase + "/posts",
  ),
      headers: {
    "Content-type": "application/json; charset=UTF-8"
    },
    body: corpo,
  );
  print("resposta: ${response.statusCode}");
  print("resposta: ${response.body}");

}

_put() async {   // o put ele é utilizado quando queremeos atualizar o obj inteiro

  Post post = new Post(120, null, "Título", "Corpo da postagem");
  var corpo = json.encode(
      post.toJson()
  );
  http.Response response = await http.put(Uri.parse(
    _urlBase + "/posts/2",
  ),
    headers: {
      "Content-type": "application/json; charset=UTF-8"
    },
    body: corpo,
  );
  print("resposta: ${response.statusCode}");
  print("resposta: ${response.body}");

}
_patch() async{  // já o patch pode atualizar apenas um campo, todo resto seria mantido.

  Post post = new Post(120, null, "Título", "Corpo da postagem");
  var corpo = json.encode(
      post.toJson()
  );
  http.Response response = await http.patch(Uri.parse(
    _urlBase + "/posts/2",
  ),
    headers: {
      "Content-type": "application/json; charset=UTF-8"
    },
    body: corpo,
  );
  print("resposta: ${response.statusCode}");
  print("resposta: ${response.body}");

}
_delete() async {

  http.Response response = await http.delete(Uri.parse(
    _urlBase + "/posts/2",
  ),);
    if( response.statusCode.toString() == 200) {
      //sucesso
      print("deleted!");
    }
  print("resposta: ${response.statusCode}");
  print("resposta: ${response.body}");

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço avançado"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
              ElevatedButton(
                  onPressed: _post,
                  child: Text("Salvar"),
              ),
                ElevatedButton(
                  onPressed: _put,
                  child: Text("Atualizar"),
                ),
                ElevatedButton(
                  onPressed: _delete,
                  child: Text("Deletar"),
                ),

            ],
          ),
            Expanded(
                child: FutureBuilder<List<Post>>(
                  future: _recuperarPostagens(),
                  builder: (context, snapshot){
                    switch (snapshot.connectionState) {

                      case ConnectionState.none :
                      case ConnectionState.waiting :
                        return Center(
                          child: CircularProgressIndicator(),
                        );

                        break;
                      case ConnectionState.active :
                      case ConnectionState.done :
                        print("conexao done");
                        if (snapshot.hasError){
                          print("Lista: erro");
                        }else{
                          print("Lista: Carregou!");
                          return ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index){

                                List<Post> lista = snapshot.data;
                                Post post = lista [index];

                                return ListTile(
                                  title: Text(post.title),
                                  subtitle: Text( post.id.toString() ),
                                );
                              }
                          );
                        }
                        break;
                    }
                    return build(context);
                  },
                ),
            ),

          ],
        ),
      ),
    );
  }
}


