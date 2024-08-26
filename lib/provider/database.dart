import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:telegram/model/chat.dart';
import 'package:telegram/model/user.dart';
import 'package:uuid/uuid.dart';

final userCloudProvider =
StateNotifierProvider<CloudUserConfig, AsyncValue<List<UserModel>>>(
        (ref) => CloudUserConfig(),
);

class CloudUserConfig extends StateNotifier<AsyncValue<List<UserModel>>> {
  final cloudStore = FirebaseFirestore.instance.collection('telegram');
  CloudUserConfig() : super(const AsyncValue.loading()) {
    readData();
  }

  Future<void> readData() async {
    try {
      final reference = await cloudStore.get();
      final data = reference.docs.map(
              (element) => UserModel.fromMap(element)
      ).toList();
      state = AsyncValue.data(data);
    } catch(error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  Future<void> createUser({required String? uid, required String username}) async {
    final reference = cloudStore.doc(uid);
    await reference.set({
      'uid': uid,
      'icon': icon[Random().nextInt(icon.length)],
      'username': username
    });
  }
  
  
  List icon = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQa4xjShh4ynJbrgYrW_aB4lhKSxeMzQ3cO_A&s',
    'https://static01.nyt.com/images/2022/05/19/opinion/firstpersonPromo/firstpersonPromo-superJumbo.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI5zfIf97xbPS1fVI19PPFhLmF_fIQs3t-Jg&s',
    'https://www.mnp.ca/-/media/foundation/integrations/personnel/2020/12/16/13/58/personnel-image-2152.jpg?h=800&w=600&hash=348D3CD6A11FA554AF00E5E3C0453243'
  ];
}

final chatCloudProvider =
StateNotifierProvider<CloudChatConfig, AsyncValue<List<ChatModel>>>(
      (ref) => CloudChatConfig(),
);

class CloudChatConfig extends StateNotifier<AsyncValue<List<ChatModel>>> {
  final cloudStore = FirebaseFirestore.instance.collection('telegram');

  CloudChatConfig() : super(const AsyncValue.loading()) {
    readData();
  }

  Future<void> readData() async {
    try {
      final snapshot = await cloudStore.get();
      print(snapshot.docs.map((event) => event));
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
}
