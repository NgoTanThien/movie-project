import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final VoidCallback onVoidSearch;
  final bool isListening;

  SearchBarWidget({super.key,
    required this.controller,
    required this.onSearch,
    this.isListening = false,
    required this.onVoidSearch
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: Colors.white,
        ),
        onChanged: onSearch,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
            hintText: "Tìm kiếm phim...",
            hintStyle: TextStyle(
                color: Colors.grey
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            suffixIcon: Row(
              mainAxisSize: .min,
              children: [
                if(controller.text.isNotEmpty)
                  IconButton(
                      onPressed: () {
                        controller.clear();
                        onSearch("");
                      },
                      icon: Icon(
                        Icons.clear,
                        color: Colors.grey,
                      )
                  ),
                ElevatedButton(
                    onPressed: () async {
                      await requestPermission(Permission.microphone);
                    },
                    child: Icon(
                      Icons.mic,
                      color: isListening ? Colors.red : Colors.grey,
                    )
                )
              ],
            ),
            filled: true,
            fillColor: Color(0xFF2A2A2A),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12
            )
        ),
      ),
    );
  }

  Future<bool> requestPermission(Permission microphone) async {
    if (await microphone.isGranted) {
      return true;
    }
    PermissionStatus status = await microphone.request();
    if (status.isGranted) {
      return true;
    }
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }
}


