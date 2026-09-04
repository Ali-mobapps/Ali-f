import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:salespro_saas_admin/model/general_setting_model.dart';

import '../../../Provider/general_setting_provider.dart';
import '../../Widgets/Constant Data/constant.dart';
import '../../Widgets/Constant Data/transparent_button.dart';

class GeneralSetting extends StatefulWidget {
  const GeneralSetting({super.key});

  @override
  State<GeneralSetting> createState() => _GeneralSettingState();
}

class _GeneralSettingState extends State<GeneralSetting> {
  String mainLogoProfile = '';
  String commonLogoProfile = '';
  String sideBarLogoProfile = '';

  bool receiveWhatsappUpdates = false;
  Uint8List? mainLogo;
  Uint8List? commonLog;
  Uint8List? sideBarLogo;

  TextEditingController titleController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    companyNameController.dispose();
    super.dispose();
  }

  Future<String?> _uploadImage(Uint8List imageBytes, String currentUrl) async {
    try {
      EasyLoading.show(status: 'Uploading...', dismissOnTap: false);

      // Delete old image if it exists and is not the default one
      if (currentUrl.isNotEmpty && !currentUrl.contains('blank-profile-picture') && !currentUrl.contains('firebasestorage.googleapis.com')) {
        try {
          await FirebaseStorage.instance.refFromURL(currentUrl).delete();
        } catch (e) {
          print('Error deleting old image: $e');
        }
      }

      var snapshot = await FirebaseStorage.instance.ref('General Setting/${DateTime.now().millisecondsSinceEpoch}').putData(imageBytes);

      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: ${e.message}')),
      );
      return null;
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
      return null;
    }
  }

  Future<void> uploadMainLogoFile() async {
    if (!kIsWeb) return;

    try {
      Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
      if (bytesFromPicker == null || bytesFromPicker.isEmpty) return;

      final url = await _uploadImage(bytesFromPicker, mainLogoProfile);
      if (url != null) {
        EasyLoading.showSuccess('Main logo uploaded!');
        setState(() {
          mainLogo = bytesFromPicker;
          mainLogoProfile = url;
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> uploadCommonLogoFile() async {
    if (!kIsWeb) return;

    try {
      Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
      if (bytesFromPicker == null || bytesFromPicker.isEmpty) return;

      final url = await _uploadImage(bytesFromPicker, commonLogoProfile);
      if (url != null) {
        EasyLoading.showSuccess('Common logo uploaded!');
        setState(() {
          commonLog = bytesFromPicker;
          commonLogoProfile = url;
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> uploadSideBarLogoFile() async {
    if (!kIsWeb) return;

    try {
      Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
      if (bytesFromPicker == null || bytesFromPicker.isEmpty) return;

      final url = await _uploadImage(bytesFromPicker, sideBarLogoProfile);
      if (url != null) {
        EasyLoading.showSuccess('Sidebar logo uploaded!');
        setState(() {
          sideBarLogo = bytesFromPicker;
          sideBarLogoProfile = url;
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer(
      builder: (_, ref, watch) {
        final settingProvider = ref.watch(generalSettingProvider);
        return settingProvider.when(
          data: (setting) {
            // Initialize state only once
            if (mainLogoProfile.isEmpty && setting.mainLogo.isNotEmpty) {
              mainLogoProfile = setting.mainLogo;
            }
            if (commonLogoProfile.isEmpty && setting.commonHeaderLogo.isNotEmpty) {
              commonLogoProfile = setting.commonHeaderLogo;
            }
            if (sideBarLogoProfile.isEmpty && setting.sidebarLogo.isNotEmpty) {
              sideBarLogoProfile = setting.sidebarLogo;
            }
            if (titleController.text.isEmpty && setting.title.isNotEmpty) {
              titleController.text = setting.title;
            }
            if (companyNameController.text.isEmpty && setting.companyName.isNotEmpty) {
              companyNameController.text = setting.companyName;
            }

            return Scaffold(
              body: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "General Setting",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Title'),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: titleController,
                        decoration: kInputDecoration.copyWith(
                          hintText: 'Enter your title',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Admin Footer Link Text'),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: companyNameController,
                        decoration: kInputDecoration.copyWith(
                          hintText: 'Enter your admin footer link text',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Main Logo'),
                      SizedBox(height: 5),
                      _buildLogoUploader(
                        onTap: uploadMainLogoFile,
                        networkImage: mainLogoProfile,
                        placeholder: appsLogo,
                        isSelected: mainLogo != null,
                      ),
                      SizedBox(height: 20),
                      Text('Common Header Logo'),
                      SizedBox(height: 5),
                      _buildLogoUploader(
                        onTap: uploadCommonLogoFile,
                        networkImage: commonLogoProfile,
                        placeholder: 'images/nameLogo.png',
                        isSelected: commonLog != null,
                      ),
                      SizedBox(height: 20),
                      Text('Sidebar Logo'),
                      SizedBox(height: 5),
                      _buildLogoUploader(
                        onTap: uploadSideBarLogoFile,
                        networkImage: sideBarLogoProfile,
                        placeholder: 'images/sideLogo.png',
                        isSelected: sideBarLogo != null,
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kMainColor600,
                            minimumSize: Size(150, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () async {
                            if (titleController.text.isEmpty || companyNameController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please fill all fields')),
                              );
                              return;
                            }

                            EasyLoading.show(status: 'Saving...');
                            try {
                              DatabaseReference adRef = FirebaseDatabase.instance.ref().child('Admin Panel').child('General Setting');

                              GeneralSettingModel generalSettingModel = GeneralSettingModel(
                                title: titleController.text,
                                companyName: companyNameController.text,
                                mainLogo: mainLogoProfile,
                                commonHeaderLogo: commonLogoProfile,
                                sidebarLogo: sideBarLogoProfile,
                              );

                              await adRef.set(generalSettingModel.toJson());

                              // Refresh the provider to get updated data
                              ref.refresh(generalSettingProvider);

                              EasyLoading.showSuccess('Settings saved successfully!');
                            } catch (e) {
                              EasyLoading.dismiss();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error saving settings: ${e.toString()}')),
                              );
                            }
                          },
                          child: Text(
                            'Save Settings',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          error: (e, stack) {
            return Center(child: Text('Error loading settings: ${e.toString()}'));
          },
          loading: () {
            return Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }

  Widget _buildLogoUploader({
    required VoidCallback onTap,
    required String networkImage,
    required String placeholder,
    required bool isSelected,
  }) {
    return CustomDottedBorder(
      color: kLitGreyColor,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 80,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: isSelected ? Colors.grey[100] : null,
            ),
            child: networkImage.isNotEmpty
                ? Image.network(
                    networkImage,
                    height: 60,
                    width: 120,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) => Image.asset(placeholder, height: 60, width: 120),
                  )
                : Image.asset(placeholder, height: 60, width: 120),
          ),
        ),
      ),
    );
  }
}
