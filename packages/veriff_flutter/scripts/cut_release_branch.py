#!/usr/bin/env python3

import os
import re
import sys
import json
import shutil
import subprocess
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

if len(sys.argv) != 4:
    print('Usage:\n\tcut_release_branch.py <version> <slack_token> <slack_release_channel_id>')
    exit(1)

version, slack_token, slack_release_channel_id = sys.argv[1:]

def increase_minor_version(version):
    version_parts = version.split('.')
    if len(version_parts) != 3:
        return version

    minor_number = int(version_parts[1])
    minor_number += 1
    version_parts[1] = str(minor_number)

    return '.'.join(version_parts)

def update_pubspecyaml_version(new_version):
    filename = 'pubspec.yaml'
    with open(filename, 'r') as file:
        lines = file.readlines()

    for i, line in enumerate(lines):
        if line.startswith('version: '):
            lines[i] = f'version: {new_version}\n'
            break

    with open(filename, 'w') as file:
        file.writelines(lines)

def extract_version(file_path, version_pattern):
    with open(file_path, 'r') as file:
        file_content = file.read()

    # Search for the version using regex
    match = re.search(version_pattern, file_content)

    # Extract and print the version if found
    if match:
        return match.group(1)
    else:
        return None

def update_changelog(flutter_version):
    ios_version = extract_version('ios/veriff_flutter.podspec', r"s\.dependency\s+'VeriffSDK',\s*'([^']+)'\s*")
    android_version = extract_version('android/build.gradle', r"com\.veriff:veriff-library:([\d.]+)")

    if ios_version and android_version:
        new_changelog = f"## {flutter_version}\n\n" \
            f"* Migrated Android SDK to version {android_version}\n" \
            f"* Migrated iOS SDK to version {ios_version}\n\n"
        with open('CHANGELOG.md', 'r') as file:
            existing_changelog = file.read()
        updated_changelog = new_changelog + existing_changelog
        with open('CHANGELOG.md', 'w') as file:
            file.write(updated_changelog)
    elif ios_version:
        print("Can't update changelog, failed to get android version")
    elif android_version:
        print("Can't update changelog, failed to get ios version")
    else:
        print("Can't update changelog, failed to get ios and android versions")

try:
    # Get current version and compute the new one
    new_version = increase_minor_version(version)

    # Create new release branch
    new_branch = f'release/{new_version}'
    subprocess.run(['git', 'checkout', '-b', new_branch])

    # Get commits list
    commit_range = f'{version}..{new_branch}'
    commits = subprocess.run(['git', 'log', '--pretty=format:%h %s', '--no-merges', commit_range], capture_output=True, text=True).stdout

    # Post release branch cut message to #sdk-release channel
    client = WebClient(token=slack_token)
    client.chat_postMessage(
        channel=slack_release_channel_id,
        text=f'*Flutter plugin {new_version} release branch cut, commits:*\n\n```{commits}```',
        icon_emoji=':flutter:'
    )

    # Update flutter wrapper version in pubspec.yaml
    update_pubspecyaml_version(new_version)

    # Update CHANGELOG.md
    update_changelog(new_version)

    # Download flutter
    subprocess.run(['curl', '-o', 'flutter_sdk.zip', 'https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_2.5.3-stable.zip'])
    subprocess.run(['unzip', 'flutter_sdk.zip'])

    # Update example app with new flutter wrapper version
    current_dir = os.getcwd()
    flutter_path = os.path.join(current_dir, 'flutter', 'bin', 'flutter')
    subprocess.run([flutter_path, 'pub', 'get'], cwd='example')

    # Remove flutter
    os.remove('flutter_sdk.zip')
    shutil.rmtree('flutter')

    # Push changes to release branch
    subprocess.run(['git', 'add', '*'])
    subprocess.run(['git', 'commit', '-m', f'build: set version to {new_version}'])
    push_result = subprocess.run(['git', 'push', 'origin', new_branch], capture_output=True, text=True)
    print('stdout: ', push_result.stdout)
    print('stderr: ', push_result.stderr)
    sys.exit(push_result.returncode)
except Exception as e:
    print('Error:', str(e))
    sys.exit(1)
