import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current user from authProvider
    final authState = ref.watch(authProvider);
    final user = authState.value;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile', style: AppTypography.h2),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Header
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.surfaceElevated,
              child: Icon(Icons.person, size: 48, color: AppColors.textMuted),
            ),
            const SizedBox(height: AppSpacing.md),
            
            // Name / Email
            Text(
              user?.userMetadata?['full_name'] ?? 'StreamX User',
              style: AppTypography.h1,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              user?.email ?? 'user@example.com',
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            
            // Premium Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.ratingGold),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                'StreamX Premium',
                style: AppTypography.labelSmall.copyWith(color: AppColors.ratingGold),
              ),
            ),
            
            const SizedBox(height: AppSpacing.xxl),
            
            // Sections
            _buildSectionHeader('Account'),
            _buildListTile(Icons.edit, 'Edit Profile'),
            _buildListTile(Icons.people, 'Manage Profiles'),
            _buildListTile(Icons.lock_outline, 'Change Password'),
            
            const SizedBox(height: AppSpacing.xl),
            
            _buildSectionHeader('App'),
            _buildListTile(Icons.high_quality, 'Download Quality', trailing: const Text('High', style: AppTypography.bodySmall)),
            _buildListTile(Icons.notifications_none, 'Notifications'),
            _buildListTile(Icons.play_circle_outline, 'Autoplay'),
            _buildListTile(Icons.subtitles_outlined, 'Subtitle Language', trailing: const Text('English', style: AppTypography.bodySmall)),
            
            const SizedBox(height: AppSpacing.xl),
            
            _buildSectionHeader('Downloads'),
            _buildListTile(Icons.download_done, 'Download Manager'),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Storage Used', style: AppTypography.body),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.sm),
                  LinearProgressIndicator(
                    value: 0.46, // 2.3 of 5
                    backgroundColor: AppColors.surfaceBorder,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brand),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Text('2.3 GB of 5 GB used', style: AppTypography.bodySmall),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            _buildSectionHeader('Support'),
            _buildListTile(Icons.help_outline, 'Help Center'),
            _buildListTile(Icons.privacy_tip_outlined, 'Privacy Policy'),
            _buildListTile(Icons.description_outlined, 'Terms of Service'),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('App Version', style: AppTypography.body),
              trailing: const Text('1.0.0 (1)', style: AppTypography.bodySmall),
            ),
            
            const SizedBox(height: AppSpacing.xxl),
            
            // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => _showSignOutDialog(context, ref),
                child: Text('Sign Out', style: AppTypography.label.copyWith(color: AppColors.brand)),
              ),
            ),
            
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: AppTypography.h2),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, {Widget? trailing}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title, style: AppTypography.body),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.textMuted),
      onTap: () {},
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        title: const Text('Sign Out', style: AppTypography.h2),
        content: const Text('Are you sure you want to sign out?', style: AppTypography.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppTypography.label.copyWith(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(authProvider.notifier).signOut();
              if (context.mounted) {
                context.go('/welcome');
              }
            },
            child: Text('Sign Out', style: AppTypography.label.copyWith(color: AppColors.brand)),
          ),
        ],
      ),
    );
  }
}
