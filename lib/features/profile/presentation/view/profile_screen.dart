import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lotus_news/core/theme/theme_mode_provider.dart';
import 'package:lotus_news/features/assistant/presentation/view/chat_screen.dart';
import 'package:lotus_news/features/auth/presentation/view/login_screen.dart';
import 'package:lotus_news/features/auth/presentation/view_model/auth_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AuthViewModel>().isAuthenticated();
  }

  @override
  void dispose() {
    _oldPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hồ sơ'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.notifications_outlined,
              color: Colors.blueAccent.shade700,
            ),
          ),
        ],
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                maxRadius: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1633332755192-727a05c4013d?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D',
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    '1.1k',
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                  Text(
                    'Following',
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '205',
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                  Text(
                    'Followers',
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '12',
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                  Text(
                    'News',
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Nathan Nguyen',
              style: theme.textTheme.titleMedium!.copyWith(
                color: theme.primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
              style: theme.textTheme.labelSmall!.copyWith(
                color: theme.primaryColor,
                fontSize: 12,
              ),
            ),
          ),
          Divider(thickness: 1, color: theme.primaryColor),
          ListTile(
            leading: Icon(Icons.nightlight_outlined, color: theme.primaryColor),
            title: Text(
              'Dark Mode',
              style: theme.textTheme.labelMedium!.copyWith(
                color: theme.primaryColor,
              ),
            ),
            trailing: Consumer<ThemeModeProvider>(
              builder:
                  (
                    BuildContext context,
                    ThemeModeProvider value,
                    Widget? child,
                  ) {
                    return Switch(
                      value: value.mode == ThemeMode.dark,
                      onChanged: (value) {
                        context.read<ThemeModeProvider>().toggle();
                      },
                    );
                  },
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChatScreen()),
              );
            },
            leading: Icon(Icons.mark_chat_unread_outlined),
            title: Text('Hỏi đáp'),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.fingerprint),
            title: Text('Vân tay'),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.contact_page_outlined),
            title: Text('liện hệ'),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.info_outline),
            title: Text('Giới thiệu'),
            trailing: Icon(Icons.chevron_right),
          ),
          Consumer<AuthViewModel>(
            builder: (_, viewModel, __) {
              if (viewModel.state is ChangePasswordProcessing) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  );
                });
              }
              if (viewModel.state is ChangePasswordSuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đổi mật khẩu thành công'),
                      backgroundColor: Colors.green,
                    ),
                  );
                });
              }
              if (viewModel.state is ChangePasswordError) {
                final errorState = viewModel.state as ChangePasswordError;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorState.message ?? 'Đã có lỗi xảy ra'),
                      backgroundColor: Colors.red,
                    ),
                  );
                });
              }
              return ListTile(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (ctx) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 5,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                TextFormField(
                                  controller: _oldPassword,
                                  decoration: const InputDecoration(
                                    hintText: 'Nhập mật khẩu cũ',
                                    disabledBorder: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(),
                                    errorBorder: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _newPassword,
                                  decoration: const InputDecoration(
                                    hintText: 'Nhập mật khẩu mới',
                                    disabledBorder: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(),
                                    errorBorder: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _confirmPassword,
                                  decoration: const InputDecoration(
                                    hintText: 'Xác nhận mật khẩu',
                                    disabledBorder: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(),
                                    errorBorder: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_oldPassword.text.isEmpty ||
                                        _newPassword.text.isEmpty ||
                                        _confirmPassword.text.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Vui lòng nhập đầy đủ thông tin',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }
                                    if (_newPassword.text !=
                                        _confirmPassword.text) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Mật khẩu mới không trùng khớp',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );

                                      return;
                                    }
                                    Navigator.pop(ctx);
                                    context
                                        .read<AuthViewModel>()
                                        .changePassword(
                                          _oldPassword.text,
                                          _newPassword.text,
                                        );
                                  },
                                  style: const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll<Color>(
                                          Colors.green,
                                        ),
                                  ),
                                  child: const Text(
                                    'Đổi mật khẩu',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                leading: const Icon(Icons.published_with_changes),
                title: const Text('Đổi mật khẩu'),
                trailing: const Icon(Icons.chevron_right),
              );
            },
          ),
          Consumer<AuthViewModel>(
            builder: (_, state, child) {
              debugPrint('sign out state: ${state.state}');
              final isAuthenticated = state.state is HasAuthenticated;
              return ListTile(
                onTap: () async {
                  if (isAuthenticated) {
                    context.read<AuthViewModel>().signOUt();
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  }
                },
                leading: Icon(Icons.logout_outlined, color: Colors.red),
                title: Text(
                  isAuthenticated ? 'Đăng xuất' : 'Đăng nhập',
                  style: theme.textTheme.labelMedium!.copyWith(
                    color: theme.primaryColor,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: theme.primaryColor),
              );
            },
          ),
        ],
      ),
    );
  }
}
