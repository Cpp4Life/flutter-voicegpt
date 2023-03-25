import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChatItemWidget extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatItemWidget({
    required this.message,
    required this.isUser,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          !isUser
              ? Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(right: 5),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade800,
                    child: SvgPicture.asset(
                      'assets/svg/chatgpt.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(),
          Container(
            padding: const EdgeInsets.all(10),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
            ),
            decoration: BoxDecoration(
              color:
                  isUser ? Theme.of(context).colorScheme.secondary : Colors.grey.shade800,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
                bottomLeft: Radius.circular(isUser ? 15 : 0),
                bottomRight: Radius.circular(isUser ? 0 : 15),
              ),
            ),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          )
        ],
      ),
    );
  }
}
