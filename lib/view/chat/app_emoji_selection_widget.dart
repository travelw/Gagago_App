import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class EmojiSelectionPickerScreen extends StatefulWidget {
  final ValueChanged<String>? onEmojiSelected;
  const EmojiSelectionPickerScreen({Key? key, required this.onEmojiSelected})
      : super(key: key);

  @override
  State<EmojiSelectionPickerScreen> createState() =>
      _EmojiSelectionPickerScreenState();
}

class _EmojiSelectionPickerScreenState
    extends State<EmojiSelectionPickerScreen> {
  @override
  Widget build(BuildContext context) =>

      // EmojiPicker2(
      //   rows: 5,
      //   columns: 7,
      //   // recommendKeywords: ["racing", "horse"],
      //   // numRecommended: 10,
      //   onEmojiSelected: (Emoji emoji, Category category) {
      //     widget.onEmojiSelected(emoji.emoji);
      //   },
      // );

      EmojiPicker(
        onEmojiSelected: (Category? category, Emoji? emoji) {
          print("selected Category is =====>>$category");
          print("selected emoji is =====>>$emoji");

          widget.onEmojiSelected!(emoji!.emoji);
        },
        onBackspacePressed: () {
          // Do something when the user taps the backspace button (optional)
          // Set it to null to hide the Backspace-Button
        },
        // textEditingController:
        //     textEditionController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
        config: Config(
          columns: 9,
          emojiSizeMax: 25 *
              (foundation.defaultTargetPlatform == TargetPlatform.iOS
                  ? 1.30
                  : 1.0),
          verticalSpacing: 0,
          horizontalSpacing: 0,
          gridPadding: EdgeInsets.zero,
          initCategory: Category.RECENT,
          // bgColor: Color(0xFFF2F2F2),
          bgColor: Colors.white,
          // indicatorColor: Colors.blue,
          indicatorColor: Theme.of(context).colorScheme.primary,
          iconColor: Colors.grey,
          // iconColor: Theme.of(context).colorScheme.primary,
          // iconColorSelected: Colors.blue,
          iconColorSelected: Theme.of(context).colorScheme.secondary,
          // backspaceColor: Colors.blue,
          backspaceColor: Theme.of(context).colorScheme.primary,
          skinToneDialogBgColor: Colors.white,
          skinToneIndicatorColor: Colors.grey,
          enableSkinTones: true,
          // showRecentsTab: true,
          recentsLimit: 28,
          noRecents: const Text(
            'No Recent',
            style: TextStyle(fontSize: 20, color: Colors.black26),
            textAlign: TextAlign.center,
          ), // Needs to be const Widget
          loadingIndicator: const SizedBox.shrink(), // Needs to be const Widget
          tabIndicatorAnimDuration: kTabScrollDuration,
          categoryIcons: const CategoryIcons(),
          buttonMode: ButtonMode.MATERIAL,
        ),
      );
}
