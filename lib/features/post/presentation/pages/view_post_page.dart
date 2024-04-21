import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:take_my_tym/core/bloc/app_user_bloc.dart';
import 'package:take_my_tym/core/utils/app_images.dart';
import 'package:take_my_tym/core/widgets/back_navigation_button.dart';
import 'package:take_my_tym/core/widgets/home_padding.dart';
import 'package:take_my_tym/core/widgets/popup_menu_item_child_widget.dart';
import 'package:take_my_tym/core/widgets/snack_bar_messenger_widget.dart';
import 'package:take_my_tym/core/model/app_post_model.dart';
import 'package:take_my_tym/features/message/presentation/pages/individual_chat_page.dart';
import 'package:take_my_tym/features/post/presentation/bloc/delete_post_bloc/delete_post_bloc.dart';
import 'package:take_my_tym/features/post/presentation/bloc/read_post_bloc/read_post_bloc.dart';
import 'package:take_my_tym/features/post/presentation/pages/create_post_first_page.dart';
import 'package:take_my_tym/features/post/presentation/widgets/chat_floating_action_button.dart';
import 'package:take_my_tym/features/post/presentation/widgets/delete_post_cofirm_dialog.dart';
import 'package:take_my_tym/features/post/presentation/widgets/post_description_widget.dart';
import 'package:take_my_tym/features/post/presentation/widgets/post_owner_info_widget.dart';
import 'package:take_my_tym/features/post/presentation/widgets/post_service_widget.dart';
import 'package:take_my_tym/features/post/presentation/widgets/post_specifications_widget.dart';
import 'package:take_my_tym/features/post/presentation/widgets/post_title_widget.dart';
import 'package:take_my_tym/features/post/presentation/widgets/skills_widget.dart';
import 'package:take_my_tym/features/post/presentation/widgets/submit_button.dart';

class ViewPostPage extends StatelessWidget {
  final PostModel postModel;
  const ViewPostPage({required this.postModel, super.key});

  static route({required PostModel postModel}) => MaterialPageRoute(
        builder: (_) => ViewPostPage(postModel: postModel),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<DeletePostBloc, DeletePostState>(
              listener: (context, state) {
            if (state is DeletPostSuccessState) {
              state.refreshType
                  ? context.read<GetPostsBloc>().add(
                        GetBuyTymPostsEvent(
                          userId: state.uid,
                        ),
                      )
                  : context.read<GetPostsBloc>().add(
                        GetSellTymPostsEvent(
                          userId: state.uid,
                        ),
                      );
              Navigator.pop(context);
              Navigator.pop(context);
            }
            if (state is DeletPostFailState) {
              SnackBarMessenger().showSnackBar(
                context: context,
                errorMessage: state.message,
                errorDescription: state.description,
              );
            }
          }),
        ],
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              ViewPostAppBar(
                update: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreatePostFirstPage(
                                postModel: postModel,
                              )));
                },
                delete: () {
                  DletePost().showDletePostDialog(
                    context: context,
                    postModel: postModel,
                  );
                },
                showMoreButton: postModel.uid ==
                    context.read<AppUserBloc>().appUserModel!.uid,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    HomePadding(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h),
                          ServiceTypeWidget(type: postModel.workType),
                          SizedBox(height: 15.h),
                          PostTitleWidget(
                            title: postModel.title,
                          ),
                          SizedBox(height: 20.h),
                          PostOwnerInfoWidget(
                            name: postModel.userName,
                            image: MyAppImages.testProfile,
                            date: 'Oct 15,2023',
                          ),
                          SizedBox(height: 20.h),
                          PostDescriptionWidget(
                            description: postModel.content,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    const Divider(),
                    SizedBox(height: 20.h),
                    HomePadding(
                        child: SkillsWidget(
                      skillList: postModel.skills,
                    )),
                    SizedBox(height: 20.h),
                    const Divider(),
                    SizedBox(height: 20.h),
                    HomePadding(
                      child: PostConstraintsWidget(
                        location: postModel.location,
                        level: postModel.skillLevel,
                        amount: postModel.price,
                        flexible: true,
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: postModel.uid !=
              context.read<AppUserBloc>().appUserModel!.uid
          ? ChatFloatingActionButton(
              callBack: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => IndividualChatPage(
                      currentUid: context.read<AppUserBloc>().appUserModel!.uid,
                      senderName:
                          context.read<AppUserBloc>().appUserModel!.userName,
                      receiverUid: postModel.uid,
                      receiverName: postModel.userName,
                    ),
                  ),
                );
              },
            )
          : null,
      bottomNavigationBar: SubmitButton(
        callback: () {},
      ),
    );
  }
}

class ViewPostAppBar extends StatelessWidget {
  final VoidCallback delete;
  final VoidCallback update;
  final bool showMoreButton;
  const ViewPostAppBar({
    required this.showMoreButton,
    required this.update,
    required this.delete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      floating: true,
      leading: const BackButtonWidget(),
      actions: [
        showMoreButton
            ? PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                      value: ("Update"),
                      child: PopupMenuItemChildWidget(
                        value: 'Update',
                        icon: IconlyLight.edit,
                      )),
                  const PopupMenuItem(
                    value: ("Delete"),
                    child: PopupMenuItemChildWidget(
                        value: 'Delete', icon: IconlyLight.delete),
                  )
                ],
                onSelected: (value) {
                  if (value == "Delete") {
                    delete();
                  } else if (value == "Update") {
                    update();
                  }
                },
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
