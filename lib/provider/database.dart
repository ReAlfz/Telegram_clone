import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:telegram/model/chat_model.dart';
import 'package:telegram/model/user_model.dart';
import 'package:uuid/uuid.dart';

final userCloudProvider = AsyncNotifierProvider.family<CloudUserConfig, List<UserModel>, String>(
      () => CloudUserConfig(),
);

class CloudUserConfig extends FamilyAsyncNotifier<List<UserModel>, String> {
  String currentUid = "";
  final cloudStore = FirebaseFirestore.instance.collection('telegram');

  @override
  Future<List<UserModel>> build(String arg) async {
    currentUid = arg;
    return await getAddList();
  }

  Future<List<UserModel>> getAddList() async {
    try {
      final reference = await cloudStore.get();
      final list = reference.docs.map(
              (element) => UserModel.fromMap(element.data())
      ).where(
              (element) => element.uid != currentUid
      ).toList();
      return list;
    } catch (error, stack) {
      state = AsyncError(error, stack);
      return [];
    }
  }

  Future<UserModel?> getUser({required String currentUid}) async {
    try {
      final reference = await cloudStore.doc(currentUid).get();
      UserModel userModel = UserModel.fromMap(reference.data()!);
      return userModel;
    } catch(error, stack) {
      state = AsyncError(error, stack);
      return null;
    }
  }

  Future<void> createUser({required String username}) async {
    final reference = cloudStore.doc(currentUid);
    UserModel userModel =  UserModel(
      icon: icon[Random().nextInt(icon.length)],
      username: username,
      uid: currentUid,
    );
    await reference.set(userModel.toMap());
  }

  Future<void> clearUser() async {
    state = const AsyncData([]);
  }
  
  List icon = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQa4xjShh4ynJbrgYrW_aB4lhKSxeMzQ3cO_A&s',
    'https://static01.nyt.com/images/2022/05/19/opinion/firstpersonPromo/firstpersonPromo-superJumbo.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI5zfIf97xbPS1fVI19PPFhLmF_fIQs3t-Jg&s',
    'https://www.mnp.ca/-/media/foundation/integrations/personnel/2020/12/16/13/58/personnel-image-2152.jpg?h=800&w=600&hash=348D3CD6A11FA554AF00E5E3C0453243'
  ];
}

final userCloudProviderV2 = AsyncNotifierProvider.family<CloudUserConfigV2, List<UserModel>, String>(
      () => CloudUserConfigV2(),
);

// -------------------------------------------------------------------------- //

class CloudUserConfigV2 extends FamilyAsyncNotifier<List<UserModel>, String>{
  String currentUid = "";
  final cloudStore = FirebaseFirestore.instance.collection('telegram');

  @override
  FutureOr<List<UserModel>> build(String arg) async {
    currentUid = arg;
    return await getHomeList();
  }

  Future<List<UserModel>> getHomeList() async {
    try {
      final reference = await cloudStore
          .doc(currentUid)
          .collection("list-user-chat")
          .get();
      final list = reference.docs.map(
              (element) => UserModel.fromMap(element.data())
      ).toList();
      state = await AsyncValue.guard(() async => list);
      return list;
    } catch (error, stack) {
      state = AsyncError(error, stack);
      return [];
    }
  }
}

// -------------------------------------------------------------------------- //

final chatCloudProvider = AsyncNotifierProvider.family<CloudChatConfig, List<ChatModel>, Params>(
      () => CloudChatConfig()
);

class CloudChatConfig extends FamilyAsyncNotifier<List<ChatModel>, Params> {
  List<ChatModel> list = [];
  late Params params;
  final cloudStore = FirebaseFirestore.instance.collection('telegram');

  @override
  FutureOr<List<ChatModel>> build(Params arg) async {
    params = arg;
    try {
      list = await readData(currentUid: arg.currentUid, fromUid: arg.fromUid);
      return list;
    } catch (error, stack) {
      state = AsyncError(error, stack);
      return list;
    }
  }

  Future<List<ChatModel>> readData({
    required String currentUid,
    required String fromUid,
  }) async {
    try {
      final reference = await cloudStore.doc(params.currentUid)
          .collection("list-user-chat")
          .doc(params.fromUid)
          .collection("chat")
          .orderBy('timestamp', descending: true).get();

      List<ChatModel> data = reference.docs.map(
              (element) => ChatModel.fromMap(element.data())
      ).toList();
      return data;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> createUserForCurrentChat({required UserModel fromUser}) async {
    final reference = cloudStore
        .doc(params.currentUid)
        .collection("list-user-chat")
        .doc(params.fromUid);
    await reference.set(fromUser.toMap());
  }

  Future<void> createUserForFromChat({required UserModel fromUser}) async {
    final reference = cloudStore
        .doc(params.fromUid)
        .collection("list-user-chat")
        .doc(params.currentUid);
    await reference.set(fromUser.toMap());
  }

  Future<void> createData({
    required UserModel fromUser,
    required UserModel currentUser,
    required String text
  }) async {
    try {
      String uuid = const Uuid().v4();
      createUserForCurrentChat(fromUser: fromUser);
      createUserForFromChat(fromUser: currentUser);
      final currentUidReference = cloudStore
          .doc(params.currentUid)
          .collection("list-user-chat")
          .doc(params.fromUid)
          .collection("chat")
          .doc(uuid);


      final fromUidReference = cloudStore
          .doc(params.fromUid)
          .collection("list-user-chat")
          .doc(params.currentUid)
          .collection("chat")
          .doc(uuid);

      final currentData = ChatModel(
        text: text,
        uid: params.currentUid,
        fromUid: params.fromUid,
        sender: true,
        timestamp: Timestamp.now(),
      );

      final fromData = ChatModel(
        text: text,
        uid: params.fromUid,
        fromUid: params.currentUid,
        sender: false,
        timestamp: Timestamp.now(),
      );

      await fromUidReference.set(fromData.toMap());
      await currentUidReference.set(currentData.toMap()).then((value) async {
        state = await AsyncValue.guard(() async {
          ChatModel addLast = await addChats();
          list.add(addLast);
          return list;
        });
      });

    } catch (error) {
      rethrow;
    }
  }

  Future<ChatModel> addChats() async {
    final lastDataReference = await cloudStore
        .doc(params.currentUid)
        .collection("list-user-chat")
        .doc(params.fromUid)
        .collection("chat")
        .orderBy('timestamp', descending: true)
        .limit(1).get();

    ChatModel data = ChatModel.fromMap(lastDataReference.docs.first.data());
    return data;
  }

  String lastText() {
    return list[list.length - 1].text;
  }
}

class Params {
  final String currentUid, fromUid;
  Params({required this.currentUid, required this.fromUid});
}
