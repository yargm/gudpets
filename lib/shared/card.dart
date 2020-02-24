import 'package:flutter/material.dart';
import 'package:gudpets/pages/pages.dart';
import 'package:gudpets/services/services.dart';

class ListCard extends StatefulWidget {
  final dynamic objeto;
  final int posicion;
  final Controller controlador1;

  ListCard({this.objeto, this.posicion, this.controlador1});

  @override
  _ListCardState createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  final double containerPadding = 80;

  final double containerPadding2 = 80;

  final double containerBorderRadius = 15;
  bool favorito = false;

  @override
  void initState() {
    super.initState();
    for (var usuario in widget.objeto.favoritos) {
      setState(() {
        if (widget.controlador1.usuario.documentId == usuario) {
          favorito = true;
        } else {
          favorito = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //  for (var usuario in widget.objeto.favoritos) {
     
    //     if (widget.controlador1.usuario.documentId == usuario) {
    //       favorito = true;
    //     } else {
    //       favorito = false;
    //     }

    // }
    var leftAligned = (widget.posicion % 2 == 0) ? true : false;
    Controller controlador1 = Provider.of<Controller>(context);

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
                          controlador1.pestanaAct == 0
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Adopcion(
                                            objeto: widget.objeto,
                                            favorito: favorito,
                                          )),
                                )
                              : controlador1.pestanaAct == 1
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Perdido(
                                              objeto: widget.objeto,
                                              favorito: favorito)),
                                    )
                                  : controlador1.pestanaAct == 2
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Rescate(
                                                    objeto: widget.objeto,
                                                    favorito: favorito,
                                                  )),
                                        )
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Emergencia(
                                                  objeto: widget.objeto,
                                                  favorito: favorito)),
                                        );
                        },
                        child: ClipRRect(
                          clipBehavior: Clip.hardEdge,
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
                          child: FadeInImage(
                            placeholder: AssetImage('assets/dog.png'),
                            width: double.maxFinite,
                            height: 200,
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.objeto.foto),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      widget.objeto.titulo,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    padding: leftAligned
                        ? EdgeInsets.only(right: 30)
                        : EdgeInsets.only(right: 5),
                    icon:
                        Icon(favorito ? Icons.favorite : Icons.favorite_border),
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
                      switch (controlador1.pestanaAct) {
                        case 0:
                          !favorito
                              ? controlador1.usuario.reference.updateData(
                                  {
                                    'adopciones': FieldValue.arrayUnion([
                                      {
                                        'imagen': widget.objeto.foto,
                                        'titulo': widget.objeto.titulo,
                                        'documentId': widget.objeto.documentId,
                                      }
                                    ])
                                  },
                                )
                              : controlador1.usuario.reference.updateData(
                                  {
                                    'adopciones': FieldValue.arrayRemove([
                                      {
                                        'imagen': widget.objeto.foto,
                                        'titulo': widget.objeto.titulo,
                                        'documentId': widget.objeto.documentId,
                                      }
                                    ])
                                  },
                                );
                          setState(() {
                            favorito ? favorito = false : favorito = true;
                          });
                          break;
                        case 1:
                          !favorito
                              ? controlador1.usuario.reference.updateData(
                                  {
                                    'perdidos': FieldValue.arrayUnion([
                                      {
                                        'imagen': widget.objeto.foto,
                                        'titulo': widget.objeto.titulo,
                                        'documentId': widget.objeto.documentId,
                                      }
                                    ])
                                  },
                                )
                              : controlador1.usuario.reference.updateData(
                                  {
                                    'perdidos': FieldValue.arrayRemove([
                                      {
                                        'imagen': widget.objeto.foto,
                                        'titulo': widget.objeto.titulo,
                                        'documentId': widget.objeto.documentId,
                                      }
                                    ])
                                  },
                                );
                          setState(() {
                            favorito ? favorito = false : favorito = true;
                          });
                          break;
                        case 2:
                          !favorito
                              ? controlador1.usuario.reference.updateData(
                                  {
                                    'rescates': FieldValue.arrayUnion([
                                      {
                                        'imagen': widget.objeto.foto,
                                        'titulo': widget.objeto.titulo,
                                        'documentId': widget.objeto.documentId,
                                      }
                                    ])
                                  },
                                )
                              : controlador1.usuario.reference.updateData(
                                  {
                                    'rescates': FieldValue.arrayRemove([
                                      {
                                        'imagen': widget.objeto.foto,
                                        'titulo': widget.objeto.titulo,
                                        'documentId': widget.objeto.documentId,
                                      }
                                    ])
                                  },
                                );
                          setState(() {
                            favorito ? favorito = false : favorito = true;
                          });
                          break;
                        case 3:
                          !favorito
                              ? controlador1.usuario.reference.updateData(
                                  {
                                    'emergencias': FieldValue.arrayUnion([
                                      {
                                        'imagen': widget.objeto.foto,
                                        'titulo': widget.objeto.titulo,
                                        'documentId': widget.objeto.documentId,
                                      }
                                    ])
                                  },
                                )
                              : controlador1.usuario.reference.updateData(
                                  {
                                    'emergencias': FieldValue.arrayRemove([
                                      {
                                        'imagen': widget.objeto.foto,
                                        'titulo': widget.objeto.titulo,
                                        'documentId': widget.objeto.documentId,
                                      }
                                    ])
                                  },
                                );
                          setState(() {
                            favorito ? favorito = false : favorito = true;
                          });
                          break;
                      }
                      print(favorito.toString());
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 30, bottom: 20.0),
                child: Text(widget.objeto.descripcion,
                    maxLines: 2,
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
