import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawwismart/data/model/pet.dart';
import 'package:pawwismart/data/repositories/base_pet_repository.dart';
import 'package:pawwismart/data/repositories/storage_repository.dart';

class PetRepository extends BasePetRepository {
  final FirebaseFirestore _firebaseFirestore;

  PetRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Pet>> getPet() {
    return _firebaseFirestore.collection("Pet").where("ShareTo", arrayContains: FirebaseAuth.instance.currentUser!.uid).where("IsDelete", isEqualTo: false).snapshots().map((snap) {
      return snap.docs.map((doc) => Pet.fromSnapshot(doc)).toList();
    });
  }

  @override
  Stream<List<Pet>> getPetsFence(List<dynamic> pet) {
    return _firebaseFirestore.collection("Pet").where(FieldPath.documentId, whereIn: pet).where("IsDelete", isEqualTo: false).snapshots().map((snap) {
      return snap.docs.map((doc) => Pet.fromSnapshot(doc)).toList();
    });
  }


  @override
  Future<void> createPet(Pet pet) async {
    await _firebaseFirestore.collection('Pet').doc(pet.id).set(pet.toMap(FirebaseAuth.instance.currentUser!.uid));
  }

  @override
  Future<void> sharePet(Pet pet, String User) async {
    return _firebaseFirestore.collection('Pet').doc(pet.id).update({
      "ShareTo": FieldValue.arrayUnion([User])
    });
  }

  @override
  Future<void> removeSharePet(Pet pet, String User) async {
    return _firebaseFirestore.collection('Pet').doc(pet.id).update({
      "ShareTo": FieldValue.arrayRemove([User])
    });
  }

  @override
  Future<void> updatePet(Pet pet) async {
    return _firebaseFirestore
        .collection('Pet')
        .doc(pet.id)
        .update(pet.toMap(pet.IDUser))
        .then(
          (value) => print('Pet document updated.'),
    );
  }

  @override
  Future<void> updatePetInfo(String id, String name, String image) async {
    return _firebaseFirestore.collection('Pet').doc(id).update({
      "Name": name,
      "Image": image,
    });
  }

  @override
  Future<void> updatePetPictures(Pet pet, String imageName) async {
    String downloadUrl = await StorageRepository().getDownloadURL(pet, imageName);

    return _firebaseFirestore.collection('Pet').doc(pet.id).update({
      "IsDelete": true
    });
  }

  @override
  Future<void> deletePet(Pet pet) async {
    return _firebaseFirestore.collection('Pet').doc(pet.id).update({
      "IsDelete": true
    });
  }

  @override
  Future<void> updatePetDevice(String id, String device) async {
    return _firebaseFirestore.collection('Pet').doc(id).update({
      "IDDevice": device,
    });
  }
}
