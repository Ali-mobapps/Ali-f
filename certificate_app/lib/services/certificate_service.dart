import 'dart:async';
import '../core/database_helper.dart';
import '../features/certificates/certificate_model.dart';
import 'package:uuid/uuid.dart';

class CertificateService {
  final _dbHelper = DatabaseHelper.instance;
  
  static final _certificatesController = StreamController<List<Certificate>>.broadcast();
  
  Stream<List<Certificate>> getCertificates() async* {
    final db = await _dbHelper.database;
    final result = await db.query('certificates', orderBy: 'issueDate DESC');
    yield result.map((json) => Certificate.fromMap(json)).toList();
    yield* _certificatesController.stream;
  }

  Future<void> _refreshCertificates() async {
    final db = await _dbHelper.database;
    final result = await db.query('certificates', orderBy: 'issueDate DESC');
    final list = result.map((json) => Certificate.fromMap(json)).toList();
    _certificatesController.add(list);
  }

  Future<String> issueCertificate(Certificate cert) async {
    final db = await _dbHelper.database;
    final id = const Uuid().v4();
    final newCert = Certificate(
      id: id,
      recipientName: cert.recipientName,
      recipientEmail: cert.recipientEmail,
      courseTitle: cert.courseTitle,
      description: cert.description,
      issueDate: cert.issueDate,
      expiryDate: cert.expiryDate,
      status: cert.status,
      templateId: cert.templateId,
    );
    
    await db.insert('certificates', newCert.toMap());
    _refreshCertificates();
    return id;
  }

  Future<Certificate?> verifyCertificate(String certificateId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'certificates',
      where: 'id = ?',
      whereArgs: [certificateId],
    );

    if (maps.isNotEmpty) {
      return Certificate.fromMap(maps.first);
    }
    return null;
  }

  Future<void> revokeCertificate(String certificateId) async {
    final db = await _dbHelper.database;
    await db.update(
      'certificates',
      {'status': 'Revoked'},
      where: 'id = ?',
      whereArgs: [certificateId],
    );
    _refreshCertificates();
  }
}
