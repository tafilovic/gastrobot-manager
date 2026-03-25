import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/layout/app_breakpoints.dart';
import 'package:gastrobotmanager/core/navigation/app_router.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/domain/errors/auth_exception.dart';
import 'package:gastrobotmanager/features/auth/models/register_request.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Registration form: firstname, lastname, email, password + confirm. Submit enabled only when valid.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _firstnameController.addListener(_onFieldChanged);
    _lastnameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _passwordController.addListener(_onFieldChanged);
    _confirmPasswordController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _firstnameController.removeListener(_onFieldChanged);
    _lastnameController.removeListener(_onFieldChanged);
    _emailController.removeListener(_onFieldChanged);
    _passwordController.removeListener(_onFieldChanged);
    _confirmPasswordController.removeListener(_onFieldChanged);
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _emailLooksValid(String v) {
    final t = v.trim();
    return t.isNotEmpty && t.contains('@');
  }

  bool get _canSubmit {
    if (_isLoading) return false;
    if (_firstnameController.text.trim().isEmpty) return false;
    if (_lastnameController.text.trim().isEmpty) return false;
    if (!_emailLooksValid(_emailController.text)) return false;
    final p = _passwordController.text;
    if (p.isEmpty) return false;
    if (p != _confirmPasswordController.text) return false;
    return true;
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _error = null;
      _isLoading = true;
    });

    final registeredEmail = _emailController.text.trim();
    try {
      await context.read<AuthProvider>().register(
            RegisterRequest(
              firstname: _firstnameController.text.trim(),
              lastname: _lastnameController.text.trim(),
              email: registeredEmail,
              password: _passwordController.text,
            ),
          );
      if (!mounted) return;
      setState(() => _isLoading = false);
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.registerSuccessTitle),
          content: Text(l10n.registerSuccessMessage(registeredEmail)),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text(l10n.registerSuccessOk),
            ),
          ],
        ),
      );
      if (mounted) context.pop();
    } on AuthException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _isLoading = false;
        });
      }
    } on DioException catch (_) {
      if (mounted) {
        setState(() {
          _error = l10n.registerErrorGeneric;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = l10n.registerErrorGeneric;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(l10n.registerTitle),
        backgroundColor: AppColors.appBarBackground,
        foregroundColor: AppColors.appBarForeground,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppBreakpoints.contentMaxWidth,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _firstnameController,
                      decoration: InputDecoration(
                        labelText: l10n.registerFirstnameLabel,
                        border: const OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return l10n.registerFieldRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastnameController,
                      decoration: InputDecoration(
                        labelText: l10n.registerLastnameLabel,
                        border: const OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return l10n.registerFieldRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: l10n.registerEmailLabel,
                        hintText: l10n.loginEmailHint,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return l10n.loginEmailRequired;
                        }
                        if (!v.contains('@')) {
                          return l10n.loginEmailInvalid;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: l10n.loginPasswordLabel,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return l10n.loginPasswordRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: l10n.registerPasswordConfirmLabel,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () =>
                              setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                      obscureText: _obscureConfirm,
                      textInputAction: TextInputAction.done,
                      enabled: !_isLoading,
                      onFieldSubmitted: (_) {
                        if (_canSubmit) _submit();
                      },
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return l10n.loginPasswordRequired;
                        }
                        if (v != _passwordController.text) {
                          return l10n.registerPasswordMismatch;
                        }
                        return null;
                      },
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ],
                    const SizedBox(height: 32),
                    FilledButton(
                      onPressed: _canSubmit ? _submit : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(l10n.registerSubmitButton),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => context.go(AppRouteNames.pathLogin),
                      child: Text(l10n.registerBackToLogin),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
