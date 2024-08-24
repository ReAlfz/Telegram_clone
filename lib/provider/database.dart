import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:telegram/model/user.dart';

final dataFirebaseProvider = StateNotifierProvider<DataConfigure, FirebaseDatabase>((ref) {
  return DataConfigure(FirebaseDatabase.instance);
});

class DataConfigure extends StateNotifier<FirebaseDatabase> {
  final FirebaseDatabase instance;
  DataConfigure(this.instance) : super(instance);

  Future<void> createUser(String? uid) async {
    final ref = instance.ref('/telegram/$uid');
    final user = UserModel(
      icon: 'test',
      username: 'test',
      uid: uid ?? '??',
    );
    await ref.set(user.toMap());
  }
}