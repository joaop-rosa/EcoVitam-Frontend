import 'package:ecovitam/constants/colors.dart';
import 'package:ecovitam/models/CollectionPoint.dart';
import 'package:ecovitam/presenter/CollectionPointItemPresenter.dart';
import 'package:flutter/material.dart';

class CollectionPointItem extends StatefulWidget {
  final CollectionPoint colletionPoint;
  final CollectionPointItemPresenter presenter;
  final bool isUserOwn;

  const CollectionPointItem(
      {super.key,
      required this.colletionPoint,
      required this.presenter,
      this.isUserOwn = false});

  @override
  _CollectionPointItemState createState() => _CollectionPointItemState();
}

class _CollectionPointItemState extends State<CollectionPointItem> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = widget.colletionPoint.is_user_liked;
  }

  int getLikeNumber() {
    if (widget.colletionPoint.is_user_liked && !isLiked) {
      return widget.colletionPoint.total_likes - 1;
    }

    if (!widget.colletionPoint.is_user_liked && isLiked) {
      return widget.colletionPoint.total_likes + 1;
    }

    return widget.colletionPoint.total_likes;
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
                widget.colletionPoint.pontoColetaNome,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              widget.isUserOwn
                  ? IconButton(
                      onPressed: () => widget.presenter
                          .delete(context, widget.colletionPoint.id),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ))
                  : IconButton(
                      onPressed: () => widget.presenter
                          .sendReport(context, widget.colletionPoint.id),
                      icon: const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.redAccent,
                      ))
            ],
          ),
          Text(
              'Endereço: ${widget.colletionPoint.endereco} - ${widget.colletionPoint.cidade} - ${widget.colletionPoint.estado}'),
          Text('Contato: ${widget.colletionPoint.contato}'),
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
                    final success = await widget.presenter
                        .like(context, widget.colletionPoint.id);
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
                'Cadastrado por ${widget.colletionPoint.nomeCompleto}',
                style: const TextStyle(fontSize: 12),
              )
            ],
          )
        ]));
  }
}
