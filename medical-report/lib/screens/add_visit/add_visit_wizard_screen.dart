import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/doctor_model.dart';
import '../../models/visit_model.dart';
import '../../models/medicine_model.dart';
import '../../models/lab_test_model.dart';
import '../../providers/doctor_provider.dart';
import '../../providers/visit_provider.dart';
import '../../theme/app_theme.dart';
import '../add_doctor_dialog.dart';

class AddVisitWizardScreen extends StatefulWidget {
  final DoctorModel? selectedDoctor;

  const AddVisitWizardScreen({super.key, this.selectedDoctor});

  @override
  State<AddVisitWizardScreen> createState() => _AddVisitWizardScreenState();
}

class _AddVisitWizardScreenState extends State<AddVisitWizardScreen> {
  int _currentStep = 1;

  DoctorModel? _doctor;
  final _doctorNameController = TextEditingController();
  final _doctorSpecialtyController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _doctorNotesController = TextEditingController();
  final _visitDateController = TextEditingController(text: '06 Oct 2026');
  final _followUpDateController = TextEditingController(text: '24 Oct 2026');

  // Step 4 Medicines
  final List<MedicineModel> _medicines = [];

  // Medicine Form Controllers
  final _medNameController = TextEditingController();
  final _medGenericController = TextEditingController();
  final _medDosageController = TextEditingController(text: '500 mg');
  final _medFreqController = TextEditingController(text: '2x / day');
  final _medDurationController = TextEditingController(text: '5 Days');
  String _medMealInstruction = 'After Meal';

  // Step 5 Tests
  final List<LabTestModel> _labTests = [];
  final _testNameController = TextEditingController();
  final _labNameController = TextEditingController();
  String _testResultStatus = 'Normal';

  @override
  void initState() {
    super.initState();
    _doctor = widget.selectedDoctor;
    if (_doctor != null) {
      _doctorNameController.text = _doctor!.name;
      _doctorSpecialtyController.text = _doctor!.specialty;
      _hospitalController.text = _doctor!.hospitalName;
    } else {
      _doctorNameController.text = 'Dr. Ahmed Khan';
      _doctorSpecialtyController.text = 'Consultant Cardiologist';
      _hospitalController.text = 'City Medical Hospital';
      _symptomsController.text = 'High Fever, Cough & Body Pain';
      _diagnosisController.text = 'Viral Infection';
    }

    // Default pre-populated medicines
    _medicines.add(
      MedicineModel(
        id: 'm_panadol',
        visitId: '',
        name: 'Panadol',
        genericName: 'Paracetamol',
        dosage: '500 mg',
        frequency: '2x / day',
        duration: '5 Days',
        mealInstruction: 'After Meal',
        timingNotes: 'Morning • Night',
        warningNotes: 'Take with full glass of water after food.',
      ),
    );

    _medicines.add(
      MedicineModel(
        id: 'm_hydryllin',
        visitId: '',
        name: 'Hydryllin Syrup',
        genericName: 'Cough Relief',
        dosage: '2 tsp (10ml)',
        frequency: '3x / day',
        duration: '7 Days',
        mealInstruction: 'Before Bed / After Meal',
        timingNotes: 'Morning • Night',
        warningNotes: 'Causes Drowsiness. Avoid driving.',
      ),
    );

    // Default pre-populated test
    _labTests.add(
      LabTestModel(
        id: 't_cbc',
        visitId: '',
        testName: 'CBC (Complete Blood Count)',
        labName: 'National Diagnostics',
        testDate: '06 Oct 2026',
        resultStatus: 'Normal',
        summary: 'Hemoglobin 14.2 g/dL, WBC Count 6.8',
      ),
    );
  }

  @override
  void dispose() {
    _doctorNameController.dispose();
    _doctorSpecialtyController.dispose();
    _hospitalController.dispose();
    _symptomsController.dispose();
    _diagnosisController.dispose();
    _doctorNotesController.dispose();
    _visitDateController.dispose();
    _followUpDateController.dispose();
    _medNameController.dispose();
    _medGenericController.dispose();
    _medDosageController.dispose();
    _medFreqController.dispose();
    _medDurationController.dispose();
    _testNameController.dispose();
    _labNameController.dispose();
    super.dispose();
  }

  void _addMedicine() {
    if (_medNameController.text.trim().isNotEmpty) {
      setState(() {
        _medicines.add(
          MedicineModel(
            id: 'm_${DateTime.now().millisecondsSinceEpoch}',
            visitId: '',
            name: _medNameController.text.trim(),
            genericName: _medGenericController.text.trim(),
            dosage: _medDosageController.text.trim(),
            frequency: _medFreqController.text.trim(),
            duration: _medDurationController.text.trim(),
            mealInstruction: _medMealInstruction,
          ),
        );
        _medNameController.clear();
        _medGenericController.clear();
      });
      Navigator.pop(context);
    }
  }

  void _showAddMedicineBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Prescribed Medicine', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(controller: _medNameController, decoration: const InputDecoration(labelText: 'Medicine Name *', hintText: 'e.g. Panadol')),
              const SizedBox(height: 10),
              TextField(controller: _medGenericController, decoration: const InputDecoration(labelText: 'Generic Formula', hintText: 'e.g. Paracetamol')),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: TextField(controller: _medDosageController, decoration: const InputDecoration(labelText: 'Dosage'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: _medFreqController, decoration: const InputDecoration(labelText: 'Frequency'))),
                ],
              ),
              const SizedBox(height: 10),
              TextField(controller: _medDurationController, decoration: const InputDecoration(labelText: 'Duration')),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _medMealInstruction,
                decoration: const InputDecoration(labelText: 'Meal Instruction'),
                items: const [
                  DropdownMenuItem(value: 'After Meal', child: Text('After Meal')),
                  DropdownMenuItem(value: 'Before Meal', child: Text('Before Meal')),
                  DropdownMenuItem(value: 'Before Bed', child: Text('Before Bed')),
                  DropdownMenuItem(value: 'With Food', child: Text('With Food')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setModalState(() => _medMealInstruction = val);
                    setState(() => _medMealInstruction = val);
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addMedicine,
                child: const Text('Add to Prescription'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addLabTest() {
    if (_testNameController.text.trim().isNotEmpty) {
      setState(() {
        _labTests.add(
          LabTestModel(
            id: 't_${DateTime.now().millisecondsSinceEpoch}',
            visitId: '',
            testName: _testNameController.text.trim(),
            labName: _labNameController.text.trim().isNotEmpty ? _labNameController.text.trim() : 'Diagnostic Lab',
            testDate: _visitDateController.text,
            resultStatus: _testResultStatus,
          ),
        );
        _testNameController.clear();
        _labNameController.clear();
      });
      Navigator.pop(context);
    }
  }

  void _showAddTestBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Medical Test / Report', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(controller: _testNameController, decoration: const InputDecoration(labelText: 'Test Name *', hintText: 'e.g. CBC, Blood Sugar, MRI, LFTs')),
              const SizedBox(height: 10),
              TextField(controller: _labNameController, decoration: const InputDecoration(labelText: 'Lab Name', hintText: 'e.g. Chughtai Lab, National Diagnostics')),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _testResultStatus,
                decoration: const InputDecoration(labelText: 'Result Status'),
                items: const [
                  DropdownMenuItem(value: 'Normal', child: Text('Normal')),
                  DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'Clear', child: Text('Clear')),
                  DropdownMenuItem(value: 'Abnormal', child: Text('Abnormal')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setModalState(() => _testResultStatus = val);
                    setState(() => _testResultStatus = val);
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addLabTest,
                child: const Text('Add Test to Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveCompleteVisit() async {
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);

    final docName = _doctorNameController.text.trim().isNotEmpty
        ? _doctorNameController.text.trim()
        : (_doctor?.name ?? 'Dr. Ahmed Khan');

    final docSpecialty = _doctorSpecialtyController.text.trim().isNotEmpty
        ? _doctorSpecialtyController.text.trim()
        : (_doctor?.specialty ?? 'Consultant Cardiologist');

    final hospitalName = _hospitalController.text.trim().isNotEmpty
        ? _hospitalController.text.trim()
        : 'City Medical Hospital';

    // Check if doctor exists in care team, else auto-register doctor
    DoctorModel? finalDoctor = _doctor;
    if (finalDoctor == null) {
      final existingDoc = doctorProvider.doctors.where((d) => d.name.toLowerCase() == docName.toLowerCase()).firstOrNull;
      if (existingDoc != null) {
        finalDoctor = existingDoc;
      } else {
        // Auto-create new doctor
        finalDoctor = DoctorModel(
          id: 'd_${DateTime.now().millisecondsSinceEpoch}',
          name: docName,
          specialty: docSpecialty,
          phone: '+92 300 0000000',
          qualifications: 'MBBS, Specialist',
          hospitalName: hospitalName,
          hospitalAddress: 'Main Hospital Road',
          photoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDyjodeL5OdVcyt4MGyz1IFvEW7pZ64nd3caLa9v8FwM6QdY0bwALfC7DNctQ4pZ-TkkY1C_D7Y6ZIVZsVoJOhCNa_CLxJ5cRBI-eewDRTGz1gucYuAWCr7T5aWziVGJypf-lxtUkkfJS6vMsCvx8bNkESVLdhQPDuopYGl85hGK1qIq3ur4O78S34DWGvCAF5m8mq9TAmqchNW9Dvw98_PJM2wh0m_0-QIRjjI_O3F',
        );
        await doctorProvider.addDoctor(finalDoctor);
      }
    }

    final newVisit = MedicalVisitModel(
      id: 'v_${DateTime.now().millisecondsSinceEpoch}',
      doctorId: finalDoctor.id,
      doctorName: docName,
      specialty: docSpecialty,
      hospitalName: hospitalName,
      visitDate: _visitDateController.text.isNotEmpty ? _visitDateController.text : '06 Oct 2026',
      symptoms: _symptomsController.text.isNotEmpty ? _symptomsController.text : 'Routine Checkup',
      diagnosis: _diagnosisController.text.isNotEmpty ? _diagnosisController.text : 'Health Assessment',
      doctorNotes: _doctorNotesController.text,
      followUpDate: _followUpDateController.text,
      prescriptionPdfPath: 'Rx_${docName.replaceAll(' ', '')}_2026.pdf',
      medicines: _medicines,
      labTests: _labTests,
      syncStatus: 'Completed',
    );

    await Provider.of<VisitProvider>(context, listen: false).addVisit(newVisit);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medical visit & tests saved successfully to vault!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Medical Record'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Stepper Header Bar
            Container(
              color: AppColors.surfaceContainerLowest,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Step $_currentStep of 6', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.secondaryFixed.withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
                        child: const Text('Active Step', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildStepIndicator(1, 'Doctor'),
                        _buildStepDivider(),
                        _buildStepIndicator(2, 'Location'),
                        _buildStepDivider(),
                        _buildStepIndicator(3, 'Visit'),
                        _buildStepDivider(),
                        _buildStepIndicator(4, 'Medicines'),
                        _buildStepDivider(),
                        _buildStepIndicator(5, 'Tests'),
                        _buildStepDivider(),
                        _buildStepIndicator(6, 'Review'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Wizard Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildCurrentStepContent(doctorProvider.doctors),
              ),
            ),

            // Persistent Bottom Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
              ),
              child: Row(
                children: [
                  if (_currentStep > 1)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _currentStep--),
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentStep > 1) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentStep < 6) {
                          setState(() => _currentStep++);
                        } else {
                          _saveCompleteVisit();
                        }
                      },
                      child: Text(_currentStep == 6 ? 'Save Record' : 'Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final bool isDone = step < _currentStep;
    final bool isActive = step == _currentStep;

    return GestureDetector(
      onTap: () => setState(() => _currentStep = step),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: isDone
                ? AppColors.secondary
                : isActive
                    ? AppColors.primary
                    : AppColors.surfaceContainerHigh,
            child: isDone
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : Text('$step', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isActive ? Colors.white : AppColors.onSurfaceVariant)),
          ),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: isActive ? AppColors.primary : AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildStepDivider() {
    return Container(width: 16, height: 1, color: AppColors.outlineVariant, margin: const EdgeInsets.symmetric(horizontal: 4));
  }

  Widget _buildCurrentStepContent(List<DoctorModel> doctors) {
    switch (_currentStep) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select or Enter Doctor', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Choose an existing doctor from your care team or enter a new doctor name.', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 16),

            // Doctor Selection Chips
            if (doctors.isNotEmpty) ...[
              const Text('Select Existing Care Team Doctor:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary)),
              const SizedBox(height: 8),
              SizedBox(
                height: 72,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doc = doctors[index];
                    final isSelected = _doctor?.id == doc.id || _doctorNameController.text == doc.name;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _doctor = doc;
                          _doctorNameController.text = doc.name;
                          _doctorSpecialtyController.text = doc.specialty;
                          _hospitalController.text = doc.hospitalName;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.secondaryFixed : AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(doc.photoUrl ?? ''),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(doc.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isSelected ? AppColors.primary : AppColors.onSurface)),
                                Text(doc.specialty, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Editable Doctor Name Field
            TextField(
              controller: _doctorNameController,
              decoration: const InputDecoration(
                labelText: 'Doctor Name *',
                hintText: 'e.g. Dr. Ahmed Khan',
                prefixIcon: Icon(Icons.person, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 12),

            // Editable Specialty Field
            TextField(
              controller: _doctorSpecialtyController,
              decoration: const InputDecoration(
                labelText: 'Specialty',
                hintText: 'e.g. Consultant Cardiologist',
                prefixIcon: Icon(Icons.medical_services, color: AppColors.secondary),
              ),
            ),
            const SizedBox(height: 16),

            // Add New Doctor Action
            OutlinedButton.icon(
              onPressed: () => AddDoctorDialog.show(context),
              icon: const Icon(Icons.person_add, color: AppColors.primary),
              label: const Text('+ Add New Doctor to Care Team', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hospital / Clinic Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _hospitalController,
              decoration: const InputDecoration(
                labelText: 'Hospital or Clinic Name *',
                hintText: 'e.g. City Medical Hospital',
                prefixIcon: Icon(Icons.apartment, color: AppColors.primary),
              ),
            ),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Visit Details & Diagnosis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _visitDateController,
              decoration: const InputDecoration(
                labelText: 'Visit Date',
                hintText: '06 Oct 2026',
                prefixIcon: Icon(Icons.calendar_today, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _symptomsController,
              decoration: const InputDecoration(
                labelText: 'Chief Symptoms',
                hintText: 'High Fever, Cough & Body Pain',
                prefixIcon: Icon(Icons.sick, color: AppColors.secondary),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _diagnosisController,
              decoration: const InputDecoration(
                labelText: 'Diagnosis *',
                hintText: 'Viral Infection',
                prefixIcon: Icon(Icons.health_and_safety, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _doctorNotesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Doctor Advice & Notes',
                hintText: 'Rest for 3 days, drink warm fluids...',
                prefixIcon: Icon(Icons.note_alt, color: AppColors.outline),
              ),
            ),
          ],
        );
      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Prescribed Medicines', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Manage dose schedules & instructions', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                  ],
                ),
                Chip(label: Text('${_medicines.length} Added')),
              ],
            ),
            const SizedBox(height: 16),
            ..._medicines.map((med) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(med.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                              onPressed: () => setState(() => _medicines.remove(med)),
                            ),
                          ],
                        ),
                        if (med.genericName != null) Text('(${med.genericName})', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.onSurfaceVariant)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildMedPill('Dosage', med.dosage),
                            const SizedBox(width: 8),
                            _buildMedPill('Frequency', med.frequency),
                            const SizedBox(width: 8),
                            _buildMedPill('Duration', med.duration),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(6)),
                          child: Text(med.mealInstruction, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _showAddMedicineBottomSheet,
              icon: const Icon(Icons.add_circle, color: AppColors.primary),
              label: const Text('Add Another Medicine', style: TextStyle(color: AppColors.primary)),
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            ),
          ],
        );
      case 5:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Attached Medical Tests & Reports', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Add lab assays, blood tests & diagnostic scans', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                  ],
                ),
                Chip(label: Text('${_labTests.length} Tests')),
              ],
            ),
            const SizedBox(height: 16),

            // Tests List
            ..._labTests.map((test) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const Icon(Icons.biotech, color: AppColors.primary, size: 28),
                    title: Text(test.testName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    subtitle: Text('${test.labName} • ${test.testDate}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: test.resultStatus == 'Normal' || test.resultStatus == 'Clear'
                                ? AppColors.tertiaryFixed
                                : AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(test.resultStatus, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                          onPressed: () => setState(() => _labTests.remove(test)),
                        ),
                      ],
                    ),
                  ),
                )),

            const SizedBox(height: 12),

            // Add Test Button
            OutlinedButton.icon(
              onPressed: _showAddTestBottomSheet,
              icon: const Icon(Icons.add_circle, color: AppColors.primary),
              label: const Text('+ Add Medical Test', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            ),
          ],
        );
      case 6:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Review & Save Record', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Doctor: ${_doctorNameController.text.trim().isNotEmpty ? _doctorNameController.text : "Dr. Ahmed Khan"}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Specialty: ${_doctorSpecialtyController.text}', style: const TextStyle(color: AppColors.secondary)),
                  Text('Hospital: ${_hospitalController.text}'),
                  Text('Diagnosis: ${_diagnosisController.text}'),
                  const Divider(height: 20),
                  Text('Medicines: ${_medicines.length} prescribed'),
                  Text('Tests: ${_labTests.length} attached'),
                ],
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMedPill(String title, String val) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant)),
            Text(val, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
