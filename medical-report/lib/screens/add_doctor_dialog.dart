import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/doctor_model.dart';
import '../providers/doctor_provider.dart';

class AddDoctorDialog extends StatefulWidget {
  const AddDoctorDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddDoctorDialog(),
    );
  }

  @override
  State<AddDoctorDialog> createState() => _AddDoctorDialogState();
}

class _AddDoctorDialogState extends State<AddDoctorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _phoneController = TextEditingController();
  final _qualificationsController = TextEditingController();
  final _hospitalNameController = TextEditingController();
  final _hospitalAddressController = TextEditingController();
  final _pmdcController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _phoneController.dispose();
    _qualificationsController.dispose();
    _hospitalNameController.dispose();
    _hospitalAddressController.dispose();
    _pmdcController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newDoctor = DoctorModel(
        id: 'd_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        specialty: _specialtyController.text.trim(),
        phone: _phoneController.text.trim(),
        whatsapp: _phoneController.text.replaceAll(RegExp(r'\D'), ''),
        qualifications: _qualificationsController.text.trim(),
        hospitalName: _hospitalNameController.text.trim(),
        hospitalAddress: _hospitalAddressController.text.trim(),
        pmdcNo: _pmdcController.text.trim(),
        photoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDyjodeL5OdVcyt4MGyz1IFvEW7pZ64nd3caLa9v8FwM6QdY0bwALfC7DNctQ4pZ-TkkY1C_D7Y6ZIVZsVoJOhCNa_CLxJ5cRBI-eewDRTGz1gucYuAWCr7T5aWziVGJypf-lxtUkkfJS6vMsCvx8bNkESVLdhQPDuopYGl85hGK1qIq3ur4O78S34DWGvCAF5m8mq9TAmqchNW9Dvw98_PJM2wh0m_0-QIRjjI_O3F',
      );

      Provider.of<DoctorProvider>(context, listen: false).addDoctor(newDoctor);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Doctor ${newDoctor.name} added successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Doctor', style: TextStyle(fontWeight: FontWeight.bold)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Doctor Name *', hintText: 'e.g. Dr. Ahmed Khan'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _specialtyController,
                decoration: const InputDecoration(labelText: 'Specialty *', hintText: 'e.g. Cardiology'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number *', hintText: '+92 300 1234567'),
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _qualificationsController,
                decoration: const InputDecoration(labelText: 'Qualifications', hintText: 'e.g. FCPS • MRCP'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _hospitalNameController,
                decoration: const InputDecoration(labelText: 'Hospital / Clinic *', hintText: 'City Medical Hospital'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _hospitalAddressController,
                decoration: const InputDecoration(labelText: 'Hospital Address', hintText: 'Jail Road, Lahore'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _pmdcController,
                decoration: const InputDecoration(labelText: 'PMDC / Reg Registration No.', hintText: '12894-P'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Save Doctor'),
        ),
      ],
    );
  }
}
