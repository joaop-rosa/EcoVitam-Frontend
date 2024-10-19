import 'package:flutter/material.dart';

class CollectionPointItem extends StatefulWidget {
  final String pontoColetaNome;
  final String endereco;
  final String cidade;
  final String estado;
  final String contato;
  final String nomeCompleto;

  const CollectionPointItem({
    super.key,
    required this.pontoColetaNome,
    required this.endereco,
    required this.cidade,
    required this.estado,
    required this.contato,
    required this.nomeCompleto,
  });

  @override
  _CollectionPointItemState createState() => _CollectionPointItemState();
}

class _CollectionPointItemState extends State<CollectionPointItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.pontoColetaNome,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
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
              Text(
                'Cadastrado por ${widget.nomeCompleto}',
                style: const TextStyle(fontSize: 12),
              )
            ],
          )
        ]));
  }
}
