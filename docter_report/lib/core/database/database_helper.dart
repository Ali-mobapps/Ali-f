import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/doctor_model.dart';
import '../../models/medical_visit_model.dart';
import '../../models/prescription_model.dart';
import '../../models/report_model.dart';
import '../../models/vital_signs_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'medical_history.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE doctors (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        specialty TEXT NOT NULL,
        hospital TEXT NOT NULL,
        avatar_url TEXT,
        phone TEXT,
        email TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE visits (
        id TEXT PRIMARY KEY,
        doctor_id TEXT NOT NULL,
        doctor_name TEXT NOT NULL,
        doctor_specialty TEXT NOT NULL,
        doctor_hospital TEXT NOT NULL,
        doctor_avatar_url TEXT,
        visit_date TEXT NOT NULL,
        time_str TEXT NOT NULL,
        consultation_type TEXT NOT NULL,
        reason TEXT NOT NULL,
        symptoms_json TEXT,
        diagnosis TEXT NOT NULL,
        bp TEXT,
        heart_rate TEXT,
        temperature TEXT,
        weight TEXT,
        blood_sugar TEXT,
        spo2 TEXT,
        follow_up_date TEXT,
        notes TEXT,
        is_synced INTEGER DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE prescriptions (
        id TEXT PRIMARY KEY,
        visit_id TEXT NOT NULL,
        medicine_name TEXT NOT NULL,
        dosage TEXT NOT NULL,
        frequency TEXT NOT NULL,
        duration TEXT NOT NULL,
        is_active INTEGER DEFAULT 1,
        notes TEXT,
        FOREIGN KEY (visit_id) REFERENCES visits (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE reports (
        id TEXT PRIMARY KEY,
        visit_id TEXT,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        file_path TEXT NOT NULL,
        file_type TEXT NOT NULL,
        file_size TEXT NOT NULL,
        date_added TEXT NOT NULL
      )
    ''');

    await _seedInitialData(db);
  }

  Future<void> _seedInitialData(Database db) async {
    // 1. Seed Doctors
    final doc1 = DoctorModel(
      id: 'doc_1',
      name: 'Dr. Ahmed Khan',
      specialty: 'Cardiologist',
      hospital: 'City Medical Hospital • OPD Wing B',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCPufSjLZ63TcoaEONDp1_PY6W0qV0tlRqMWoAX1TRaFsP0TnEEAfoZDE1C5nbplHkK7A9O-1tljXwv0GL2A3y3W6GsuqtBK9vKpfa38kffOdSWq4QHIH0rbotoWN104LeZb0V7S404zuBiySeyW_9LNgH3vFW0FfwQJ8BgnMIx2z_yFaud61JLv8j04FhdAIZrh00_PpsoQKrpEx3DgCPatjjdlkE3xYQVWOWV3LcZE_20f-t5eDaI',
      phone: '+92 300 1234567',
      email: 'ahmed.khan@cityhospital.com',
    );

    final doc2 = DoctorModel(
      id: 'doc_2',
      name: 'Dr. Sara Ahmed',
      specialty: 'Neurologist',
      hospital: 'National Hospital & Medical Centre',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBq-h9MD8rgFr8G2MMFhQJ-pd8FCpVZOxzQwVZFUkXUrS6gciDmcIGnD2HC4rLX_8mSHunpD3ZTcTDSb0WeeCHFVSsJGYmESkADqAM1iy-uMjS8sV7kj6KfqtustmC7L39UmPnIaA4RvuitFkEjos1OXVeKPBXo4XXk5cgT8Z5tHA-1Cooo55qBfBz4K1QcV4B8c3BO5ntqQdnqu9eaueZzJDb_qg1bcR4W2rBqwQRXbX3C1QTqAzqc',
      phone: '+92 321 9876543',
      email: 'sara.ahmed@nhmc.org',
    );

    final doc3 = DoctorModel(
      id: 'doc_3',
      name: 'Dr. Usman Ali',
      specialty: 'General Physician',
      hospital: 'Medicare Clinic',
      avatarUrl: null,
      phone: '+92 333 5551212',
      email: 'usman.ali@medicare.com',
    );

    final doc4 = DoctorModel(
      id: 'doc_4',
      name: 'Dr. Fatima Tariq',
      specialty: 'Pulmonologist',
      hospital: 'Shaukat Khanum Health Clinic',
      avatarUrl: null,
      phone: '+92 345 6677889',
      email: 'fatima@skhc.org',
    );

    final doc5 = DoctorModel(
      id: 'doc_5',
      name: 'Dr. Bilal Hassan',
      specialty: 'Orthopedic Surgeon',
      hospital: 'Bone & Joint Institute',
      avatarUrl: null,
      phone: '+92 301 4433221',
      email: 'bilal@bonejoint.pk',
    );

    for (var doc in [doc1, doc2, doc3, doc4, doc5]) {
      await db.insert('doctors', doc.toMap());
    }

    // 2. Seed Visits
    final visit1 = MedicalVisitModel(
      id: 'visit_1',
      doctorId: doc1.id,
      doctorName: doc1.name,
      doctorSpecialty: doc1.specialty,
      doctorHospital: doc1.hospital,
      doctorAvatarUrl: doc1.avatarUrl,
      visitDate: DateTime.now().add(const Duration(days: 3)),
      timeStr: '10:30 AM',
      consultationType: 'In-Person',
      reason: 'Routine Cardiology Follow-up & ECG Review',
      symptoms: ['Mild Chest Pressure', 'Occasional Palpitations'],
      diagnosis: 'Controlled Mild Hypertension with Normal Sinus Rhythm',
      vitals: VitalSignsModel(
        bloodPressure: '128/82 mmHg',
        heartRate: '72 bpm',
        temperature: '98.6 °F',
        weight: '74 kg',
        bloodSugar: '95 mg/dL',
        spo2: '99%',
      ),
      prescriptions: [
        PrescriptionModel(
          id: 'rx_1',
          visitId: 'visit_1',
          medicineName: 'Amlovas (Amlodipine)',
          dosage: '5 mg',
          frequency: 'Once Daily (Morning)',
          duration: '30 Days',
          isActive: true,
        ),
        PrescriptionModel(
          id: 'rx_2',
          visitId: 'visit_1',
          medicineName: 'Aspirin Low Dose',
          dosage: '75 mg',
          frequency: 'Once Daily (After Lunch)',
          duration: '30 Days',
          isActive: true,
        ),
      ],
      reports: [
        ReportModel(
          id: 'rep_1',
          visitId: 'visit_1',
          title: '12-Lead Electrocardiogram (ECG)',
          category: 'Radiology / Scans',
          filePath: 'ecg_report_oct2023.pdf',
          fileType: 'pdf',
          fileSize: '1.8 MB',
          dateAdded: DateTime.now().subtract(const Duration(days: 5)),
        ),
        ReportModel(
          id: 'rep_2',
          visitId: 'visit_1',
          title: 'Comprehensive Lipid Profile',
          category: 'Lab Report',
          filePath: 'lipid_profile_oct.pdf',
          fileType: 'pdf',
          fileSize: '2.4 MB',
          dateAdded: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ],
      followUpDate: DateTime.now().add(const Duration(days: 3)),
      notes: 'Patient advised to continue low-sodium diet and daily 30-min light walk.',
    );

    final visit2 = MedicalVisitModel(
      id: 'visit_2',
      doctorId: doc2.id,
      doctorName: doc2.name,
      doctorSpecialty: doc2.specialty,
      doctorHospital: doc2.hospital,
      doctorAvatarUrl: doc2.avatarUrl,
      visitDate: DateTime.now().subtract(const Duration(days: 14)),
      timeStr: '02:15 PM',
      consultationType: 'In-Person',
      reason: 'Recurrent Migraine & Tension Headaches',
      symptoms: ['Throbbing Headache', 'Photophobia', 'Nausea'],
      diagnosis: 'Acute Migraine Episode - Stress-Induced',
      vitals: VitalSignsModel(
        bloodPressure: '120/78 mmHg',
        heartRate: '68 bpm',
        temperature: '98.2 °F',
        weight: '74 kg',
      ),
      prescriptions: [
        PrescriptionModel(
          id: 'rx_3',
          visitId: 'visit_2',
          medicineName: 'Sumatriptan',
          dosage: '50 mg',
          frequency: 'As needed during headache onset',
          duration: '10 Days',
          isActive: true,
        ),
        PrescriptionModel(
          id: 'rx_4',
          visitId: 'visit_2',
          medicineName: 'Neurobion Forte',
          dosage: '1 Tablet',
          frequency: 'Once Daily',
          duration: '15 Days',
          isActive: true,
        ),
      ],
      reports: [
        ReportModel(
          id: 'rep_3',
          visitId: 'visit_2',
          title: 'Brain MRI Scan (Contrast)',
          category: 'Radiology / Scans',
          filePath: 'brain_mri_sept2023.pdf',
          fileType: 'pdf',
          fileSize: '12.5 MB',
          dateAdded: DateTime.now().subtract(const Duration(days: 14)),
        ),
      ],
      notes: 'Advised stress reduction techniques and keeping a headache diary.',
    );

    final visit3 = MedicalVisitModel(
      id: 'visit_3',
      doctorId: doc3.id,
      doctorName: doc3.name,
      doctorSpecialty: doc3.specialty,
      doctorHospital: doc3.hospital,
      doctorAvatarUrl: doc3.avatarUrl,
      visitDate: DateTime.now().subtract(const Duration(days: 45)),
      timeStr: '11:00 AM',
      consultationType: 'In-Person',
      reason: 'Annual Executive Health Checkup',
      symptoms: ['General Fatigue'],
      diagnosis: 'Vitamin D Deficiency & Normal Baseline Parameters',
      vitals: VitalSignsModel(
        bloodPressure: '118/76 mmHg',
        heartRate: '70 bpm',
        temperature: '98.4 °F',
        weight: '73.5 kg',
        bloodSugar: '88 mg/dL',
      ),
      prescriptions: [
        PrescriptionModel(
          id: 'rx_5',
          visitId: 'visit_3',
          medicineName: 'Sunny D Softgel (Vitamin D3)',
          dosage: '200,000 IU',
          frequency: 'Once Every 2 Weeks',
          duration: '2 Months',
          isActive: true,
        ),
      ],
      reports: [
        ReportModel(
          id: 'rep_4',
          visitId: 'visit_3',
          title: 'Complete Blood Count (CBC) & Serum Vit-D',
          category: 'Lab Report',
          filePath: 'cbc_vitd_report.pdf',
          fileType: 'pdf',
          fileSize: '3.1 MB',
          dateAdded: DateTime.now().subtract(const Duration(days: 45)),
        ),
      ],
    );

    for (var visit in [visit1, visit2, visit3]) {
      await db.insert('visits', visit.toMap());
      for (var rx in visit.prescriptions) {
        await db.insert('prescriptions', rx.toMap());
      }
      for (var rep in visit.reports) {
        await db.insert('reports', rep.toMap());
      }
    }
  }

  // --- CRUD Operations ---

  Future<List<DoctorModel>> getAllDoctors() async {
    final db = await database;
    final maps = await db.query('doctors', orderBy: 'name ASC');
    return maps.map((map) => DoctorModel.fromMap(map)).toList();
  }

  Future<void> insertDoctor(DoctorModel doctor) async {
    final db = await database;
    await db.insert(
      'doctors',
      doctor.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MedicalVisitModel>> getAllVisits({
    String? searchQuery,
    String? categoryFilter,
    String? doctorIdFilter,
  }) async {
    final db = await database;

    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      whereClause += ''' AND (
        doctor_name LIKE ? OR
        doctor_specialty LIKE ? OR
        diagnosis LIKE ? OR
        reason LIKE ?
      )''';
      final q = '%${searchQuery.trim()}%';
      whereArgs.addAll([q, q, q, q]);
    }

    if (categoryFilter != null &&
        categoryFilter.isNotEmpty &&
        categoryFilter != 'All') {
      whereClause += ' AND doctor_specialty LIKE ?';
      whereArgs.add('%$categoryFilter%');
    }

    if (doctorIdFilter != null && doctorIdFilter.isNotEmpty) {
      whereClause += ' AND doctor_id = ?';
      whereArgs.add(doctorIdFilter);
    }

    final visitMaps = await db.query(
      'visits',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'visit_date DESC',
    );

    List<MedicalVisitModel> visits = [];

    for (var map in visitMaps) {
      final visitId = map['id'] as String;

      final rxMaps = await db.query(
        'prescriptions',
        where: 'visit_id = ?',
        whereArgs: [visitId],
      );
      final prescriptions =
          rxMaps.map((m) => PrescriptionModel.fromMap(m)).toList();

      final repMaps = await db.query(
        'reports',
        where: 'visit_id = ?',
        whereArgs: [visitId],
      );
      final reports = repMaps.map((m) => ReportModel.fromMap(m)).toList();

      visits.add(MedicalVisitModel.fromMap(
        map,
        prescriptions: prescriptions,
        reports: reports,
      ));
    }

    return visits;
  }

  Future<MedicalVisitModel?> getVisitById(String id) async {
    final db = await database;
    final maps = await db.query('visits', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;

    final rxMaps =
        await db.query('prescriptions', where: 'visit_id = ?', whereArgs: [id]);
    final prescriptions =
        rxMaps.map((m) => PrescriptionModel.fromMap(m)).toList();

    final repMaps =
        await db.query('reports', where: 'visit_id = ?', whereArgs: [id]);
    final reports = repMaps.map((m) => ReportModel.fromMap(m)).toList();

    return MedicalVisitModel.fromMap(
      maps.first,
      prescriptions: prescriptions,
      reports: reports,
    );
  }

  Future<void> insertVisit(MedicalVisitModel visit) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert('visits', visit.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

      final docCheck = await txn
          .query('doctors', where: 'id = ?', whereArgs: [visit.doctorId]);
      if (docCheck.isEmpty) {
        await txn.insert(
          'doctors',
          DoctorModel(
            id: visit.doctorId,
            name: visit.doctorName,
            specialty: visit.doctorSpecialty,
            hospital: visit.doctorHospital,
            avatarUrl: visit.doctorAvatarUrl,
          ).toMap(),
        );
      }

      for (var rx in visit.prescriptions) {
        await txn.insert('prescriptions', rx.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }

      for (var rep in visit.reports) {
        await txn.insert('reports', rep.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<void> deleteVisit(String id) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('prescriptions', where: 'visit_id = ?', whereArgs: [id]);
      await txn.delete('reports', where: 'visit_id = ?', whereArgs: [id]);
      await txn.delete('visits', where: 'id = ?', whereArgs: [id]);
    });
  }

  Future<List<PrescriptionModel>> getActivePrescriptions() async {
    final db = await database;
    final maps = await db.query('prescriptions', where: 'is_active = 1');
    return maps.map((m) => PrescriptionModel.fromMap(m)).toList();
  }

  Future<List<ReportModel>> getAllReports({String? category, String? search}) async {
    final db = await database;
    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    if (category != null && category.isNotEmpty && category != 'All') {
      whereClause += ' AND category LIKE ?';
      whereArgs.add('%$category%');
    }

    if (search != null && search.trim().isNotEmpty) {
      whereClause += ' AND title LIKE ?';
      whereArgs.add('%${search.trim()}%');
    }

    final maps = await db.query(
      'reports',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'date_added DESC',
    );
    return maps.map((m) => ReportModel.fromMap(m)).toList();
  }

  Future<void> insertReport(ReportModel report) async {
    final db = await database;
    await db.insert('reports', report.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteReport(String id) async {
    final db = await database;
    await db.delete('reports', where: 'id = ?', whereArgs: [id]);
  }
}
