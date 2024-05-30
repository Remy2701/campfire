import 'package:collection/collection.dart';
import 'package:dmp3s/common/api/kinds.dart';
import 'package:dmp3s/common/api/relay/pool.dart';
import 'package:dmp3s/common/model/user_info.dart';
import 'package:dmp3s/common/style/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:nostr/nostr.dart';
import 'package:dmp3s/mapping/model.dart' as skill_model;

/// The profile page of the application.
class MyProfilePage extends StatefulWidget {
  const MyProfilePage({
    super.key,
    required this.keychain,
    required this.onLogOut,
    required this.pageController,
    required this.getTheme,
    required this.changeTheme,
  });

  final Keychain keychain;
  final void Function() onLogOut;
  final PageController pageController;
  final ThemeMode Function() getTheme;
  final void Function() changeTheme;

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

/// The state of the profile page.
class _MyProfilePageState extends State<MyProfilePage> {
  bool _obscurePrivateKey = true;

  String? name;
  String? description;
  final TextEditingController _relayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(() {
      _obscurePrivateKey = true;
    });

    RelayPool.instance.listen(
        request: UserInfo.getRequest(widget.keychain.public),
        onEvent: (event) {
          final userInfo = UserInfo.fromEvent(event);
          if (!mounted) return;
          setState(() {
            name = userInfo.anonymous == true ? "Anonymous" : "${userInfo.firstName} ${userInfo.lastName}";
            description = userInfo.description ?? "";
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          const SizedBox(height: 10.0),
          Center(
            child: Text(
              "Profile & Settings",
              style: TextStyle(
                fontSize: 20.0,
                color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Row(children: [
                SizedBox(
                  width: 40.0,
                  child: Divider(
                    color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  "Personal Informations",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Divider(
                    color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                  ),
                )
              ]),
            ),
          ),
          const SizedBox(height: 20.0),
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: name == null
                  ? Container(
                      height: 52.0,
                      decoration: BoxDecoration(
                        color: widget.getTheme() == ThemeMode.dark ? const Color(0xFF1A1A1A) : const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Center(
                        child:
                            AspectRatio(aspectRatio: 1.0, child: CircularProgressIndicator(color: Color(0xFFFF7349))),
                      ),
                    )
                  : TextField(
                      controller: TextEditingController(text: name),
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                          color:
                              widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                        fillColor:
                            widget.getTheme() == ThemeMode.dark ? const Color(0xFF1A1A1A) : const Color(0xFFEEEEEE),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                        color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20.0),
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: description == null
                  ? Container(
                      height: 52.0,
                      decoration: BoxDecoration(
                        color: widget.getTheme() == ThemeMode.dark ? const Color(0xFF1A1A1A) : const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Center(
                        child:
                            AspectRatio(aspectRatio: 1.0, child: CircularProgressIndicator(color: Color(0xFFFF7349))),
                      ),
                    )
                  : TextField(
                      onTap: () async {
                        final descriptionController = TextEditingController(text: description);
                        final List<(String, int)> skillSet = [];

                        final res = skill_model.run(descriptionController.text);
                        setState(() {
                          skillSet.clear();
                          skillSet.addAll(res.entries
                              .map((e) => (e.key.name, e.value))
                              .sortedByCompare((e) => e.$2, (a, b) => b.compareTo(a))
                              .where((e) => e.$2 > 0));
                        });

                        final desc = await showDialog(
                          context: context,
                          barrierColor:
                              widget.getTheme() == ThemeMode.dark ? const Color(0x10FFFFFF) : const Color(0xA0000000),
                          builder: (context) => StatefulBuilder(
                            builder: (context, setState) => FractionallySizedBox(
                              widthFactor: 0.85,
                              heightFactor: 0.85,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: widget.getTheme() == ThemeMode.dark
                                      ? const Color(0xFF000000)
                                      : const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: FractionallySizedBox(
                                  widthFactor: 0.85,
                                  child: ListView(
                                    children: [
                                      const SizedBox(height: 24.0),
                                      Material(
                                        color: Colors.transparent,
                                        child: TextField(
                                          onTapOutside: (_) {
                                            final res = skill_model.run(descriptionController.text);
                                            setState(() {
                                              skillSet.clear();
                                              skillSet.addAll(res.entries
                                                  .map((e) => (e.key.name, e.value))
                                                  .sortedByCompare((e) => e.$2, (a, b) => b.compareTo(a))
                                                  .where((e) => e.$2 > 0));
                                            });
                                          },
                                          controller: descriptionController,
                                          maxLines: 5,
                                          decoration: InputDecoration(
                                            labelText: "Description",
                                            alignLabelWithHint: true,
                                            labelStyle: TextStyle(
                                              color: widget.getTheme() == ThemeMode.dark
                                                  ? const Color(0xFFEEEEEE)
                                                  : const Color(0xFF1A1A1A),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: widget.getTheme() == ThemeMode.dark
                                                    ? const Color(0xFFEEEEEE)
                                                    : const Color(0xFF1A1A1A),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: widget.getTheme() == ThemeMode.dark
                                                    ? const Color(0xFFEEEEEE)
                                                    : const Color(0xFF1A1A1A),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 24.0,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 40.0,
                                            child: Divider(
                                              color: widget.getTheme() == ThemeMode.dark
                                                  ? const Color(0xFFEEEEEE)
                                                  : const Color(0xFF1A1A1A),
                                            ),
                                          ),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            "Skill Set",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: widget.getTheme() == ThemeMode.dark
                                                  ? const Color(0xFFEEEEEE)
                                                  : const Color(0xFF1A1A1A),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 8.0),
                                          Expanded(
                                            child: Divider(
                                              color: widget.getTheme() == ThemeMode.dark
                                                  ? const Color(0xFFEEEEEE)
                                                  : const Color(0xFF1A1A1A),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 12.0,
                                      ),
                                      Visibility(
                                        visible: skillSet.isEmpty,
                                        child: Text(
                                          "No skills found, consider using more keywords!",
                                          style: TextStyle(
                                            color: widget.getTheme() == ThemeMode.dark
                                                ? const Color(0xFFEEEEEE)
                                                : const Color(0xFF1A1A1A),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      ...skillSet.mapIndexed((idx, e) => Container(
                                            decoration: BoxDecoration(
                                              color: widget.getTheme() == ThemeMode.dark
                                                  ? const Color(0xFF1A1A1A)
                                                  : const Color(0xFFEEEEEE),
                                              borderRadius: BorderRadius.only(
                                                topLeft: idx == 0 ? const Radius.circular(6.0) : Radius.zero,
                                                topRight: idx == 0 ? const Radius.circular(6.0) : Radius.zero,
                                                bottomLeft: idx == skillSet.length - 1
                                                    ? const Radius.circular(6.0)
                                                    : Radius.zero,
                                                bottomRight: idx == skillSet.length - 1
                                                    ? const Radius.circular(6.0)
                                                    : Radius.zero,
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                              vertical: 4.0,
                                            ),
                                            margin: const EdgeInsets.only(bottom: 8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  e.$1,
                                                  style: TextStyle(
                                                    color: widget.getTheme() == ThemeMode.dark
                                                        ? const Color(0xFFEEEEEE)
                                                        : const Color(0xFF1A1A1A),
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  e.$2.toString(),
                                                  style: TextStyle(
                                                    color: widget.getTheme() == ThemeMode.dark
                                                        ? const Color(0xFFEEEEEE)
                                                        : const Color(0xFF1A1A1A),
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                      const SizedBox(
                                        height: 24.0,
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: SizedBox(
                                          height: 40.0,
                                          width: 140.0,
                                          child: FilledButton(
                                            onPressed: () {
                                              RelayPool.instance.listen(
                                                  request: UserInfo.getRequest(widget.keychain.public),
                                                  onEvent: (event) async {
                                                    final old = UserInfo.fromEvent(event);
                                                    await RelayPool.instance.sendEvent(Event.from(
                                                      privkey: widget.keychain.private,
                                                      kind: EventKind.eventDeletion.value,
                                                      tags: [
                                                        ["e", event.id],
                                                      ],
                                                      content: "Deleting user info",
                                                    ));

                                                    await RelayPool.instance.sendEvent(UserInfo(
                                                      anonymous: old.anonymous,
                                                      firstName: old.firstName,
                                                      lastName: old.lastName,
                                                      description: descriptionController.text,
                                                    ).toEvent(widget.keychain));

                                                    if (!context.mounted) return;
                                                    Navigator.pop(context, descriptionController.text);
                                                  });
                                            },
                                            style: accentButtonStyle,
                                            child: const Text(
                                              "Validate",
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );

                        if (desc != null) {
                          setState(() {
                            description = desc;
                          });
                        }
                      },
                      controller:
                          TextEditingController(text: description!.isEmpty ? "No description found!" : description),
                      maxLines: 5,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: TextStyle(
                          color:
                              widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                        fillColor:
                            widget.getTheme() == ThemeMode.dark ? const Color(0xFF1A1A1A) : const Color(0xFFEEEEEE),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                        color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20.0),
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Row(children: [
                SizedBox(
                  width: 40.0,
                  child: Divider(
                    color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  "Credentials",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Divider(
                    color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                  ),
                )
              ]),
            ),
          ),
          const SizedBox(height: 20.0),
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: TextField(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: widget.keychain.public)).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor:
                            widget.getTheme() == ThemeMode.dark ? const Color(0xFF1A1A1A) : const Color(0xFFEEEEEE),
                        content: Text(
                          "Public key copied!",
                          style: TextStyle(
                            color:
                                widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                    );
                  });
                },
                controller: TextEditingController(
                  text: widget.keychain.public,
                ),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Public Key",
                  labelStyle: TextStyle(
                    color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                  fillColor: widget.getTheme() == ThemeMode.dark ? const Color(0xFF1A1A1A) : const Color(0xFFEEEEEE),
                  filled: true,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(
                  color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: TextField(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (ctx) => Theme(
                      data: ThemeData(
                        dialogTheme: DialogTheme(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          backgroundColor: const Color(0xFFFFFFFF),
                          surfaceTintColor: Colors.transparent,
                        ),
                        filledButtonTheme: FilledButtonThemeData(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateColor.resolveWith(
                              (states) => const Color(0xFFFF7349),
                            ),
                            shape: WidgetStateProperty.resolveWith(
                              (states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: ButtonStyle(
                            textStyle: WidgetStateProperty.resolveWith(
                              (states) => const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            shape: WidgetStateProperty.resolveWith(
                              (states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            overlayColor: WidgetStateColor.resolveWith(
                              (states) => const Color(0xFFFF7349).withOpacity(0.1),
                            ),
                            foregroundColor: WidgetStateColor.resolveWith(
                              (states) => const Color(0xFFFF7349),
                            ),
                          ),
                        ),
                      ),
                      child: AlertDialog(
                        title: const Text("Do you want to reveal your private key?"),
                        titleTextStyle: const TextStyle(
                          fontSize: 18.0,
                          color: Color(0xFF1A1A1A),
                          fontWeight: FontWeight.w600,
                        ),
                        content: const Text(
                          "The private key is your unique access to your account. DO NOT lose or share this key, as recovery is impossible and loss means others could gain full access to your account. Keep it secure.",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color(0xFF1A1A1A),
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        actions: [
                          Wrap(alignment: WrapAlignment.end, children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FilledButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Go back"),
                                  ),
                                  const SizedBox(width: 8.0),
                                  FilledButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() => _obscurePrivateKey = !_obscurePrivateKey);
                                    },
                                    child: Text(_obscurePrivateKey ? "Reveal" : "Hide"),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Clipboard.setData(ClipboardData(text: widget.keychain.private)).then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Private key copied!"),
                                    ),
                                  );
                                });
                              },
                              child: const Text(
                                "or just copy it!",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xFFFF7349),
                                  decorationThickness: 2.0,
                                ),
                              ),
                            ),
                          ])
                        ],
                      ),
                    ),
                  );
                },
                controller: TextEditingController(
                  text: widget.keychain.private,
                ),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Private Key",
                  labelStyle: TextStyle(
                    color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                  fillColor: widget.getTheme() == ThemeMode.dark ? const Color(0xFF1A1A1A) : const Color(0xFFEEEEEE),
                  filled: true,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: _obscurePrivateKey,
                obscuringCharacter: "*",
                style: TextStyle(
                  color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Row(children: [
                SizedBox(
                  width: 40.0,
                  child: Divider(
                    color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  "App Settings",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Divider(
                    color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                  ),
                )
              ]),
            ),
          ),
          const SizedBox(height: 10.0),
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                height: 45.0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                  color: widget.getTheme() == ThemeMode.dark ? const Color(0xFF1A1A1A) : const Color(0xFFEEEEEE),
                ),
                child: Row(
                  children: [
                    SwitchTheme(
                      data: SwitchThemeData(
                        thumbColor: WidgetStateColor.resolveWith(
                          (states) {
                            if (states.contains(WidgetState.selected)) {
                              return const Color(0xFFFF7349);
                            } else {
                              return const Color(0xFF9D9D9D);
                            }
                          },
                        ),
                        trackColor: WidgetStateColor.resolveWith(
                          (states) {
                            if (states.contains(WidgetState.selected)) {
                              return const Color(0xFFFF7349).withOpacity(0.2);
                            } else {
                              return const Color(0xFF9D9D9D).withOpacity(0.1);
                            }
                          },
                        ),
                        thumbIcon: WidgetStateProperty.resolveWith(
                          (states) {
                            if (states.contains(WidgetState.selected)) {
                              return const Icon(
                                Boxicons.bxs_moon,
                                color: Color(0xFFFFFFFF),
                              );
                            } else {
                              return const Icon(
                                Boxicons.bxs_sun,
                                color: Color(0xFFFFFFFF),
                              );
                            }
                          },
                        ),
                        trackOutlineColor: WidgetStateColor.resolveWith(
                          (states) {
                            if (states.contains(WidgetState.selected)) {
                              return const Color(0xFFFF7349);
                            } else {
                              return const Color(0xFF9D9D9D);
                            }
                          },
                        ),
                      ),
                      child: Switch(
                        onChanged: (_) {
                          widget.changeTheme();
                        },
                        value: widget.getTheme() == ThemeMode.dark,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      "Change theme",
                      style: TextStyle(
                        color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                height: 45.0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                  color: widget.getTheme() == ThemeMode.dark ? const Color(0xFF1A1A1A) : const Color(0xFFEEEEEE),
                ),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierColor:
                          widget.getTheme() == ThemeMode.dark ? const Color(0x10FFFFFF) : const Color(0xA0000000),
                      builder: (context) => StatefulBuilder(
                        builder: (context, setState) => FractionallySizedBox(
                          widthFactor: 0.85,
                          heightFactor: 0.85,
                          child: Container(
                            decoration: BoxDecoration(
                              color: widget.getTheme() == ThemeMode.dark
                                  ? const Color(0xFF000000)
                                  : const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListView(
                              children: [
                                const SizedBox(height: 20.0),
                                Center(
                                  child: FractionallySizedBox(
                                    widthFactor: 0.8,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 40.0,
                                          child: Divider(
                                            color: widget.getTheme() == ThemeMode.dark
                                                ? const Color(0xFFEEEEEE)
                                                : const Color(0xFF1A1A1A),
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          "Relay List",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: widget.getTheme() == ThemeMode.dark
                                                ? const Color(0xFFEEEEEE)
                                                : const Color(0xFF1A1A1A),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Expanded(
                                          child: Divider(
                                            color: widget.getTheme() == ThemeMode.dark
                                                ? const Color(0xFFEEEEEE)
                                                : const Color(0xFF1A1A1A),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                ...RelayPool.instance.urls.mapIndexed(
                                  (idx, url) => Center(
                                    child: FractionallySizedBox(
                                      widthFactor: 0.8,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: widget.getTheme() == ThemeMode.dark
                                                ? const Color(0xFF1A1A1A)
                                                : const Color(0xFFEEEEEE),
                                            borderRadius: BorderRadius.only(
                                              topLeft: idx == 0 ? const Radius.circular(6.0) : Radius.zero,
                                              bottomLeft: idx == 0 ? const Radius.circular(6.0) : Radius.zero,
                                              topRight: idx == RelayPool.instance.urls.length - 1
                                                  ? const Radius.circular(6.0)
                                                  : Radius.zero,
                                              bottomRight: idx == RelayPool.instance.urls.length - 1
                                                  ? const Radius.circular(6.0)
                                                  : Radius.zero,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                url,
                                                style: TextStyle(
                                                  color: widget.getTheme() == ThemeMode.dark
                                                      ? const Color(0xFFEEEEEE)
                                                      : const Color(0xFF1A1A1A),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                icon: const Icon(
                                                  Boxicons.bxs_trash,
                                                  color: Colors.red,
                                                  size: 20.0,
                                                ),
                                                onPressed: () {
                                                  RelayPool.instance.removeRelay(url);
                                                  setState(() {});
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Center(
                                  child: FractionallySizedBox(
                                    widthFactor: 0.8,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: widget.getTheme() == ThemeMode.dark
                                            ? const Color(0xFF1A1A1A)
                                            : const Color(0xFFEEEEEE),
                                        borderRadius: BorderRadius.circular(6.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Expanded(
                                          child: TextField(
                                            controller: _relayController,
                                            decoration: InputDecoration(
                                              hintText: "Add a relay",
                                              hintStyle: TextStyle(
                                                color: widget.getTheme() == ThemeMode.dark
                                                    ? const Color(0xFFEEEEEE)
                                                    : const Color(0xFF1A1A1A),
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  if (_relayController.text.isEmpty) return;
                                                  RelayPool.instance.addRelay(_relayController.text);
                                                  _relayController.clear();
                                                  setState(() {});
                                                },
                                                icon: Icon(
                                                  Boxicons.bx_plus,
                                                  color: widget.getTheme() == ThemeMode.dark
                                                      ? const Color(0xFFEEEEEE)
                                                      : const Color(0xFF1A1A1A),
                                                  size: 20.0,
                                                ),
                                              ),
                                              filled: false,
                                              fillColor: Colors.transparent,
                                              border: InputBorder.none,
                                            ),
                                            style: TextStyle(
                                              color: widget.getTheme() == ThemeMode.dark
                                                  ? const Color(0xFFEEEEEE)
                                                  : const Color(0xFF1A1A1A),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Center(
                                  child: FractionallySizedBox(
                                    widthFactor: 0.8,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 40.0,
                                          child: Divider(
                                            color: widget.getTheme() == ThemeMode.dark
                                                ? const Color(0xFFEEEEEE)
                                                : const Color(0xFF1A1A1A),
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          "Relay Settings",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: widget.getTheme() == ThemeMode.dark
                                                ? const Color(0xFFEEEEEE)
                                                : const Color(0xFF1A1A1A),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Expanded(
                                          child: Divider(
                                            color: widget.getTheme() == ThemeMode.dark
                                                ? const Color(0xFFEEEEEE)
                                                : const Color(0xFF1A1A1A),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      const SizedBox(width: 12.0),
                      const Icon(
                        Boxicons.bxs_component,
                        color: Color(0xFFFF7349),
                      ),
                      const SizedBox(width: 12.0),
                      Text(
                        "Relay settings",
                        style: TextStyle(
                          color:
                              widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40.0),
          Center(
            child: SizedBox(
              width: 180.0,
              height: 45.0,
              child: Theme(
                data: ThemeData(
                  filledButtonTheme: FilledButtonThemeData(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateColor.resolveWith(
                        (states) => const Color(0xFFFF7349),
                      ),
                      shape: WidgetStateProperty.resolveWith(
                        (states) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                ),
                child: FilledButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (ctx) => Theme(
                        data: ThemeData(
                          dialogTheme: DialogTheme(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            backgroundColor: const Color(0xFFFFFFFF),
                            surfaceTintColor: Colors.transparent,
                          ),
                          filledButtonTheme: FilledButtonThemeData(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateColor.resolveWith(
                                (states) => const Color(0xFFFF7349),
                              ),
                              shape: WidgetStateProperty.resolveWith(
                                (states) => RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: ButtonStyle(
                              textStyle: WidgetStateProperty.resolveWith(
                                (states) => const TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              shape: WidgetStateProperty.resolveWith(
                                (states) => RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              overlayColor: WidgetStateColor.resolveWith(
                                (states) => const Color(0xFFFF7349).withOpacity(0.1),
                              ),
                              foregroundColor: WidgetStateColor.resolveWith(
                                (states) => const Color(0xFFFF7349),
                              ),
                            ),
                          ),
                        ),
                        child: AlertDialog(
                          title: const Text("Are you sure you want to logout?"),
                          titleTextStyle: const TextStyle(
                            fontSize: 18.0,
                            color: Color(0xFF1A1A1A),
                            fontWeight: FontWeight.w600,
                          ),
                          content: const Text(
                            "Make sure you saved your private key, before loging out. Once lost, this account will be unrecoverable!",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Color(0xFF1A1A1A),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          actions: [
                            FilledButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Stay here"),
                            ),
                            const SizedBox(width: 8.0),
                            FilledButton(
                              onPressed: () {
                                Navigator.pop(context);
                                widget.onLogOut();
                              },
                              child: const Text("Log out"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Boxicons.bx_log_out,
                        size: 24.0,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        "Log out",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
