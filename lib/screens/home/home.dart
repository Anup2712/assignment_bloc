import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:githubuser/screens/home/widgets/selecteduser.dart';
import 'package:githubuser/screens/home/widgets/userlist.dart';

import 'cubit/home_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  void backtoFirstTab() {
    _tabController.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Users'),
              Tab(text: 'Selcted User'),
            ],
          ),
        ),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (message) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
              ),
            ),
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox(),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (users, selectedUsers) => TabBarView(
              controller: _tabController,
              children: [
                UserList(users: users),
                SelectedUser(
                  users: selectedUsers,
                  backtoFirstTab: backtoFirstTab,
                )
              ],
            ),
            error: (error) => TabBarView(
              controller: _tabController,
              children: [
                const UserList(users: []),
                SelectedUser(
                  users: const [],
                  backtoFirstTab: backtoFirstTab,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
