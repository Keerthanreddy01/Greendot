import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/forum_model.dart';

class CommunityForumService {
  static final CommunityForumService _instance = CommunityForumService._internal();
  factory CommunityForumService() => _instance;
  CommunityForumService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Posts collection
  CollectionReference get _postsCollection => _firestore.collection('forum_posts');

  Future<void> createPost(ForumPost post) async {
    await _postsCollection.doc(post.id).set(post.toJson());
  }

  Future<void> updatePost(ForumPost post) async {
    await _postsCollection.doc(post.id).update(post.toJson());
  }

  Future<void> deletePost(String postId) async {
    // Delete all comments first
    final comments = await _postsCollection
        .doc(postId)
        .collection('comments')
        .get();

    for (var doc in comments.docs) {
      await doc.reference.delete();
    }

    // Delete the post
    await _postsCollection.doc(postId).delete();
  }

  Stream<List<ForumPost>> getPosts({String? category, int limit = 20}) {
    Query query = _postsCollection.orderBy('createdAt', descending: true);

    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    query = query.limit(limit);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ForumPost.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<ForumPost?> getPostById(String postId) async {
    final doc = await _postsCollection.doc(postId).get();
    if (!doc.exists) return null;
    return ForumPost.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<void> likePost(String postId, String userId) async {
    final postDoc = await _postsCollection.doc(postId).get();
    if (!postDoc.exists) return;

    final post = ForumPost.fromJson(postDoc.data() as Map<String, dynamic>);
    
    if (post.likes.contains(userId)) {
      // Unlike
      await _postsCollection.doc(postId).update({
        'likes': FieldValue.arrayRemove([userId]),
        'likesCount': FieldValue.increment(-1),
      });
    } else {
      // Like
      await _postsCollection.doc(postId).update({
        'likes': FieldValue.arrayUnion([userId]),
        'likesCount': FieldValue.increment(1),
      });
    }
  }

  // Comments
  Future<void> addComment(String postId, Comment comment) async {
    await _postsCollection
        .doc(postId)
        .collection('comments')
        .doc(comment.id)
        .set(comment.toJson());

    // Update comment count
    await _postsCollection.doc(postId).update({
      'commentsCount': FieldValue.increment(1),
    });
  }

  Future<void> deleteComment(String postId, String commentId) async {
    await _postsCollection
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete();

    // Update comment count
    await _postsCollection.doc(postId).update({
      'commentsCount': FieldValue.increment(-1),
    });
  }

  Stream<List<Comment>> getComments(String postId) {
    return _postsCollection
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Comment.fromJson(doc.data());
      }).toList();
    });
  }

  Future<void> likeComment(String postId, String commentId, String userId) async {
    final commentDoc = await _postsCollection
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .get();

    if (!commentDoc.exists) return;

    final comment = Comment.fromJson(commentDoc.data()!);

    if (comment.likes.contains(userId)) {
      // Unlike
      await commentDoc.reference.update({
        'likes': FieldValue.arrayRemove([userId]),
        'likesCount': FieldValue.increment(-1),
      });
    } else {
      // Like
      await commentDoc.reference.update({
        'likes': FieldValue.arrayUnion([userId]),
        'likesCount': FieldValue.increment(1),
      });
    }
  }

  Future<void> markAsHelpful(String postId, String commentId) async {
    await _postsCollection
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .update({'isHelpful': true});
  }

  Stream<List<ForumPost>> searchPosts(String query) {
    return _postsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      final allPosts = snapshot.docs.map((doc) {
        return ForumPost.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      // Client-side filtering (for better search, use Algolia or similar)
      return allPosts.where((post) {
        final titleMatch = post.title.toLowerCase().contains(query.toLowerCase());
        final contentMatch = post.content.toLowerCase().contains(query.toLowerCase());
        final tagMatch = post.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
        return titleMatch || contentMatch || tagMatch;
      }).toList();
    });
  }

  Future<List<ForumPost>> getUserPosts(String userId) async {
    final snapshot = await _postsCollection
        .where('authorId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return ForumPost.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  List<String> getForumCategories() {
    return [
      'All',
      'Crop Advice',
      'Pest Control',
      'Soil Health',
      'Irrigation',
      'Market Prices',
      'Equipment',
      'Success Stories',
      'Weather Updates',
      'Government Schemes',
      'General Discussion',
    ];
  }
}
