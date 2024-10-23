import 'package:flutter/material.dart';

class EventItem extends StatefulWidget {
  final String titulo;
  final String endereco;
  final String cidade;
  final String estado;
  final String contato;
  final DateTime data;
  final String horaInicio;
  final String horaFim;
  final String nomeCompleto;

  const EventItem(
      {super.key,
      required this.titulo,
      required this.endereco,
      required this.cidade,
      required this.estado,
      required this.contato,
      required this.data,
      required this.horaInicio,
      required this.horaFim,
      required this.nomeCompleto});

  @override
  _EventItemState createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
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
                widget.titulo,
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
          Text(
              'Data: ${widget.data.day}/${widget.data.month}/${widget.data.year}'),
          Text(
              '${widget.horaInicio.substring(0, 5)}h as ${widget.horaFim.substring(0, 5)}h'),
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
