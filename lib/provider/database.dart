import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:telegram/model/chat.dart';
import 'package:telegram/model/user.dart';
import 'package:uuid/uuid.dart';

final userCloudProvider = AsyncNotifierProvider<CloudUserConfig, List<UserModel>>(
      () => CloudUserConfig(),
);

class CloudUserConfig extends AsyncNotifier<List<UserModel>> {
  final List<UserModel> list = [];
  final cloudStore = FirebaseFirestore.instance.collection('telegram');

  @override
  FutureOr<List<UserModel>> build() async {
    return await getUser();
  }

  Future<void> getList(UserModel data) async {
    try {
      list.add(data);
      state = await AsyncValue.guard(() async => list);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }

  Future<List<UserModel>> getUser() async {
    try {
      final reference = await cloudStore.get();
      final data = reference.docs.map(
              (element) => UserModel.fromMap(element)
      ).toList();
      state = await AsyncValue.guard(() async {
        list.addAll(data);
        return list;
      });

      return list;
    } catch(error, stack) {
      state = AsyncError(error, stack);
      return [];
    }
  }

  Future<void> createUser({required String? uid, required String username}) async {
    final reference = cloudStore.doc(uid);
    await reference.set({
      'uid': uid,
      'username': username,
      'icon': icon[Random().nextInt(icon.length)],
    });
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
      final reference = await cloudStore.doc(currentUid).collection(fromUid)
          .orderBy('timestamp', descending: true).get();

      List<ChatModel> data = reference.docs.map(
              (element) {
                print(element.data());
                return ChatModel.fromMap(element.data());
              }
      ).toList();
      return data;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> createData({
    required String text
  }) async {
    try {
      String uuid = const Uuid().v4();
      final currentUidReference = cloudStore.doc(params.currentUid).collection(params.fromUid).doc(uuid);
      final fromUidReference = cloudStore.doc(params.fromUid).collection(params.currentUid).doc(uuid);

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
    final lastDataReference = await cloudStore.doc(params.currentUid)
        .collection(params.fromUid).orderBy('timestamp', descending: true)
        .limit(1).get();

    ChatModel data = ChatModel.fromMap(lastDataReference.docs.first.data());
    return data;
  }
}

class Params {
  final String currentUid, fromUid;
  Params({required this.currentUid, required this.fromUid});
}
