import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:githubuser/models/user.dart';
import 'package:githubuser/screens/home/cubit/home_cubit.dart';

class SelectedUser extends StatefulWidget {
  const SelectedUser({
    Key? key,
    required this.users,
    required this.backtoFirstTab,
  }) : super(key: key);

  final List<UserModel> users;
  final Function backtoFirstTab;

  @override
  State<SelectedUser> createState() => _SelectedUserState();
}

class _SelectedUserState extends State<SelectedUser> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: widget.users.length,
            itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.users[index].avtarUrl),
              ),
              title: Text(widget.users[index].name),
              trailing: IconButton(
                onPressed: () async {
                  await context
                      .read<HomeCubit>()
                      .addToSelectedUserList(widget.users[index]);
                },
                icon: const Icon(
                  Icons.delete,
                ),
              ),
            ),
            separatorBuilder: (_, __) => const Divider(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            onPressed: () async {
              await context.read<HomeCubit>().removeAllUsers();
              widget.backtoFirstTab();
            },
            child: const Text('Remove All Users'),
          ),
        ),
      ],
    );
  }
}
