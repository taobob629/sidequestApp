import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/icon_font.dart';

class SixDigitPinInput extends StatefulWidget {
  const SixDigitPinInput({
    super.key,
    required this.controller,
    this.boxHeight = 46,
    this.gap = 7,
  });

  final TextEditingController controller;
  final double boxHeight;
  final double gap;

  @override
  State<SixDigitPinInput> createState() => _SixDigitPinInputState();
}

class _SixDigitPinInputState extends State<SixDigitPinInput> {
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_refresh);
  }

  @override
  void dispose() {
    focusNode.removeListener(_refresh);
    focusNode.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.controller,
      builder: (context, value, _) {
        final length = value.text.length;
        return Stack(
          children: [
            Row(
              children: List.generate(6, (index) {
                final filled = index < length;
                final active =
                    focusNode.hasFocus && index == length.clamp(0, 5);
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == 5 ? 0 : widget.gap,
                    ),
                    child: SizedBox(
                      height: widget.boxHeight,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: active
                              ? const Color(0xFF2B2B30)
                              : const Color(0xFF252529),
                          border: Border.all(
                            color: active
                                ? const Color(0xB8FFB20E)
                                : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Text(
                          filled ? '•' : '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            height: 1,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            Positioned.fill(
              child: Opacity(
                opacity: 0.01,
                child: TextField(
                  controller: widget.controller,
                  focusNode: focusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  showCursor: false,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
