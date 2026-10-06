import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/app_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _editing = false;
  bool _saving = false;
  late TextEditingController _namaCtrl;
  late TextEditingController _noHpCtrl;
  late TextEditingController _alamatCtrl;

  @override
  void initState() {
    super.initState();
    final user = context.read<AppState>().currentUser;
    _namaCtrl = TextEditingController(text: user?.name ?? '');
    _noHpCtrl = TextEditingController(text: user?.noHp ?? '');
    _alamatCtrl = TextEditingController(text: user?.alamat ?? '');
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _noHpCtrl.dispose();
    _alamatCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final success = await context.read<AppState>().updateProfile(
      nama: _namaCtrl.text.trim(),
      noHp: _noHpCtrl.text.trim(),
      alamat: _alamatCtrl.text.trim(),
    );
    if (mounted) {
      setState(() { _saving = false; _editing = !success; });
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui'), backgroundColor: AppColors.success),
        );
      }
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700)),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi WashUp?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      await context.read<AppState>().logout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 16, offset: const Offset(0, 4))],
                        ),
                        child: Center(
                          child: Text(
                            (user?.name ?? 'U').substring(0, 1).toUpperCase(),
                            style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: AppColors.primary, fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(user?.name ?? '-', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Poppins')),
                      Text(user?.email ?? '-', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.8))),
                    ],
                  ),
                ),
              ),
            ),
            title: const Text('Profil Saya', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
            actions: [
              if (!_editing)
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.white),
                  onPressed: () => setState(() => _editing = true),
                )
              else
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () => setState(() => _editing = false),
                ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Demo mode badge
                  if (state.isUseMock)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.science_outlined, color: AppColors.warning, size: 18),
                          SizedBox(width: 10),
                          Text('Mode Demo Aktif — Data tidak tersimpan', style: TextStyle(color: AppColors.warning, fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),

                  // Profile Info Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Informasi Akun', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontFamily: 'Poppins')),
                        const SizedBox(height: 16),
                        _InfoTile(label: 'Username', value: user?.username ?? '-', icon: Icons.alternate_email_rounded),
                        const Divider(height: 20),
                        _InfoTile(label: 'Email', value: user?.email ?? '-', icon: Icons.email_outlined),
                        const Divider(height: 20),

                        // Editable Fields
                        if (_editing) ...[
                          CustomTextField(controller: _namaCtrl, label: 'Nama Lengkap', prefixIcon: Icons.badge_outlined),
                          const SizedBox(height: 12),
                          CustomTextField(controller: _noHpCtrl, label: 'No. HP', prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone),
                          const SizedBox(height: 12),
                          CustomTextField(controller: _alamatCtrl, label: 'Alamat', prefixIcon: Icons.location_on_outlined, maxLines: 2),
                          const SizedBox(height: 16),
                          CustomButton(text: 'Simpan Perubahan', onPressed: _saving ? null : _save, isLoading: _saving),
                        ] else ...[
                          _InfoTile(label: 'Nama', value: user?.name ?? '-', icon: Icons.badge_outlined),
                          const Divider(height: 20),
                          _InfoTile(label: 'No. HP', value: user?.noHp ?? '-', icon: Icons.phone_outlined),
                          const Divider(height: 20),
                          _InfoTile(label: 'Alamat', value: user?.alamat?.isNotEmpty == true ? user!.alamat! : '-', icon: Icons.location_on_outlined),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Settings Card
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                    ),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          _SettingsTile(
                            icon: Icons.science_outlined,
                            iconColor: AppColors.warning,
                            label: 'Mode Demo',
                            trailing: Switch.adaptive(
                              value: state.isUseMock,
                              onChanged: (v) => context.read<AppState>().toggleMockMode(v),
                              activeColor: AppColors.primary,
                            ),
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          _SettingsTile(
                            icon: Icons.info_outline_rounded,
                            iconColor: AppColors.primary,
                            label: 'Tentang WashUp',
                            onTap: () => _showAboutDialog(context),
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          _SettingsTile(
                            icon: Icons.logout_rounded,
                            iconColor: AppColors.danger,
                            label: 'Keluar',
                            labelColor: AppColors.danger,
                            onTap: _logout,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  const Center(
                    child: Text('WashUp v1.0.0 — © 2026 WashUp', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Tentang WashUp', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700)),
        content: const Text('WashUp adalah aplikasi laundry digital yang memudahkan Anda memantau pesanan cucian secara real-time.\n\nVersi: 1.0.0\nDibuat untuk UTS Pemrograman Mobile.'),
        actions: [
          ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ],
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.icon, required this.iconColor, required this.label, this.labelColor, this.trailing, this.onTap});
  final IconData icon;
  final Color iconColor;
  final String label;
  final Color? labelColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(label, style: TextStyle(fontWeight: FontWeight.w500, color: labelColor ?? AppColors.textPrimary, fontFamily: 'Poppins')),
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary) : null),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
