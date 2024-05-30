import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shop_app/admin/chat_messages.dart';

class BodyAllUsersPage extends StatelessWidget {
  const BodyAllUsersPage({Key? key});

  void _handlePressed(
    types.User otherUser,
    BuildContext context, {
    required String otherUserId, 
    required String userName,
  }) async {
    final nav = ScaffoldMessenger.of(context);
    try {
      final navigator = Navigator.of(context);
      final room = await FirebaseChatCore.instance.createRoom(otherUser);
      await navigator.push(
        MaterialPageRoute(
          builder: (context) => ChatUserMessagesPage(
            room: room,
            name: userName,
            uid: otherUserId,
          ),
        ),
      );
    } catch (e) {
      nav.showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<types.User>>(
      stream: FirebaseChatCore.instance.users(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            itemCount: 6, // A fallback value for waiting state
            itemBuilder: (BuildContext context, int index) {
              return const ListTileShimmer();
            },
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No Users Found Yet...!'),
          );
        }

        final data = snapshot.data!;
        return ListView.separated(
          padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
          cacheExtent: 10000,
          separatorBuilder: (context, index) => const Divider(height: 0),
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            final user = data[index];
            return ListTile(
              onTap: () => _handlePressed(
                user,
                context,
                otherUserId: user.id,
                userName: user.firstName!,
              ),
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PhotoView(
                      imageProvider: CachedNetworkImageProvider(user.imageUrl!),
                    ),
                  ));
                },
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: CachedNetworkImage(
                    imageUrl: user.imageUrl ?? 'fallback_url',
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              title: Text(user.firstName!),
              trailing: CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.3),
                child: Text('${index + 1}'),
              ),
            );
          },
        );
      },
    );
  }
}
