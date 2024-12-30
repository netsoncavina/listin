import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_listin/listins/models/listin.dart';
import 'package:flutter_listin/listins/services/listin_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'listin_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FirebaseFirestore>(), MockSpec<QuerySnapshot>(), MockSpec<CollectionReference>(), MockSpec<QueryDocumentSnapshot>()])
void main() {
  group('getListins', () {
    late FirebaseFirestore mockFirestore;
    late String uid;
    setUp(
      () {
        mockFirestore = MockFirebaseFirestore();
        MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot = MockQuerySnapshot();
        MockCollectionReference<Map<String, dynamic>> mockCollectionReference = MockCollectionReference();
        MockQueryDocumentSnapshot<Map<String, dynamic>> mockQueryDocumentSnapshot001 = MockQueryDocumentSnapshot();
        MockQueryDocumentSnapshot<Map<String, dynamic>> mockQueryDocumentSnapshot002 = MockQueryDocumentSnapshot();

        uid = "MEU_UID";

        Listin listin001 = Listin(
          id: "001",
          name: "Listin 001",
          obs: "Observação 001",
          dateCreate: DateTime.now().subtract(const Duration(days: 100)),
          dateUpdate: DateTime.now().subtract(const Duration(days: 100)),
        );
        Listin listin002 = Listin(
          id: "002",
          name: "Listin 002",
          obs: "Observação 002",
          dateCreate: DateTime.now(),
          dateUpdate: DateTime.now(),
        );

        when(mockQueryDocumentSnapshot001.data()).thenReturn(listin001.toMap());
        when(mockQueryDocumentSnapshot002.data()).thenReturn(listin002.toMap());

        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot001, mockQueryDocumentSnapshot002]);

        when(mockCollectionReference.get()).thenAnswer((_) async => mockQuerySnapshot);

        when(mockFirestore.collection(uid)).thenReturn(mockCollectionReference);
      },
    );
    test("O metodo deve retornar uma lista de Listin", () async {
      ListinService listinService = ListinService(uid: uid, firestore: mockFirestore);
      List<Listin> listins = await listinService.getListins();

      expect(listins.length, 2);
    });
  });
}
