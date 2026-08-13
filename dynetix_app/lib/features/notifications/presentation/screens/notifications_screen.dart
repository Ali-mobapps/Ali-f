import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/notification_cubit.dart';

class NotificationsScreen extends StatelessWidget {
  final String userEmail;
  const NotificationsScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    context.read<NotificationCubit>().fetchNotifications(userEmail);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Notifications')),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) return const Center(child: CircularProgressIndicator());
          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) return const Center(child: Text('No new notifications'));
            return ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final note = state.notifications[index];
                return ListTile(
                  title: Text(note.title, style: TextStyle(fontWeight: note.isRead ? FontWeight.normal : FontWeight.bold)),
                  subtitle: Text(note.message),
                  trailing: note.isRead ? null : const CircleAvatar(radius: 5, backgroundColor: AppColors.primary),
                  onTap: () => context.read<NotificationCubit>().markRead(note.id, userEmail),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
