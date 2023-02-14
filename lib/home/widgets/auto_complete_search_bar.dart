import 'package:firebase_custom/firebase_custom.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nameum/constant.dart';
import 'package:nameum/home/widgets/widgets.dart';
import 'package:nameum_types/nameum_types.dart';

class AutoCompleteSearchBar extends StatefulWidget {
  const AutoCompleteSearchBar({super.key, this.deactivated = false});
  final bool deactivated;
  @override
  State<AutoCompleteSearchBar> createState() => _AutoCompleteSearchBarState();
}

class _AutoCompleteSearchBarState extends State<AutoCompleteSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final LayerLink _link = LayerLink();
  final GlobalKey _key = GlobalKey();
  late final List<Store> totalStores;
  late List<Store> list;
  late OverlayEntry _overlayEntry = OverlayEntry(builder: _entry);

  Size _getOverlayEntrySize() {
    RenderBox renderBox = _key.currentContext!.findRenderObject()! as RenderBox;
    return renderBox.size;
  }


  void setList() async {
    totalStores = await FireStoreMethods.getAllStores();
  }
  void matchKeyword(String keyword) {
    list = totalStores.where((e) => e.storeName.contains(keyword)).toList();
  }
  Widget _entry(BuildContext context) {
    Size size = _getOverlayEntrySize();
    double height = 300.0;
    if (list.isNotEmpty && list.length <= 6) {
      height = list.length * searchRowHeight;
    } else if (list.isEmpty) {
      height = 50;
    }
    return Positioned(
      top: 0,
      left: 0,
      child: CompositedTransformFollower(
          offset: Offset(0.0, size.height),
          link: _link,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0.5,
                    blurRadius: 5,
                    offset: const Offset(0, 8))
              ],
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
            width: size.width,
            height: height + 12,
            child: list.isNotEmpty ? ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                itemCount: list.length,
                itemBuilder: ((context, index) {
                  if (index == list.length - 1) {
                    return SearchRow(store: list[index], entry:_overlayEntry);
                  } else {
                    return SearchRow(
                      store: list[index],
                      margin: 5,
                      entry:_overlayEntry
                    );
                  }
                })) : const Center(
                  child:  Material(
                    child:  Text("😭 검색 결과가 없습니다", style: TextStyle(
                      backgroundColor: Colors.white,
                      fontSize: 10
                    ),),
                  ),
                ),
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    setList();
  }

  @override
  void deactivate(){
    _overlayEntry.mounted ? _overlayEntry.remove() : null;
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _overlayEntry.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: TextFormField(
        key: _key,
        controller: _controller,
        onChanged: ((value) {
          if (value.length < 2) {
            _overlayEntry.mounted ? _overlayEntry.remove() : null;
          } else {
              Overlay.of(context)!.setState(() {
                list = totalStores.where((e) => e.storeName.contains(value)).toList();
              });
              if (!_overlayEntry.mounted) {
                _overlayEntry = OverlayEntry(builder: _entry);
                Overlay.of(context)!.insert(_overlayEntry);
              }
          }
        }),
        textAlignVertical: TextAlignVertical.center,
        cursorWidth: 1.5,
        autocorrect: false,
        enableSuggestions: false,
        style: GoogleFonts.nanumGothic(fontSize: 15),
        decoration: const InputDecoration(
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '텍스트를 입력하세요';
          }
          return null;
        },
      ),
    );
  }
}

class SearchRow extends StatelessWidget {
  const SearchRow({super.key, required this.store, this.margin = 0, required this.entry});
  final Store store;
  final double margin;
  final OverlayEntry entry;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        if(entry.mounted) entry.remove();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) {
        return StoreDetailNoHero(storeInfo: store);
      }));
      }),
      child: Card(
        margin: EdgeInsets.only(bottom: margin),
        child: SizedBox(
          height: searchRowHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.search),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 100,
                  child: Text(
                    style: const TextStyle(fontSize: 13),
                    store.storeName,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
