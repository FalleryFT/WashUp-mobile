import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/app_state.dart';
import '../main_navigation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _noHpCtrl = TextEditingController();
  final _alamatCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure1 = true;
  bool _obscure2 = true;
  String? _error;

  static const Color _navyColor = Color(0xFF1A3D5C);
  static const Color _skyBlue = Color(0xFF5BBFE8);
  static const Color _bgSoftBlue = Color(0xFFDFF0F7);
  static const Color _panelBlue = Color(0xFF7ECFE0);

  @override
  void dispose() {
    for (final c in [_namaCtrl, _usernameCtrl, _emailCtrl, _noHpCtrl, _alamatCtrl, _passwordCtrl, _confirmCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });

    final res = await context.read<AppState>().register({
      'nama': _namaCtrl.text.trim(),
      'username': _usernameCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'no_hp': _noHpCtrl.text.trim(),
      'alamat': _alamatCtrl.text.trim(),
      'password': _passwordCtrl.text,
      'password_confirmation': _confirmCtrl.text,
    });
    if (!mounted) return;
    setState(() => _loading = false);
    if (res.success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
        (_) => false,
      );
    } else {
      setState(() => _error = res.message ?? 'Pendaftaran gagal. Coba lagi.');
    }
  }

  // Reusable input field matching the web style
  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _skyBlue, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgSoftBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // ── Top Panel (Blue) ─────────────────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                        decoration: const BoxDecoration(
                          color: _panelBlue,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        child: Row(
                          children: [
                            // Back button
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Logo + title
                            Expanded(
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/logo.png',
                                    height: 50,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, _, _) => Container(
                                      width: 44,
                                      height: 44,
                                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                      child: const Center(
                                        child: Text('W', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: _skyBlue, fontFamily: 'Poppins')),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Buat Akun Baru',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      Text(
                                        'Daftar gratis, mulai mencuci!',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── Form Panel ────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Sign Up',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: _navyColor,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 20),

                              if (_error != null)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.red.shade200),
                                  ),
                                  child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                                ),

                              _buildField(
                                controller: _namaCtrl,
                                hint: 'Nama Lengkap',
                                validator: (v) => (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                              ),
                              const SizedBox(height: 10),

                              _buildField(
                                controller: _usernameCtrl,
                                hint: 'Username',
                                validator: (v) => (v == null || v.isEmpty) ? 'Username wajib diisi' : null,
                              ),
                              const SizedBox(height: 10),

                              _buildField(
                                controller: _emailCtrl,
                                hint: 'Email',
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Email wajib diisi';
                                  if (!v.contains('@')) return 'Format email tidak valid';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),

                              _buildField(
                                controller: _noHpCtrl,
                                hint: 'No. HP / WhatsApp (contoh: 08123456789)',
                                keyboardType: TextInputType.phone,
                                validator: (v) => (v == null || v.isEmpty) ? 'No. HP wajib diisi' : null,
                              ),
                              const SizedBox(height: 10),

                              _buildField(
                                controller: _alamatCtrl,
                                hint: 'Alamat Lengkap (untuk antar-jemput)',
                                maxLines: 2,
                              ),
                              const SizedBox(height: 10),

                              _buildField(
                                controller: _passwordCtrl,
                                hint: 'Password (minimal 8 karakter)',
                                obscureText: _obscure1,
                                suffixIcon: IconButton(
                                  icon: Icon(_obscure1 ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: const Color(0xFF9CA3AF)),
                                  onPressed: () => setState(() => _obscure1 = !_obscure1),
                                ),
                                validator: (v) => (v == null || v.length < 8) ? 'Password minimal 8 karakter' : null,
                              ),
                              const SizedBox(height: 10),

                              _buildField(
                                controller: _confirmCtrl,
                                hint: 'Konfirmasi Password',
                                obscureText: _obscure2,
                                suffixIcon: IconButton(
                                  icon: Icon(_obscure2 ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: const Color(0xFF9CA3AF)),
                                  onPressed: () => setState(() => _obscure2 = !_obscure2),
                                ),
                                validator: (v) => (v != _passwordCtrl.text) ? 'Password tidak cocok' : null,
                              ),
                              const SizedBox(height: 24),

                              SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _loading ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _skyBlue,
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    shadowColor: _skyBlue.withValues(alpha: 0.4),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: _loading
                                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                      : const Text('Sign Up', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                                ),
                              ),
                              const SizedBox(height: 20),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Sudah punya akun? ', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        color: _skyBlue,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
