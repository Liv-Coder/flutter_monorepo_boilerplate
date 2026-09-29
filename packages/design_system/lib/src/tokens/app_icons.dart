import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Curated semantic icon set for the design system.
///
/// Feature code reads icons from here, never from `lucide_icons_flutter`
/// directly. This keeps the underlying icon set swappable and semantic names
/// stable across the codebase.
///
/// Every value is an [IconData] and can be passed to `Icon(AppIcons.save)`.
///
/// To add an icon: look up the name in the `LucideIcons` class, add a
/// semantic constant here, and export it. Do not use `LucideIcons` outside
/// this file.
class AppIcons {
  const AppIcons._();

  // ── Navigation ───────────────────────────────────────────────────────────

  /// Home / dashboard destination.
  static const IconData home = LucideIcons.house;

  /// Navigate backward.
  static const IconData back = LucideIcons.arrowLeft;

  /// Navigate forward.
  static const IconData forward = LucideIcons.arrowRight;

  /// Dismiss a sheet, dialog, or chip.
  static const IconData close = LucideIcons.x;

  /// Open navigation drawer or bottom sheet.
  static const IconData menu = LucideIcons.menu;

  /// Search / find.
  static const IconData search = LucideIcons.search;

  // ── Actions ───────────────────────────────────────────────────────────────

  /// Create a new item.
  static const IconData add = LucideIcons.plus;

  /// Remove or decrement.
  static const IconData remove = LucideIcons.minus;

  /// Enter edit mode.
  static const IconData edit = LucideIcons.pencil;

  /// Delete permanently.
  static const IconData delete = LucideIcons.trash2;

  /// Save to storage.
  static const IconData save = LucideIcons.save;

  /// Share with another app or user.
  static const IconData share = LucideIcons.share2;

  /// Copy to clipboard.
  static const IconData copy = LucideIcons.copy;

  /// Download a file or resource.
  static const IconData download = LucideIcons.download;

  /// Upload a file or resource.
  static const IconData upload = LucideIcons.upload;

  // ── Status ────────────────────────────────────────────────────────────────

  /// Operation succeeded.
  static const IconData success = LucideIcons.circleCheck;

  /// Degraded or non-critical warning.
  static const IconData warning = LucideIcons.triangleAlert;

  /// Operation failed or destructive state.
  static const IconData error = LucideIcons.circleX;

  /// Informational, non-critical notice.
  static const IconData info = LucideIcons.info;

  // ── Communication ─────────────────────────────────────────────────────────

  /// Email / mail.
  static const IconData mail = LucideIcons.mail;

  /// Phone / call.
  static const IconData phone = LucideIcons.phone;

  /// Chat message or comment.
  static const IconData message = LucideIcons.messageCircle;

  /// Bell / push notification.
  static const IconData notification = LucideIcons.bell;

  // ── User ──────────────────────────────────────────────────────────────────

  /// Single user / profile.
  static const IconData user = LucideIcons.user;

  /// Group of users / team.
  static const IconData users = LucideIcons.users;

  /// App or account settings.
  static const IconData settings = LucideIcons.settings;

  /// Sign out / log out.
  static const IconData logout = LucideIcons.logOut;

  // ── Media ─────────────────────────────────────────────────────────────────

  /// Play media.
  static const IconData play = LucideIcons.play;

  /// Pause media.
  static const IconData pause = LucideIcons.pause;

  /// Open camera.
  static const IconData camera = LucideIcons.camera;

  /// Image / photo.
  static const IconData image = LucideIcons.image;

  // ── Utility ───────────────────────────────────────────────────────────────

  /// Confirm / checkmark.
  static const IconData check = LucideIcons.check;

  /// Expand / reveal more below.
  static const IconData chevronDown = LucideIcons.chevronDown;

  /// Collapse / hide above.
  static const IconData chevronUp = LucideIcons.chevronUp;

  /// Drill into a sub-section.
  static const IconData chevronRight = LucideIcons.chevronRight;

  /// Open in a new tab or external app.
  static const IconData externalLink = LucideIcons.externalLink;

  /// Reload / retry.
  static const IconData refresh = LucideIcons.refreshCw;

  /// Apply filters to a list.
  static const IconData filter = LucideIcons.filter;

  /// Date / calendar.
  static const IconData calendar = LucideIcons.calendar;

  /// Time / clock.
  static const IconData clock = LucideIcons.clock;

  /// Locked / secured state.
  static const IconData lock = LucideIcons.lock;

  /// Show hidden content (e.g. password).
  static const IconData eye = LucideIcons.eye;

  /// Hide visible content (e.g. password).
  static const IconData eyeOff = LucideIcons.eyeOff;

  /// Terminal / developer console.
  static const IconData terminal = LucideIcons.terminal;
}
