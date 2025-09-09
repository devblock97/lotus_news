import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lotus_news/core/components/no_data_view.dart';
import 'package:lotus_news/features/search/presentation/view_model/search_state.dart';
import 'package:lotus_news/features/search/presentation/view_model/search_view_model.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Tìm kiếm'),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border(
                left: BorderSide(color: Colors.black),
                top: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
                bottom: BorderSide(color: Colors.black),
              )
            ),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none
                ),
                prefixIcon: Icon(Icons.search, color: Colors.black,),
                hintText: 'Tìm kiếm bài viết thể thao, chính trị, giải trí...',
                hintStyle: theme.textTheme.labelSmall!.copyWith(color: theme.primaryColor),
              ),
              onChanged: (value) {
                context.read<SearchViewModel>().search(value);
              },
            ),
          ),
          Consumer<SearchViewModel>(
            builder: (_, state, child) {
              switch (state) {
                case SearchLoading _:
                  return Center(child: CircularProgressIndicator(),);
                case SearchError message:
                  return Text(message.message ?? '');
                case SearchSuccess data:
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.data.length,
                    itemBuilder: (context, index) {
                      return Text(data.data[index].title, style: TextStyle(color: Colors.black),);
                    },
                  );
                default:
                  return Center(child: NoDataView(),);
              }
            },
          )
        ],
      ),
    );
  }
}
