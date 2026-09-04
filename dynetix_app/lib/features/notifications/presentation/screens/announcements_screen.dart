import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dynetix_widgets.dart';
import '../bloc/announcement_cubit.dart';
import '../bloc/announcement_state.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AnnouncementCubit>().fetchAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('ANNOUNCEMENTS', style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: AppColors.surface,
      ),
      body: BlocBuilder<AnnouncementCubit, AnnouncementState>(
        builder: (context, state) {
          if (state is AnnouncementLoading) return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          
          if (state is AnnouncementLoaded) {
            if (state.announcements.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off_outlined, size: 64, color: AppColors.textDisabled.withValues(alpha: 0.3)),
                    const SizedBox(height: 16),
                    const Text('No recent announcements', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.announcements.length,
              itemBuilder: (context, index) {
                final ann = state.announcements[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: GlassPanel(
                    padding: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              ann.type == 'global' ? Icons.public_rounded : Icons.school_rounded,
                              color: AppColors.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              ann.type.toUpperCase(),
                              style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                            ),
                            const Spacer(),
                            Text(
                              DateFormat('MMM dd').format(ann.createdAt),
                              style: const TextStyle(color: AppColors.textDisabled, fontSize: 10),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          ann.title,
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ann.content,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          if (state is AnnouncementError) return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.redAccent)));
          
          return const SizedBox();
        },
      ),
    );
  }
}
