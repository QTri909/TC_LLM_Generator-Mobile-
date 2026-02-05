import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/auth_entity.dart';

class TokenDisplayPage extends StatelessWidget {
  final AuthEntity authEntity;

  const TokenDisplayPage({super.key, required this.authEntity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Login Success'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Authentication Successful',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            _buildTokenSection('Access Token', authEntity.accessToken),
            const SizedBox(height: 24),
            _buildTokenSection('Refresh Token', authEntity.refreshToken),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenSection(String label, String token) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13), // approx 0.05 opacity
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          SelectableText(
            token,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textGrey,
              fontFamily: 'Courier',
            ),
          ),
        ],
      ),
    );
  }
}
