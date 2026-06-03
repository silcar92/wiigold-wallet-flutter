#!/usr/bin/env python3

import sys
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

if len(sys.argv) != 6:
    print('Usage:\n\tpost_rc_ready.py <version> <ios_build_number> <android_app_debug> <slack_token> <slack_release_channel_id>')
    exit(1)

version, ios_build_number, android_app_debug, slack_token, slack_release_channel_id = sys.argv[1:]

try:
    client = WebClient(token=slack_token)
    client.chat_postMessage(
        channel=slack_release_channel_id,
        text=f'*Flutter plugin {version} release candidate ready.*\n\niOS build: {ios_build_number}\n<{android_app_debug}|Android app debug>',
        icon_emoji=':flutter:'
    )
except Exception as e:
    print('Error:', str(e))
    sys.exit(1)
