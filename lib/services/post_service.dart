import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaistable_website/models/post_model.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  CollectionReference get _postsCollection => _firestore.collection('posts');

  // Create a new post
  Future<String?> createPost(PostModel post) async {
    try {
      final docRef = _postsCollection.doc();
      post.postID = docRef.id;
      post.createdAt = DateTime.now();
      post.updatedAt = DateTime.now();
      post.likesCount = 0;
      post.commentsCount = 0;
      post.likedBy = [];

      await docRef.set(post.toFirestore());
      return post.postID;
    } catch (e) {
      print('Error creating post: $e');
      return null;
    }
  }

  // Get trending posts (most liked in last 7 days)
  Stream<List<PostModel>> getTrendingPosts({int limit = 20}) {
    final sevenDaysAgo = DateTime.now().subtract(Duration(days: 7));
    
    return _postsCollection
        .where('createdAt', isGreaterThan: sevenDaysAgo)
        .orderBy('createdAt', descending: false)
        .orderBy('likesCount', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PostModel.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Get recent posts
  Stream<List<PostModel>> getRecentPosts({int limit = 20}) {
    return _postsCollection
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PostModel.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Get posts by user
  Stream<List<PostModel>> getUserPosts(String userID, {int limit = 20}) {
    return _postsCollection
        .where('userID', isEqualTo: userID)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PostModel.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Like/Unlike a post
  Future<bool> toggleLike(String postID) async {
    try {
      final currentUserID = _auth.currentUser?.uid;
      if (currentUserID == null) return false;

      final docRef = _postsCollection.doc(postID);
      final doc = await docRef.get();
      
      if (!doc.exists) return false;

      final post = PostModel.fromFirestore(doc.data() as Map<String, dynamic>);
      final likedBy = post.likedBy ?? [];
      
      if (likedBy.contains(currentUserID)) {
        // Unlike
        likedBy.remove(currentUserID);
        await docRef.update({
          'likedBy': likedBy,
          'likesCount': (post.likesCount ?? 0) - 1,
        });
      } else {
        // Like
        likedBy.add(currentUserID);
        await docRef.update({
          'likedBy': likedBy,
          'likesCount': (post.likesCount ?? 0) + 1,
        });
      }
      return true;
    } catch (e) {
      print('Error toggling like: $e');
      return false;
    }
  }

  // Delete a post
  Future<bool> deletePost(String postID) async {
    try {
      await _postsCollection.doc(postID).delete();
      return true;
    } catch (e) {
      print('Error deleting post: $e');
      return false;
    }
  }

  // Check if current user liked a post
  Future<bool> isPostLikedByCurrentUser(String postID) async {
    try {
      final currentUserID = _auth.currentUser?.uid;
      if (currentUserID == null) return false;

      final doc = await _postsCollection.doc(postID).get();
      if (!doc.exists) return false;

      final post = PostModel.fromFirestore(doc.data() as Map<String, dynamic>);
      return post.likedBy?.contains(currentUserID) ?? false;
    } catch (e) {
      print('Error checking like status: $e');
      return false;
    }
  }
}
