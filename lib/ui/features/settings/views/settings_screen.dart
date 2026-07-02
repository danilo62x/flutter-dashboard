import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:dashboard/ui/core/widgets/app_widgets.dart';
import 'package:dashboard/ui/features/settings/view_models/settings_view_model.dart';

/// Settings — profile header plus account, preferences, theme and logout.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: [
                _ProfileCard(vm: vm),
                const SizedBox(height: 22),
                _SectionLabel('Conta'),
                const SizedBox(height: 10),
                AppCard(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      _NavTile(
                        icon: Icons.person_outline,
                        title: 'Editar perfil',
                        subtitle: 'Nome, foto e dados pessoais',
                      ),
                      const _TileDivider(),
                      _SwitchTile(
                        icon: Icons.verified_user_outlined,
                        title: 'Autenticação em duas etapas',
                        value: vm.twoFactor,
                        onChanged: vm.toggleTwoFactor,
                      ),
                      const _TileDivider(),
                      _NavTile(
                        icon: Icons.credit_card_outlined,
                        title: 'Métodos de pagamento',
                        subtitle: '2 cartões salvos',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                _SectionLabel('Preferências'),
                const SizedBox(height: 10),
                AppCard(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      _SwitchTile(
                        icon: Icons.notifications_outlined,
                        title: 'Notificações push',
                        value: vm.pushNotifications,
                        onChanged: vm.togglePush,
                      ),
                      const _TileDivider(),
                      _SwitchTile(
                        icon: Icons.mark_email_read_outlined,
                        title: 'Relatórios por e-mail',
                        value: vm.emailReports,
                        onChanged: vm.toggleEmailReports,
                      ),
                      const _TileDivider(),
                      _SwitchTile(
                        icon: Icons.campaign_outlined,
                        title: 'E-mails de marketing',
                        value: vm.marketingEmails,
                        onChanged: vm.toggleMarketing,
                      ),
                      const _TileDivider(),
                      _NavTile(
                        icon: Icons.language_outlined,
                        title: 'Idioma',
                        subtitle: vm.language,
                        onTap: vm.cycleLanguage,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                _SectionLabel('Aparência'),
                const SizedBox(height: 10),
                AppCard(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      _SwitchTile(
                        icon: Icons.dark_mode_outlined,
                        title: 'Tema escuro',
                        value: vm.darkMode,
                        onChanged: vm.toggleDarkMode,
                      ),
                      const _TileDivider(),
                      _SwitchTile(
                        icon: Icons.density_medium_outlined,
                        title: 'Modo compacto',
                        value: vm.compactMode,
                        onChanged: vm.toggleCompact,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                OutlinedButton.icon(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Sair da conta'),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Dashboard Template · v1.0.0',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.vm});

  final SettingsViewModel vm;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return AppCard(
      child: Row(
        children: [
          InitialsAvatar(
            name: vm.userName,
            radius: 30,
            background: scheme.primary,
            foreground: scheme.onPrimary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vm.userName,
                  style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  vm.userEmail,
                  style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    vm.plan,
                    style: text.labelSmall?.copyWith(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return ListTile(
      onTap: onTap,
      leading: _TileIcon(icon: icon),
      title: Text(title, style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!, style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
      trailing: Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      secondary: _TileIcon(icon: icon),
      title: Text(title, style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
    );
  }
}

class _TileIcon extends StatelessWidget {
  const _TileIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 20, color: scheme.onSurface),
    );
  }
}

class _TileDivider extends StatelessWidget {
  const _TileDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 68, endIndent: 16);
  }
}
