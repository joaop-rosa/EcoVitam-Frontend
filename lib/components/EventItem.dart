import 'package:ecovitam/constants/colors.dart';
import 'package:ecovitam/models/Events.dart';
import 'package:ecovitam/presenter/EventItemPresenter.dart';
import 'package:flutter/material.dart';

class EventItem extends StatefulWidget {
  final Event event;
  final EventItemPresenter presenter;
  final bool isUserOwn;

  const EventItem(
      {super.key,
      required this.event,
      required this.presenter,
      this.isUserOwn = false});

  @override
  _EventItemState createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = widget.event.is_user_liked;
  }

  int getLikeNumber() {
    if (widget.event.is_user_liked && !isLiked) {
      return widget.event.total_likes - 1;
    }

    if (!widget.event.is_user_liked && isLiked) {
      return widget.event.total_likes + 1;
    }

    return widget.event.total_likes;
  }

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
                widget.event.titulo,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              widget.isUserOwn
                  ? IconButton(
                      onPressed: () =>
                          widget.presenter.delete(context, widget.event.id),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ))
                  : IconButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirmar denuncia'),
                              content: Text(
                                  'Tem certeza que deseja denunciar o evento ${widget.event.titulo}?'),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Não',
                                    style: TextStyle(color: danger),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await widget.presenter
                                        .sendReport(context, widget.event.id);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Sim',
                                      style: TextStyle(color: sucess)),
                                ),
                              ],
                            );
                          }),
                      icon: const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.redAccent,
                      ))
            ],
          ),
          Text.rich(
            TextSpan(children: [
              const TextSpan(
                  text: 'Endereço: ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                      '${widget.event.data.day}/${widget.event.data.month}/${widget.event.data.year}')
            ]),
          ),
          Text.rich(
            TextSpan(children: [
              const TextSpan(
                  text: 'Contato: ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: widget.event.contato)
            ]),
          ),
          Text.rich(
            TextSpan(children: [
              const TextSpan(
                  text: 'Data: ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                      '${widget.event.data.day}/${widget.event.data.month}/${widget.event.data.year}')
            ]),
          ),
          Text(
              '${widget.event.horaInicio.substring(0, 5)}h as ${widget.event.horaFim.substring(0, 5)}h'),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!widget.isUserOwn)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isLiked ? sucess : Colors.grey, // Cor dinâmica
                    foregroundColor: Colors.white, // Cor do texto/ícones
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Bordas arredondadas
                    ),
                  ),
                  onPressed: () async {
                    final success =
                        await widget.presenter.like(context, widget.event.id);
                    if (success != null) {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.thumb_up_alt,
                        color: isLiked
                            ? Colors.white
                            : Colors.black, // Cor do ícone
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Gostei (${getLikeNumber()})',
                        style: TextStyle(
                          color: isLiked
                              ? Colors.white
                              : Colors.black, // Cor do texto
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              Text(
                'Cadastrado por ${widget.event.nomeCompleto}',
                style: const TextStyle(fontSize: 12),
              )
            ],
          )
        ]));
  }
}
