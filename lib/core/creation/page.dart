import 'package:dmp3s/common/api/relay/pool.dart';
import 'package:dmp3s/common/model/challenge.dart';
import 'package:dmp3s/common/style/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:nostr/nostr.dart';

class ChallengeCreationPage extends StatefulWidget {
  const ChallengeCreationPage({super.key, required this.getTheme, required this.keychain});

  final Keychain keychain;
  final ThemeMode Function() getTheme;

  @override
  State<ChallengeCreationPage> createState() => _ChallengeCreationPageState();
}

class _ChallengeCreationPageState extends State<ChallengeCreationPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ecsControler = TextEditingController();
  final TextEditingController _satsController = TextEditingController();
  final List<String> _selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.getTheme() == ThemeMode.dark ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
      body: SafeArea(
        child: ListView(
          children: [
            Row(
              children: [
                const SizedBox(width: 8.0),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  iconSize: 32.0,
                  icon: Icon(
                    Boxicons.bx_chevron_left,
                    color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  "Create a challenge",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                    color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            FractionallySizedBox(
              widthFactor: 0.85,
              child: Row(
                children: [
                  SizedBox(
                    width: 40.0,
                    child: Divider(
                      color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    "General Information",
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            FractionallySizedBox(
              widthFactor: 0.85,
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: TextStyle(
                    color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            FractionallySizedBox(
              widthFactor: 0.85,
              child: TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Description",
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(
                    color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            FractionallySizedBox(
              widthFactor: 0.85,
              child: Row(
                children: [
                  SizedBox(
                    width: 40.0,
                    child: Divider(
                      color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    "Rewards",
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            FractionallySizedBox(
              widthFactor: 0.85,
              child: TextField(
                controller: _ecsControler,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "ECs (default: 0)",
                  labelStyle: TextStyle(
                    color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            FractionallySizedBox(
              widthFactor: 0.85,
              child: TextField(
                controller: _satsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Satoshis (default: 0)",
                  labelStyle: TextStyle(
                    color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            FractionallySizedBox(
              widthFactor: 0.85,
              child: Row(
                children: [
                  SizedBox(
                    width: 40.0,
                    child: Divider(
                      color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    "Tags",
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            FractionallySizedBox(
              widthFactor: 0.85,
              child: Wrap(children: [
                for (final tag in [
                  "internship",
                  "minor",
                  "problem",
                  "assignment",
                  "business",
                  "marketing",
                  "human resources",
                  "project management",
                  "technical",
                  "computer science",
                  "architecture",
                  "mechanical engineering",
                  "electronic engineering",
                  "civil engineering",
                  "chemical engineering",
                  "biomedical engineering",
                  "environmental engineering",
                ])
                  GestureDetector(
                    onTap: () {
                      if (_selectedTags.length < 5) {
                        setState(() {
                          if (_selectedTags.contains(tag)) {
                            _selectedTags.remove(tag);
                          } else {
                            _selectedTags.add(tag);
                          }
                        });
                      } else {
                        if (_selectedTags.contains(tag)) {
                          setState(() {
                            _selectedTags.remove(tag);
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("You can only select up to 5 tags."),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                      margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: _selectedTags.contains(tag) ? const Color(0xFFFF7349) : const Color(0xFF9D9D9D),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
              ]),
            ),
            const SizedBox(height: 40.0),
            FractionallySizedBox(
              widthFactor: 0.85,
              child: Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  height: 45.0,
                  width: 160.0,
                  child: FilledButton(
                    onPressed: () {
                      if (_titleController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter a title."),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else if (_descriptionController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter a description."),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        RelayPool.instance.sendEvent(Challenge(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          tags: _selectedTags,
                          rewards: [
                            Reward(type: RewardType.europeanCredit, amount: int.tryParse(_ecsControler.text) ?? 0),
                            Reward(type: RewardType.bitcoin, amount: int.tryParse(_satsController.text) ?? 0),
                          ].where((e) => e.amount > 0).toList(),
                        ).toEvent(widget.keychain));
                        Navigator.pop(context);
                      }
                    },
                    style: accentButtonStyle,
                    child: const Text(
                      "Upload",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}
