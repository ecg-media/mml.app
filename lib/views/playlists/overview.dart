import 'package:flutter/material.dart';
import 'package:mml_app/components/async_list_view.dart';
import 'package:mml_app/components/delete_dialog.dart';
import 'package:mml_app/components/filter_app_bar.dart';
import 'package:mml_app/models/model_base.dart';
import 'package:mml_app/models/record.dart';
import 'package:mml_app/view_models/playlists/overview.dart';
import 'package:mml_app/views/playlists/edit.dart';
import 'package:provider/provider.dart';

/// Overview screen of the playlists of the music lib.
class PlaylistScreen extends StatelessWidget {
  final FilterAppBar? appBar;

  /// Initializes the instance.
  const PlaylistScreen({Key? key, this.appBar}) : super(key: key);

  /// Builds the screen.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlaylistViewModel>(
      create: (context) => PlaylistViewModel(),
      builder: (context, _) {
        var vm = Provider.of<PlaylistViewModel>(context, listen: false);

        return FutureBuilder(
          future: vm.init(context),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return AsyncListView(
              title: vm.locales.playlist,
              selectedItemsAction: appBar?.listAction,
              onMultiSelect: (selectedItems) async {
                var shouldDelete = await showDeleteDialog(context);

                if (shouldDelete) {
                  await vm.deleteRecords(selectedItems as List<ModelBase?>);
                }

                return shouldDelete;
              },
              loadData: vm.load,
              addItem: () async {
                return await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return const PlaylistEditDialog(playlistId: null);
                  },
                );
              },
              editGroupFunction: (item) async {
                return await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return PlaylistEditDialog(
                      playlistId: (item as Record).playlist!.id,
                    );
                  },
                );
              },
              // TODO ply records in playlist
              // openItemFunction: (
              //   ModelBase item,
              //   String? filter,
              //   Subfilter? subfilter,
              // ) {
              //   vm.playRecord(
              //     context,
              //     item,
              //     filter,
              //     subfilter as ID3TagFilter,
              //   );
              // },
            );
          },
        );
      },
    );
  }
}
