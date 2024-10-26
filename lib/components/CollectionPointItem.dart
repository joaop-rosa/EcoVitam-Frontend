import 'package:flutter/material.dart';

class CollectionPointItem extends StatefulWidget {
  final String pontoColetaNome;
  final String endereco;
  final String cidade;
  final String estado;
  final String contato;
  final String nomeCompleto;
  final bool isUserOwn;

  const CollectionPointItem(
      {super.key,
      required this.pontoColetaNome,
      required this.endereco,
      required this.cidade,
      required this.estado,
      required this.contato,
      required this.nomeCompleto,
      this.isUserOwn = false});

  @override
  _CollectionPointItemState createState() => _CollectionPointItemState();
}

class _CollectionPointItemState extends State<CollectionPointItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(14, 5, 14, 14),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.pontoColetaNome,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              widget.isUserOwn
                  ? IconButton(
                      onPressed: () => {},
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ))
                  : IconButton(
                      onPressed: () => {},
                      icon: const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.redAccent,
                      ))
            ],
          ),
          Text(
              'Endereço: ${widget.endereco} - ${widget.cidade} - ${widget.estado}'),
          Text('Contato: ${widget.contato}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!widget.isUserOwn)
                ElevatedButton(
                    onPressed: () => {},
                    child: const Row(
                      children: [
                        Icon(Icons.thumb_up_alt),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Gostei (0)')
                      ],
                    )),
              const Spacer(),
              Text(
                'Cadastrado por ${widget.nomeCompleto}',
                style: const TextStyle(fontSize: 12),
              )
            ],
          )
        ]));
  }
}
