import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:githubuser/models/localuser.dart';
import 'package:githubuser/models/user.dart';
import 'package:githubuser/objectbox.g.dart';
import 'package:githubuser/services/localdb.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState.initial()) {
    initDb();
    getUsers();
  }

  late LocalDbService localDb;
  int pageSize = 8;
  int skip = 0;

  List<UserModel> userList = [];
  List<UserModel> selectedUserList = [];

  void addUserToLocalDb(UserModel user) {
    localDb.store.box<LocalUser>().put(
          LocalUser(
            imgUrl: user.avtarUrl,
            name: user.name,
            userId: user.id,
          ),
        );
  }

  void removeUserFromLocalDb(UserModel user) {
    var localUser = localDb.store
        .box<LocalUser>()
        .query(LocalUser_.userId.equals(user.id))
        .build()
        .findFirst();
    if (localUser != null) localDb.store.box<LocalUser>().remove(localUser.id);
  }

  Future<void> initDb() async {
    localDb = await LocalDbService.create();
  }

  Future<void> getUsers() async {
    emit(const HomeState.loading());
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        emit(const HomeState.error('No Internet Connection'));
      } else {
        final dio = Dio();
        final response = await dio
            .get('https://api.github.com/users?per_page=$pageSize&since=$skip');
        Iterable it = response.data;
        userList.clear();
        userList.addAll(it.map((e) => UserModel.fromJson(e)).toList());
        var localUsers = localDb.store.box<LocalUser>().getAll();
        selectedUserList.addAll(localUsers
            .map((e) =>
                UserModel(id: e.userId, name: e.name, avtarUrl: e.imgUrl))
            .toList());
        emit(HomeState.loaded(userList, selectedUserList));
      }
    } catch (e) {
      emit(const HomeState.error('Something went wrong'));
    }
  }

  Future<void> callNext() async {
    skip += pageSize;
    await getUsers();
  }

  Future<void> callPrevious() async {
    skip -= pageSize;
    await getUsers();
  }

  Future<void> addToSelectedUserList(UserModel user) async {
    emit(const HomeState.loading());
    if (selectedUserList.isEmpty) {
      selectedUserList.add(user);
      addUserToLocalDb(user);
    } else {
      if (selectedUserList.contains(user)) {
        selectedUserList.remove(user);
        removeUserFromLocalDb(user);
      } else {
        selectedUserList.add(user);
        addUserToLocalDb(user);
      }
    }
    emit(HomeState.loaded(userList, selectedUserList));
  }

  Future<void> removeAllUsers() async {
    selectedUserList.clear();
    emit(HomeState.loaded(userList, selectedUserList));
  }
}
