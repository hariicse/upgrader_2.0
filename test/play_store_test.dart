/*
 * Copyright (c) 2019 Larry Aasen. All rights reserved.
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:upgrader/upgrader.dart';

import 'mock_play_store_client.dart';

void main() {
  var androidId = 'com.kotoko.express';
  test('testing PlayStoreSearchAPI properties', () async {
    final playStore = PlayStroeSearchApi();
    expect(playStore.debugEnabled, equals(false));
    playStore.debugEnabled = true;
    expect(playStore.debugEnabled, equals(true));
    expect(playStore.playStorePrefixURL.length, greaterThan(0));

    expect(
        playStore.lookupURLById(androidId),
        equals(Uri.https(
            'play.google.com', '/store/apps/details', {'id': androidId})));
  });

  test('testing lookupById', () async {
    final client = MockPlayStoreSearchClient.setupMockClient();
    final playStore = PlayStroeSearchApi();
    playStore.client = client;

    final response = await playStore.lookupById(androidId);

    final results = response!;
    expect(results, isNotNull);

    expect(PlayStoreResults.releaseNotes(response),
        'Bug fixes and performance enhancements');
    expect(
        PlayStoreResults.trackViewUrl(androidId),
        Uri.https('play.google.com', '/store/apps/details', {'id': androidId})
            .toString());
    expect(PlayStoreResults.version(response), '2.1.6');
  }, skip: false);
}
