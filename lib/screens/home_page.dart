import 'package:fe_training/provider/home_provider.dart';
import 'package:fe_training/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider()..fetchItems(),
      child: Consumer<HomeProvider>(
        builder: (context, state, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('Home')),
            body: _body(state, context),
            floatingActionButton: _fabAddItem(context, state),
          );
        },
      ),
    );
  }

  FloatingActionButton _fabAddItem(BuildContext context, HomeProvider state) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return DialogAddItem(state: state);
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }

  Column _body(HomeProvider state, BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: state.isLoading
              ? Center(child: CircularProgressIndicator())
              : _listViewItem(state),
        ),
        ElevatedButton(
          onPressed: () {
            state.logout().then((_) {
              if (context.mounted) {
                context.pushReplacement(Routes.login);
              }
            });
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }

  ListView _listViewItem(HomeProvider state) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
          title: InkWell(
            onTap: () {
              state.descController.text = state.items[index].desc ?? '';
              state.namaController.text = state.items[index].name ?? '';
              showDialog(
                context: context,
                builder: (context) {
                  return DialogAddItem(state: state, index: index);
                },
              );
            },
            child: Text(state.items[index].name ?? '-'),
          ),
          subtitle: Text(state.items[index].desc ?? '-'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  state.toggleFavorite(index);
                },
                icon: state.items[index].isFavorite
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_border),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  state.removeItem(index);
                },
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: state.items.length,
    );
  }
}

class DialogAddItem extends StatefulWidget {
  const DialogAddItem({super.key, required this.state, this.index});
  final HomeProvider state;
  final int? index;

  @override
  State<DialogAddItem> createState() => _DialogAddItemState();
}

class _DialogAddItemState extends State<DialogAddItem> {
  HomeProvider get state => widget.state;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: state.namaController,

            decoration: const InputDecoration(hintText: 'Enter item'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: state.descController,
            decoration: const InputDecoration(hintText: 'Enter description'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (widget.index == null) {
                state.addItem();
              } else {
                state.updateItem(widget.index!);
              }
              if (context.mounted) {
                context.pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
