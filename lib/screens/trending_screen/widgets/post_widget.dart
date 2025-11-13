import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/models/post_model.dart';
import 'package:kaistable_website/services/post_service.dart';
import 'package:kaistable_website/screens/trending_screen/widgets/report_dialog.dart';
import 'package:kaistable_website/screens/user_profile_screen/user_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class PostWidget extends StatefulWidget {
  final PostModel post;

  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final PostService _postService = PostService();
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _checkLikeStatus();
  }

  Future<void> _checkLikeStatus() async {
    final isLiked =
        await _postService.isPostLikedByCurrentUser(widget.post.postID ?? '');
    setState(() {
      _isLiked = isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 12),
            _buildContent(),
            if (widget.post.images != null && widget.post.images!.isNotEmpty)
              _buildImages(),
            SizedBox(height: 8),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: _navigateToUserProfile,
          child: CircleAvatar(
            radius: 20,
            backgroundImage: widget.post.userImage != null &&
                    widget.post.userImage!.isNotEmpty
                ? NetworkImage(widget.post.userImage!)
                : null,
            child:
                widget.post.userImage == null || widget.post.userImage!.isEmpty
                    ? Icon(Icons.person, size: 24)
                    : null,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: _navigateToUserProfile,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.userName ?? 'Unknown User',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'Nunito-Bold',
                  ),
                ),
                Text(
                  _formatDate(widget.post.createdAt),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: 'Nunito-Regular',
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.grey),
          onSelected: (value) {
            if (value == 'report') {
              _showReportDialog();
            } else if (value == 'delete') {
              _deletePost();
            }
          },
          itemBuilder: (BuildContext context) {
            final currentUserID = FirebaseAuth.instance.currentUser?.uid;
            final isOwnPost = currentUserID == widget.post.userID;

            return [
              if (!isOwnPost)
                PopupMenuItem(
                  value: 'report',
                  child: Row(
                    children: [
                      Icon(Icons.flag, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('Report'),
                    ],
                  ),
                ),
              if (isOwnPost)
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
            ];
          },
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Text(
      widget.post.content ?? '',
      style: TextStyle(
        fontSize: 14,
        fontFamily: 'Nunito-Regular',
      ),
    );
  }

  Widget _buildImages() {
    final images = widget.post.images!;

    if (images.length == 1) {
      return Padding(
        padding: EdgeInsets.only(top: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            images[0],
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                color: Colors.grey[200],
                child: Icon(Icons.image_not_supported, size: 50),
              );
            },
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: images.length > 4 ? 4 : images.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              images[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        InkWell(
          onTap: _toggleLike,
          child: Row(
            children: [
              Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                color: _isLiked ? Colors.red : Colors.grey,
                size: 24,
              ),
              SizedBox(width: 4),
              Text(
                '${widget.post.likesCount ?? 0}',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Nunito-Regular',
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 24),
        Icon(Icons.comment_outlined, color: Colors.grey, size: 24),
        SizedBox(width: 4),
        Text(
          '${widget.post.commentsCount ?? 0}',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Nunito-Regular',
          ),
        ),
        if (widget.post.restaurantName != null)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.restaurant, color: AppColors.primaryColor, size: 16),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    widget.post.restaurantName!,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryColor,
                      fontFamily: 'Nunito-Regular',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  Future<void> _toggleLike() async {
    final success = await _postService.toggleLike(widget.post.postID ?? '');
    if (success) {
      setState(() {
        _isLiked = !_isLiked;
        if (_isLiked) {
          widget.post.likesCount = (widget.post.likesCount ?? 0) + 1;
        } else {
          widget.post.likesCount = (widget.post.likesCount ?? 0) - 1;
        }
      });
    }
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => ReportDialog(
        contentID: widget.post.postID ?? '',
        contentType: 'post',
        reportedUserID: widget.post.userID ?? '',
        reportedUserName: widget.post.userName ?? '',
      ),
    );
  }

  Future<void> _deletePost() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Post'),
        content: Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _postService.deletePost(widget.post.postID ?? '');
      if (success) {
        Get.snackbar(
          'Success',
          'Post deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void _navigateToUserProfile() {
    final currentUserID = FirebaseAuth.instance.currentUser?.uid;

    // Don't navigate to own profile
    if (currentUserID == widget.post.userID) {
      return;
    }

    Get.to(() => UserProfileScreen(
          userID: widget.post.userID ?? '',
          userName: widget.post.userName ?? 'Unknown User',
          userImage: widget.post.userImage,
        ));
  }
}
