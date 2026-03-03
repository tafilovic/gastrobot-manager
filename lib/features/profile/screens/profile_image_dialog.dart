import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/models/user.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../auth/providers/auth_provider.dart';
import '../domain/errors/profile_exception.dart';
import '../domain/repositories/profile_api.dart';
import '../utils/profile_image_url.dart';

const _maxImageBytes = 3 * 1024 * 1024; // 3MB
const _accentBlue = Color(0xFF2196F3);

/// Dialog to change or remove profile picture. Uploads via [ProfileApi] on save.
class ProfileImageDialog extends StatefulWidget {
  const ProfileImageDialog({
    super.key,
    required this.user,
  });

  final User user;

  static Future<void> show(BuildContext context, User user) {
    return showDialog<void>(
      context: context,
      builder: (context) => ProfileImageDialog(user: user),
    );
  }

  @override
  State<ProfileImageDialog> createState() => _ProfileImageDialogState();
}

class _ProfileImageDialogState extends State<ProfileImageDialog> {
  File? _selectedFile;
  bool _deleteRequested = false;
  bool _isLoading = false;
  String? _error;

  bool get _hasCurrentImage =>
      widget.user.profileImageUrl != null &&
      widget.user.profileImageUrl!.isNotEmpty;

  bool get _hasChanges => _selectedFile != null || _deleteRequested;

  Widget _buildImage() {
    if (_selectedFile != null) {
      return Image.file(_selectedFile!, fit: BoxFit.cover);
    }
    if (_deleteRequested || !_hasCurrentImage) {
      return Container(
        color: _accentBlue,
        child: const Icon(Icons.person, size: 64, color: Colors.white),
      );
    }
    return Image.network(
      resolveProfileImageUrl(widget.user.profileImageUrl)!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: _accentBlue,
        child: const Icon(Icons.person, size: 64, color: Colors.white),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile == null || !mounted) return;
    final file = File(xFile.path);
    if (await file.length() > _maxImageBytes) {
      if (mounted) {
        setState(() => _error = 'Max 3MB');
      }
      return;
    }
    if (mounted) {
      setState(() {
        _selectedFile = file;
        _deleteRequested = false;
        _error = null;
      });
    }
  }

  void _onDelete() {
    setState(() {
      _selectedFile = null;
      _deleteRequested = true;
      _error = null;
    });
  }

  Future<void> _onSave() async {
    if (!_hasChanges || _isLoading) return;
    if (_selectedFile == null) {
      if (_deleteRequested) {
        context.read<AuthProvider>().updateProfileImageUrl(null);
      }
      Navigator.of(context).pop();
      return;
    }

    final profileApi = context.read<ProfileApi>();
    final auth = context.read<AuthProvider>();
    final token = auth.accessToken;
    if (token == null || token.isEmpty) {
      setState(() => _error = 'Not logged in');
      return;
    }

    setState(() {
      _error = null;
      _isLoading = true;
    });

    try {
      final newUrl = await profileApi.updateProfileImage(_selectedFile!, token);
      if (!mounted) return;
      if (newUrl != null) {
        auth.updateProfileImageUrl(newUrl);
      }
      Navigator.of(context).pop();
    } on ProfileException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.profileImageDialogTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _accentBlue.withValues(alpha: 0.5), width: 2),
                ),
                child: ClipOval(child: _buildImage()),
              ),
              if (_hasCurrentImage || _selectedFile != null)
                Positioned(
                  right: -4,
                  top: -4,
                  child: GestureDetector(
                    onTap: _isLoading ? null : _onDelete,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.delete_outline, color: Colors.white, size: 20),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: _isLoading ? null : _pickImage,
            icon: const Icon(Icons.upload_file, size: 20),
            label: Text(l10n.profileImageUploadButton),
            style: OutlinedButton.styleFrom(
              foregroundColor: _accentBlue,
              side: const BorderSide(color: _accentBlue),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.profileImageMaxSize,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13)),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: (_hasChanges && !_isLoading) ? _onSave : null,
              style: FilledButton.styleFrom(
                backgroundColor: _accentBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(l10n.profileImageSaveChanges),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
