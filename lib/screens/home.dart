import 'package:brickart_flutter/controller/login_controller.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../util/textstyle_constant.dart';
import '../widgets/drawer_menu.dart';
import 'package:flutter/material.dart';


Future<Album> fetchAlbum() async {
  // var headers = {
  //   'Content-Type': 'application/json',
  //    'Charset': 'utf-8',
  //
  //    'Authorization': 'key=AAAAv02FwQQ:APA91bH35Xn0FAhPDE74WTakQTqFaoJW-yLqRX_BgTmYzOaV_Y3YC4ECZ3gv0XdfuSs_2zrMtd1MAxOdg0qUfE5r8H2woV7EhWW2uKOexztI-iDboROgEB7xtY4gZrDL256w3gkggqxO'
  // };
  // var request = http.Request('GET', Uri.parse('https://viacep.com.br/ws/01311000/json'));
  // request.body = '''{\r\n       "to":    "ee36UA1qR5O77dhFWgX3oa:APA91bEJ6L6M1Jttc9oa5TnBKMyUYeOVNspJZzDclUqJEDnWGyyUGGUC0GGQAt3ZiyIPIjvOROtPMpy5grmC_XlHMU91Lkq8fJchBEryIOtBveXMszXKP2_SIVu6T4VGMQQXmsmdnUBU",\r\n       "notification": {\r\n          "body": "body",\r\n          "title": "title"\r\n       },\r\n       "priority": "high",\r\n       "data": {\r\n           "key1":"Hello from Server Side",\r\n           "key2":"Just dummy data"\r\n        // "body": "body",\r\n        //   "title": "title",\r\n        //   "click_action": "FLUTTER_NOTIFICATION_CLICK",\r\n        //   "id": "1",\r\n        //   "status": "done",\r\n        //   "image": "https://ibin.co/2t1lLdpfS06F.png"\r\n       }\r\n}''';
  // request.headers.addAll(headers);
  //
  // http.StreamedResponse response = await request.send();
  //
  // if (response.statusCode == 200) {
  //   print(await response.stream.bytesToString());
  //   return  Album.fromJson(jsonDecode(response.stream.toString()));
  // }
  // else {
  //   print(response.reasonPhrase);
  // }
  //
  final response =
  await http.get(Uri.parse('https://viacep.com.br/ws/01311000/json'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }

}

class Album {
  final String uf;
  final String localidade;
  final String logradouro;
  final String bairro;

  Album({
    this.uf,
    this.localidade,
    this.logradouro,
    this.bairro,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      uf: json['uf'],
      localidade: json['localidade'],
      logradouro: json['logradouro'],
      bairro: json['bairro'],
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final LoginController controller = Get.find();

  Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
  //futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: SafeArea(
          // child: ListTile(
          //   leading: GestureDetector(
          //     onTap: () {
          //       _drawerKey.currentState.openDrawer();
          //     },
          //     child: Container(
          //       margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
          //       child: Image.asset('assets/icons/hamburger.png'),
          //       // height: 40,
          //       // width: 40,
          //     ),
          //   ),
          //   title: Container(
          //     margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.09),
          //
          //     child:Center(
          //     child: Text(
          //       'Brickart',
          //       style: kAppBarTitleTextStyle,
          //     ),
          //   ),
          //   ),
          //   trailing: GestureDetector(
          //     // onTap: () {
          //     //   Navigator.of(context)
          //     //       .push(MaterialPageRoute(builder: (context) => FAQScreen()));
          //     // },
          //     child: Opacity(
          //         opacity: 1,
          //         child: GestureDetector(
          //           child:Container(
          //             // width: 100,
          //             // height: 45,
          //             child:MaterialButton(
          //             child: Image.asset('assets/icons/chat.png'),
          //             onPressed: () {
          //
          //               FlutterOpenWhatsapp.sendSingleMessage("+5511992156335", "Hello I want to enter my order...");
          //               print("Container was tapped");
          //
          //               //    child: Text('Running on: $_platformVersion\n'),
          //
          //
          //             },
          //
          //
          //           ),),
          //         )
          //     ),
          //  ),
          // ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              GestureDetector(
                  onTap: () {
                    _drawerKey.currentState.openDrawer();
                  },
                  child: Container(
                    child: Image.asset('assets/icons/hamburger.png'),

                  ),
                ),
              Center(child:Container(

                  child: Text(
                    'Brickart',
                    style: kAppBarTitleTextStyle,
                  ),

              ),),

              GestureDetector(

                child: Opacity(
                    opacity: 1,
                    child: GestureDetector(
                      onTap: () {

                        FlutterOpenWhatsapp.sendSingleMessage("+5511992156335", "Hello I want to enter my order...");
                        print("Container was tapped");

                      },
                      child:Container(
                     //   margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),


                          child: Image.asset('assets/icons/chat.png'),



                        ),
                    )
                ),
              ),



            ],

          )
        ),
      ),

      key: _drawerKey,
      drawer: DrawerMenu(),
      body: SizedBox.expand(
        child: ListView(
          children: <Widget>
          [
            //  Center(
            //   child: FutureBuilder<Album>(
            //     future: futureAlbum,
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         return Text(snapshot.data.localidade + snapshot.data.bairro + snapshot.data.uf + snapshot.data.logradouro);
            //       } else if (snapshot.hasError) {
            //         return Text("${snapshot.error}");
            //       }
            //       //By default, show a loading spinner.
            //       return Text("${snapshot.error}");
            //     },
            //   ),
            // ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
              child: Column(
                children: <Widget>[
                  Text(
                    'Bem-vindo a Brickart',
                    textAlign: TextAlign.center,
                    style: homeTitle,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Conte sua história para todos seus amigos e familiares',
                    textAlign: TextAlign.center,
                    style: homeSubTitle,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 220,
                    child: Image.asset(
                      'assets/images/video-playback-wistia.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 560,
              child: Image.asset(
                'assets/images/brick-collection-2.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
              child: Column(
                children: <Widget>[
                  Text(
                    'Eternize seus momentos!',
                    textAlign: TextAlign.center,
                    style: homeTitle,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Os Bricks são quadros de 20cm x 20cm, perfeitos para colecionar suas memórias',
                    textAlign: TextAlign.center,
                    style: homeSubTitle,
                  ),
                ],
              ),
            ),
            Container(
              height: 518,
              child: Image.asset(
                'assets/images/brick-collection-3.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
              child: Column(
                children: <Widget>[
                  Text(
                    'Crie diferentes disposições',
                    textAlign: TextAlign.center,
                    style: homeTitle,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Os bricks são reposicionáveis, permitindo você criar diferentes ambientes com suas memóriás e lembranças',
                    textAlign: TextAlign.center,
                    style: homeSubTitle,
                  ),
                ],
              ),
            ),
            Container(
              height: 570,
              child: Image.asset(
                'assets/images/glueless.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
              child: Column(
                children: <Widget>[
                  Text(
                    'Gruda e desgruda! ',
                    textAlign: TextAlign.center,
                    style: homeTitle,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Os bricks possuem adesivo de nano sucção que permite ser reposicionado sem danificar as paredes.',
                    textAlign: TextAlign.center,
                    style: homeSubTitle,
                  ),
                ],
              ),
            ),
            Container(
              height: 576,
              child: Image.asset(
                'assets/images/brick-collection-1.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
              child: Column(
                children: <Widget>[
                  Text(
                    '3 Bricks por R\$ 135,00! ',
                    textAlign: TextAlign.center,
                    style: homeTitle,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Cada brick adicional sai por R\$ 35,00',
                    textAlign: TextAlign.center,
                    style: homeSubTitle,
                  ),
                ],
              ),
            ),
            Container(
              height: 576,
              child: Image.asset(
                'assets/images/brick-collection.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
              child: Column(
                children: <Widget>[
                  Text(
                    'Frete grátis! ',
                    textAlign: TextAlign.center,
                    style: homeTitle,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'É só escolher as imagens que o frete é por nossa conta.',
                    textAlign: TextAlign.center,
                    style: homeSubTitle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
