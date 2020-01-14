import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

class Filtro extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
                height: 80.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    SizedBox(
                      width: 40.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: IconButton(
                        onPressed: () => print('Filtros'),
                        icon: Icon(
                          Icons.search,
                          size: 35.0,
                        ),
                      ),
                    ),
                    _categoria(true, Icon(FontAwesomeIcons.dog)),
                    _categoria(false, Icon(FontAwesomeIcons.cat)),
                    _categoria(false, Icon(FontAwesomeIcons.dove)),
                  ],
                ));
  }

  Widget _categoria(bool _isSelected, Icon ion) {
    return GestureDetector(
      onTap: () => print('Seleccionó'),
      child: Container(
          margin: EdgeInsets.all(10.0),
          width: 80.0,
          decoration: BoxDecoration(
            color: _isSelected ? Colors.pinkAccent : Color(0xFFF8F2F7),
            borderRadius: BorderRadius.circular(20.0),
            border: _isSelected
                ? Border.all(width: 8.0, color: Color(0xFFFED8D3))
                : null,
          ),
          child: Center(
            child: IconButton(onPressed: () => null, icon: ion),
          )),
    );
  }
  
}