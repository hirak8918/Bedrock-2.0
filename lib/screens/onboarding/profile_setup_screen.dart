import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/theme/dot_grid_background.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/pixel_avatar.dart';
import '../main_shell.dart';

/// Profile setup — name, avatar selection, GET STARTED.
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  int _selectedAvatar = 0;
  String? _imagePath;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 256,
        maxHeight: 256,
      );
      if (picked != null) {
        setState(() {
          _imagePath = picked.path;
        });
      }
    } catch (_) {
      // image_picker not available — silently ignore
    }
  }

  void _finish() async {
    final settings = context.read<SettingsProvider>();
    final name = _nameController.text.trim();

    if (name.isNotEmpty) {
      await settings.setUserName(name);
    }
    await settings.setAvatarIndex(_selectedAvatar);
    if (_imagePath != null) {
      await settings.setAvatarPath(_imagePath);
    }
    await settings.completeOnboarding();

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildCard(cs),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(ColorScheme cs) {
    return CustomPaint(
      painter: _CornerBracketPainter(color: cs.primary),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'WELCOME TO',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3,
                  color: cs.primary,
                ),
              ),
              Text(
                'BEDROCK',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                  color: cs.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Let's set up your profile.",
                style: TextStyle(fontSize: 15, color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 32),

              // Name input
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "WHAT'S YOUR NAME?",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: cs.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nameController,
                style: TextStyle(color: cs.onSurface),
                decoration: const InputDecoration(hintText: 'e.g., Alex'),
              ),
              const SizedBox(height: 28),

              // Profile picture
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'PROFILE PICTURE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: cs.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.file_upload_outlined),
                  label: Text(
                    _imagePath != null ? 'Picture Selected' : 'Upload Picture',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: cs.onSurfaceVariant,
                    side: BorderSide(color: cs.outline),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Divider with "OR CHOOSE AN AVATAR"
              Row(
                children: [
                  Expanded(child: Divider(color: cs.outline)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'OR CHOOSE AN AVATAR',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: cs.outline)),
                ],
              ),
              const SizedBox(height: 16),

              // Avatar selection row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(PixelAvatar.count, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _selectedAvatar = i;
                        _imagePath = null; // clear custom image
                      }),
                      child: PixelAvatar(
                        index: i,
                        size: 60,
                        isSelected: _selectedAvatar == i && _imagePath == null,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              // GET STARTED button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _finish,
                  child: const Text('GET STARTED'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Paints accent L-shaped corner brackets around the welcome card.
class _CornerBracketPainter extends CustomPainter {
  final Color color;

  _CornerBracketPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    const len = 24.0;
    const offset = 4.0;

    // Top-left
    canvas.drawLine(
      Offset(offset, offset),
      Offset(offset + len, offset),
      paint,
    );
    canvas.drawLine(
      Offset(offset, offset),
      Offset(offset, offset + len),
      paint,
    );

    // Top-right
    canvas.drawLine(
      Offset(size.width - offset, offset),
      Offset(size.width - offset - len, offset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - offset, offset),
      Offset(size.width - offset, offset + len),
      paint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(offset, size.height - offset),
      Offset(offset + len, size.height - offset),
      paint,
    );
    canvas.drawLine(
      Offset(offset, size.height - offset),
      Offset(offset, size.height - offset - len),
      paint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(size.width - offset, size.height - offset),
      Offset(size.width - offset - len, size.height - offset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - offset, size.height - offset),
      Offset(size.width - offset, size.height - offset - len),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CornerBracketPainter oldDelegate) =>
      color != oldDelegate.color;
}
