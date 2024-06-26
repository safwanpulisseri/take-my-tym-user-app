import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/circle_profile_picture_widget.dart';
import '../bloc/individual_message_bloc/individual_message_bloc.dart';
import '../pages/individual_chat_page.dart';


class ChatTileWidget extends StatefulWidget {
  final String currentUserId;
  final String recipientUserId;

  const ChatTileWidget({
    super.key,
    required this.currentUserId,
    required this.recipientUserId,
  });

  @override
  State<ChatTileWidget> createState() => _ChatTileWidgetState();
}

class _ChatTileWidgetState extends State<ChatTileWidget> {
  late final IndividualMessageBloc _individualMessageBloc;

  @override
  void initState() {
    super.initState();
    _individualMessageBloc = IndividualMessageBloc();
    _individualMessageBloc.add(
      GetMessagesEvent(
        currentUserId: widget.currentUserId,
        recipientUserId: widget.recipientUserId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _individualMessageBloc,
      builder: (context, state) {
        if (state is IndividualChatsLoadedState) {
          return StreamBuilder<DocumentSnapshot>(
              stream: state.userInfo,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final map = snapshot.data!;
                  final name = map['userName'] ?? 'error';
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IndividualChatPage(
                            currentUid: widget.currentUserId,
                            receiverUid: widget.recipientUserId,
                            receiverName: name,
                            individualMessageBloc: _individualMessageBloc,
                          ),
                        ),
                      );
                    },
                    leading:const SizedBox(
                      height: 50,
                      child: Stack(alignment: Alignment.bottomRight, children: [
                         CircleProfilePicWidget(
                          height: 50,
                          width: 50,
                        ),
                  
                      ]),
                    ),
                    title: Text(
                      name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    subtitle: Text(
                      "new message",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: Text(
                      "4:09 PM",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }
                return const SizedBox.shrink();
              });
        }
        return SizedBox.fromSize();
      },
    );
  }
}
