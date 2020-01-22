import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

class ListCard extends StatefulWidget {
  final dynamic objeto;
  final int posicion;

  ListCard({this.objeto, this.posicion});

  @override
  _ListCardState createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  final double containerPadding = 80;

  final double containerPadding2 = 80;

  final double containerBorderRadius = 15;

  @override
  Widget build(BuildContext context) {
    bool favorito = false;

    var leftAligned = (widget.posicion % 2 == 0) ? true : false;
    Controller controlador1 = Provider.of<Controller>(context);

    for (var usuario in widget.objeto.favoritos) {
      setState(() {
        if (controlador1.usuario.documentId == usuario) {
          favorito = true;
        } else {
          favorito = false;
        }
      });
    }

    // TODO: implement build
    return Container(
        padding: EdgeInsets.only(
            left: leftAligned ? 0 : containerPadding2,
            right: leftAligned ? containerPadding : 0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 0, right: 0),
              child: Container(
                width: double.maxFinite,
                height: 200,
                // decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),R
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: widget.objeto.documentId,
                      child: GestureDetector(
                        onTap: () {
                          controlador1.pestana_act == 0
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Adopcion(
                                            objeto: widget.objeto,
                                          )),
                                )
                              : controlador1.pestana_act == 1
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Perdido(
                                                objeto: widget.objeto,
                                              )),
                                    )
                                  : controlador1.pestana_act == 2
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Rescate(
                                                    objeto: widget.objeto,
                                                  )),
                                        )
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Emergencia(
                                                    objeto: widget.objeto,
                                                  )),
                                        );
                        },
                        child: Container(
                          width: double.maxFinite,
                          height: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: leftAligned
                                    ? Radius.circular(0)
                                    : Radius.circular(40.0),
                                topRight: leftAligned
                                    ? Radius.circular(40.0)
                                    : Radius.circular(0),
                                bottomLeft: leftAligned
                                    ? Radius.circular(0)
                                    : Radius.circular(40.0),
                                bottomRight: leftAligned
                                    ? Radius.circular(40.0)
                                    : Radius.circular(0),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(widget.objeto.foto),
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.objeto.titulo,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      padding: leftAligned
                          ? EdgeInsets.only(right: 30)
                          : EdgeInsets.only(right: 5),
                      icon: Icon(favorito ? Icons.favorite : Icons.favorite_border),
                      iconSize: 30.0,
                      color: Colors.pink,
                      onPressed: () {
                        !favorito
                            ? widget.objeto.reference.updateData({
                                'favoritos': FieldValue.arrayUnion(
                                    [controlador1.usuario.documentId]),
                              })
                            : widget.objeto.reference.updateData({
                                'favoritos': FieldValue.arrayRemove(
                                    [controlador1.usuario.documentId])
                              });
                        switch (controlador1.pestana_act) {
                          case 0:
                            !favorito
                                ? controlador1.usuario.reference.updateData(
                                    {
                                      'adopcionens': FieldValue.arrayUnion([
                                        {
                                          'imagen': widget.objeto.foto,
                                          'titulo': widget.objeto.titulo,
                                          'documentId':
                                              widget.objeto.documentId,
                                        }
                                      ])
                                    },
                                  )
                                : controlador1.usuario.reference.updateData(
                                    {
                                      'adopcionens': FieldValue.arrayRemove([
                                        {
                                          'imagen': widget.objeto.foto,
                                          'titulo': widget.objeto.titulo,
                                          'documentId':
                                              widget.objeto.documentId,
                                        }
                                      ])
                                    },
                                  );
                            setState(() {
                              favorito ? favorito = false : favorito = true;
                            });
                            break;
                          case 1:
                            controlador1.usuario.reference
                                .collection('perdidos')
                                .add({});
                            break;
                          case 2:
                            controlador1.usuario.reference
                                .collection('rescates')
                                .add({});
                            break;
                          case 3:
                            controlador1.usuario.reference
                                .collection('emergencias')
                                .add({});
                            break;
                        }
                        print('curazao');
                      },
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 30, bottom: 20.0),
                child: Text(widget.objeto.descripcion,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    )),
              ),
            ),
          ],
        ));
  }
}
