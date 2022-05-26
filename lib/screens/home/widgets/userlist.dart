import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:githubuser/models/user.dart';
import 'package:githubuser/screens/home/cubit/home_cubit.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key, required this.users}) : super(key: key);

  final List<UserModel> users;

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: widget.users.length,
            itemBuilder: (context, index) {
              var user = widget.users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(widget.users[index].avtarUrl),
                ),
                title: Text(widget.users[index].name),
                trailing: IconButton(
                  onPressed: () {
                    context.read<HomeCubit>().addToSelectedUserList(user);
                  },
                  icon: Icon(
                    context.read<HomeCubit>().selectedUserList.contains(user)
                        ? Icons.delete
                        : Icons.person_add,
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const Divider(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (context.read<HomeCubit>().skip != 0)
                Expanded(
                  child: ElevatedButton(
                    child: const Text('Previous'),
                    onPressed: () async {
                      await context.read<HomeCubit>().callPrevious();
                    },
                  ),
                ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton(
                  child: const Text('Next'),
                  onPressed: () async {
                    await context.read<HomeCubit>().callNext();
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
