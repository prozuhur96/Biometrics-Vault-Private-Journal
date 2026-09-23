import 'package:flutter/material.dart';

import '../main.dart';
import '../models/journal_entry.dart';
import '../services/auth_service.dart';
import '../services/journal_service.dart';
import '../services/pin_service.dart';
import 'entry_editor_screen.dart';

class JournalHomeScreen extends StatefulWidget {
  const JournalHomeScreen({
    super.key,
  });

  @override
  State<JournalHomeScreen> createState() =>
      _JournalHomeScreenState();
}

class _JournalHomeScreenState
    extends State<JournalHomeScreen> {
  final AuthService _authService =
      AuthService();

  final JournalService _journalService =
      JournalService();

  final PinService _pinService =
      PinService();

  static const List<ThemeColorOption>
      _themeColors = [
    ThemeColorOption(
      'Deep Purple',
      Colors.deepPurple,
    ),
    ThemeColorOption(
      'Royal Indigo',
      Colors.indigo,
    ),
    ThemeColorOption(
      'Ocean Blue',
      Colors.blue,
    ),
    ThemeColorOption(
      'Teal',
      Colors.teal,
    ),
    ThemeColorOption(
      'Forest Green',
      Colors.green,
    ),
    ThemeColorOption(
      'Amber Gold',
      Colors.amber,
    ),
    ThemeColorOption(
      'Sunset Orange',
      Colors.deepOrange,
    ),
    ThemeColorOption(
      'Rose Pink',
      Colors.pink,
    ),
    ThemeColorOption(
      'Crimson Red',
      Colors.red,
    ),
    ThemeColorOption(
      'Slate Grey',
      Colors.blueGrey,
    ),
  ];

  Future<String?> _askForPin({
    required String title,
    required String confirmLabel,
  }) async {
    final controller =
        TextEditingController();

    String? errorText;

    final result =
        await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.lock_outline,
                    color: Theme.of(context)
                        .colorScheme
                        .primary,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(title),
                ],
              ),
              content: TextField(
                controller: controller,
                autofocus: true,
                obscureText: true,
                keyboardType:
                    TextInputType.number,
                maxLength:
                    PinService.maxPinLength,
                decoration:
                    InputDecoration(
                  labelText: 'PIN',
                  hintText: '4–6 digits',
                  errorText: errorText,
                  border:
                      const OutlineInputBorder(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text(
                    'Cancel',
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    final pin =
                        controller.text.trim();

                    if (!_pinService
                        .isValidPin(pin)) {
                      setDialogState(() {
                        errorText =
                            'PIN must be 4–6 digits.';
                      });
                      return;
                    }

                    Navigator.pop(
                      dialogContext,
                      pin,
                    );
                  },
                  child: Text(
                    confirmLabel,
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    controller.dispose();

    return result;
  }

  Future<bool> _verifyEntryPin(
    JournalEntry entry,
  ) async {
    final controller =
        TextEditingController();

    String? errorText;

    while (true) {
      final pin =
          await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (
              context,
              setDialogState,
            ) {
              return AlertDialog(
                title: Row(
                  children: [
                    Icon(
                      Icons.lock,
                      color: Theme.of(
                        context,
                      )
                          .colorScheme
                          .primary,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Entry Locked',
                    ),
                  ],
                ),
                content: TextField(
                  controller: controller,
                  autofocus: true,
                  obscureText: true,
                  keyboardType:
                      TextInputType.number,
                  maxLength:
                      PinService.maxPinLength,
                  decoration:
                      InputDecoration(
                    labelText:
                        'Enter PIN',
                    errorText:
                        errorText,
                    border:
                        const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) {
                    final enteredPin =
                        controller.text
                            .trim();

                    if (!_pinService
                        .isValidPin(
                      enteredPin,
                    )) {
                      setDialogState(() {
                        errorText =
                            'Enter your 4–6 digit PIN.';
                      });
                      return;
                    }

                    if (_pinService
                        .verifyPin(
                      pin: enteredPin,
                      salt: entry.pinSalt,
                      expectedHash:
                          entry.pinHash,
                    )) {
                      Navigator.pop(
                        dialogContext,
                        enteredPin,
                      );
                    } else {
                      setDialogState(() {
                        errorText =
                            'Incorrect PIN.';
                      });
                    }
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        dialogContext,
                      );
                    },
                    child: const Text(
                      'Cancel',
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      final enteredPin =
                          controller.text
                              .trim();

                      if (!_pinService
                          .isValidPin(
                        enteredPin,
                      )) {
                        setDialogState(() {
                          errorText =
                              'Enter your 4–6 digit PIN.';
                        });
                        return;
                      }

                      if (_pinService
                          .verifyPin(
                        pin: enteredPin,
                        salt: entry.pinSalt,
                        expectedHash:
                            entry.pinHash,
                      )) {
                        Navigator.pop(
                          dialogContext,
                          enteredPin,
                        );
                      } else {
                        setDialogState(() {
                          errorText =
                              'Incorrect PIN.';
                        });
                      }
                    },
                    child: const Text(
                      'Unlock',
                    ),
                  ),
                ],
              );
            },
          );
        },
      );

      if (pin == null) {
        controller.dispose();
        return false;
      }

      final isCorrect =
          _pinService.verifyPin(
        pin: pin,
        salt: entry.pinSalt,
        expectedHash: entry.pinHash,
      );

      if (isCorrect) {
        controller.dispose();
        return true;
      }

      controller.clear();
    }
  }

  Future<bool> _requirePinIfLocked(
    JournalEntry entry,
  ) async {
    if (!entry.isLocked) {
      return true;
    }

    return _verifyEntryPin(entry);
  }

  Future<void> _lockEntry(
    JournalEntry entry,
  ) async {
    if (entry.isLocked) {
      return;
    }

    final pin = await _askForPin(
      title: 'Lock Entry',
      confirmLabel: 'Lock',
    );

    if (pin == null) {
      return;
    }

    final confirmPin =
        await _askForPin(
      title: 'Confirm PIN',
      confirmLabel: 'Confirm',
    );

    if (confirmPin == null) {
      return;
    }

    if (pin != confirmPin) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'The PINs do not match.',
          ),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    final salt =
        _pinService.generateSalt();

    final hash =
        _pinService.hashPin(
      pin,
      salt,
    );

    try {
      await _journalService.setEntryLock(
        docId: entry.id,
        isLocked: true,
        pinHash: hash,
        pinSalt: salt,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Entry locked with PIN.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Could not lock entry: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _unlockEntry(
    JournalEntry entry,
  ) async {
    final unlocked =
        await _verifyEntryPin(entry);

    if (!unlocked) {
      return;
    }

    try {
      await _journalService.setEntryLock(
        docId: entry.id,
        isLocked: false,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Entry unlocked.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Could not unlock entry: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteEntry(
    JournalEntry entry,
  ) async {
    if (entry.isLocked) {
      final verified =
          await _verifyEntryPin(entry);

      if (!verified) {
        return;
      }
    }

    final shouldDelete =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Entry?',
          ),
          content: Text(
            'Are you sure you want to delete '
            '"${entry.isLocked ? 'this locked entry' : entry.title}"? '
            'This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    try {
      await _journalService.deleteEntry(
        entry.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Entry deleted successfully.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Error deleting entry: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _openEntry(
    JournalEntry entry,
  ) async {
    final allowed =
        await _requirePinIfLocked(
      entry,
    );

    if (!allowed) {
      return;
    }

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EntryEditorScreen(
          entry: entry,
        ),
      ),
    );
  }

  Future<void> _handleMenuAction(
    String value,
    JournalEntry entry,
  ) async {
    switch (value) {
      case 'edit':
        await _openEntry(entry);
        break;

      case 'lock':
        await _lockEntry(entry);
        break;

      case 'unlock':
        await _unlockEntry(entry);
        break;

      case 'delete':
        await _deleteEntry(entry);
        break;
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final user =
        _authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Private Journal',
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
              accountName: const Text(
                'Private Vault',
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: Text(
                user?.email ??
                    'User Email',
              ),
              currentAccountPicture:
                  CircleAvatar(
                backgroundColor:
                    Colors.white,
                child: Icon(
                  Icons.person,
                  size: 38,
                  color: Theme.of(context)
                      .colorScheme
                      .primary,
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ValueListenableBuilder<Color>(
                    valueListenable:
                        appThemeColorNotifier,
                    builder: (
                      context,
                      currentColor,
                      _,
                    ) {
                      return ExpansionTile(
                        leading: const Icon(
                          Icons
                              .palette_outlined,
                        ),
                        title: const Text(
                          'Change Theme Color',
                        ),
                        subtitle: const Text(
                          'Customize app appearance',
                        ),
                        initiallyExpanded:
                            true,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children:
                                  _themeColors
                                      .map(
                                (option) {
                                  final isSelected =
                                      currentColor
                                              .toARGB32() ==
                                          option
                                              .color
                                              .toARGB32();

                                  return GestureDetector(
                                    onTap: () {
                                      appThemeColorNotifier
                                              .value =
                                          option
                                              .color;
                                    },
                                    child:
                                        Tooltip(
                                      message:
                                          option
                                              .name,
                                      child:
                                          Container(
                                        width: 42,
                                        height: 42,
                                        decoration:
                                            BoxDecoration(
                                          color:
                                              option.color,
                                          shape:
                                              BoxShape.circle,
                                          border:
                                              Border.all(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.transparent,
                                            width:
                                                3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors
                                                  .black
                                                  .withValues(
                                                alpha:
                                                    0.2,
                                              ),
                                              blurRadius:
                                                  4,
                                              offset:
                                                  const Offset(
                                                0,
                                                2,
                                              ),
                                            ),
                                          ],
                                        ),
                                        child:
                                            isSelected
                                                ? const Icon(
                                                    Icons.check,
                                                    color:
                                                        Colors.white,
                                                    size:
                                                        22,
                                                  )
                                                : null,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const Divider(
              height: 1,
            ),

            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
                size: 26,
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                await _authService.signOut();
              },
            ),

            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),

      body: StreamBuilder<List<JournalEntry>>(
        stream:
            _journalService.getEntries(),
        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(
                        context,
                      )
                          .colorScheme
                          .error,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Could not load your entries.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                      textAlign:
                          TextAlign.center,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      snapshot.error
                          .toString(),
                      textAlign:
                          TextAlign.center,
                      style:
                          const TextStyle(
                        color:
                            Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final entries =
              snapshot.data ?? [];

          if (entries.isEmpty) {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.book_outlined,
                      size: 80,
                      color: Theme.of(
                        context,
                      )
                          .colorScheme
                          .primary,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Welcome to your Vault!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Tap the + button below to write your first entry.',
                      style: TextStyle(
                        color:
                            Colors.grey,
                      ),
                      textAlign:
                          TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding:
                const EdgeInsets.all(16),
            itemCount:
                entries.length,
            itemBuilder:
                (context, index) {
              final entry =
                  entries[index];

              final locked =
                  entry.isLocked;

              return Card(
                margin:
                    const EdgeInsets.only(
                  bottom: 12,
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),

                  leading: CircleAvatar(
                    backgroundColor:
                        locked
                            ? Colors
                                .grey
                                .shade300
                            : Theme.of(
                                context,
                              )
                                .colorScheme
                                .primaryContainer,
                    child: Icon(
                      locked
                          ? Icons.lock
                          : Icons.book,
                      color: locked
                          ? Colors.grey
                          : Theme.of(
                              context,
                            )
                              .colorScheme
                              .onPrimaryContainer,
                    ),
                  ),

                  title: Text(
                    locked
                        ? 'Locked Entry'
                        : entry.title,
                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),

                  subtitle: Padding(
                    padding:
                        const EdgeInsets
                            .only(
                      top: 6,
                    ),
                    child: Text(
                      locked
                          ? 'This entry is protected by a PIN.'
                          : entry.content,
                      maxLines: 2,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style: locked
                          ? const TextStyle(
                              color:
                                  Colors.grey,
                              fontStyle:
                                  FontStyle.italic,
                            )
                          : null,
                    ),
                  ),

                  trailing:
                      PopupMenuButton<
                          String>(
                    tooltip:
                        'Entry options',
                    onSelected:
                        (value) async {
                      await _handleMenuAction(
                        value,
                        entry,
                      );
                    },
                    itemBuilder:
                        (context) {
                      return [
                        if (!locked)
                          const PopupMenuItem<
                              String>(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(
                                  Icons
                                      .edit_outlined,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  'Edit',
                                ),
                              ],
                            ),
                          ),

                        PopupMenuItem<
                            String>(
                          value: locked
                              ? 'unlock'
                              : 'lock',
                          child: Row(
                            children: [
                              Icon(
                                locked
                                    ? Icons
                                        .lock_open_outlined
                                    : Icons
                                        .lock_outline,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                locked
                                    ? 'Unlock with PIN'
                                    : 'Lock with PIN',
                              ),
                            ],
                          ),
                        ),

                        const PopupMenuItem<
                            String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons
                                    .delete_outline,
                                color:
                                    Colors.red,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                'Delete',
                                style:
                                    TextStyle(
                                  color:
                                      Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),

                  onTap: () async {
                    await _openEntry(
                      entry,
                    );
                  },
                ),
              );
            },
          );
        },
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const EntryEditorScreen(),
            ),
          );
        },
        tooltip: 'Add Entry',
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class ThemeColorOption {
  final String name;
  final Color color;

  const ThemeColorOption(
    this.name,
    this.color,
  );
}