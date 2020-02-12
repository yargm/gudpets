import 'package:gudpets/services/services.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Información'),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.only(bottom: 10, top: 10, right: 10, left: 10),
          child: Container(
            margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            child: Column(
              children: <Widget>[
                Text(
                  'Creado por GudTech',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 200.0,
                  height: 200.0,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/gudtech.jpg'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Nuestras redes sociales',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => launch('https://www.facebook.com/GudPets'),
                      child: Image(
                        height: 45,
                        width: 45,
                        image: AssetImage('assets/gpfacebook.png'),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                        onTap: () => launch(
                            'https://www.facebook.com/GudTech-508541236622884/'),
                        child: Icon(
                          FontAwesomeIcons.facebook,
                          size: 45,
                        )),
                    SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                        onTap: () => launch(
                            'http://gudtech.tech/es/sample-page/home-spanish/'),
                        child: Icon(
                          FontAwesomeIcons.chrome,
                          size: 45,
                        )),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Donaciones',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                    'Como desarrolladores de GudPets nos sentimos comprometidos con los seres vivos y sus necesidades por lo que creemos que la labor de ofrecer a estas mascotas una segunda oportunidad es algo indispensable y es por eso que decidimos no restringir el uso de la app por medio de algún pago. Si deseas que este proyecto se mantenga en pie y siga creciendo te ofrecemos esta opción de donación voluntaria. Al realizar una donación serás reconocido en la lista de contribuidores de GudPets.',
                    style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                SizedBox(
                  height: 15,
                ),
                FloatingActionButton.extended(
                  onPressed: () => launch(
                      'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CKVCWLMCRCFTN&source=url'),
                  label: Text('Donar'),
                  icon: Icon(FontAwesomeIcons.paypal),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Dudas y sugerencias',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                    'Para externar tus dudas, sugerencias e ideas, puedes escribirnos al correo ',
                    style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                SizedBox(
                  height: 10,
                ),
                Text('gudtechinfo@gmail.com',
                    style: TextStyle(fontSize: 18.0, color: Colors.brown)),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Créditos',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 40.0,
                      height: 40.0,
                      child: Image(
                        image: AssetImage('assets/bulldog.png'),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(' Icon made by ',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.grey)),
                            GestureDetector(
                              onTap: () => launch(
                                  'https://www.flaticon.com/authors/freepik'),
                              child: Text('Freepik ',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.brown)),
                            ),
                            Text('from',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.grey)),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => launch('https://www.flaticon.com/'),
                          child: Text('www.flaticon.com',
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.brown)),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 40.0,
                      height: 40.0,
                      child: Image(
                        image: AssetImage('assets/dog.png'),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(' Icon made by ',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.grey)),
                            GestureDetector(
                              onTap: () => launch(
                                  'https://www.flaticon.com/authors/freepik'),
                              child: Text('Freepik ',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.brown)),
                            ),
                            Text('from',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.grey)),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => launch('https://www.flaticon.com/'),
                          child: Text('www.flaticon.com',
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.brown)),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
