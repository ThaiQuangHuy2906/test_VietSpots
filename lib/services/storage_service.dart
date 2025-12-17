import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vietspots/services/auth_service.dart';

/// Service to upload images to Supabase Storage
class StorageService {
  final SupabaseClient? _client;

  /// Optional client can be provided for testing. If null, the live
  /// `Supabase.instance.client` is used at call time.
  StorageService([this._client]);

  /// Upload bytes to bucket `images` under `reviews/` folder and
  /// return the public URL (or null on failure).
  Future<String?> uploadReviewImageFromBytes(
    Uint8List bytes,
    String extension,
  ) async {
    final id = const Uuid().v4();
    final path = 'reviews/$id.$extension';

    try {
      // Upload as binary. If this API changes, adjust accordingly.
      final client = _client ?? Supabase.instance.client;
      await client.storage.from('images').uploadBinary(path, bytes);

      // Supabase public storage object URL
      final publicUrl =
          '${SupabaseConfig.supabaseUrl}/storage/v1/object/public/images/$path';
      return publicUrl;
    } catch (e) {
      // Could log error; return null to indicate failure
      debugPrint('Storage upload failed: $e');
      return null;
    }
  }
}
