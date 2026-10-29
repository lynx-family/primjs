#!/usr/bin/env python3
# Copyright 2026 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


HELPER = Path(__file__).with_name("commit_message_helper.py").resolve()


class CommitMessageCLITest(unittest.TestCase):
    def check_message(self, message):
        with tempfile.TemporaryDirectory() as directory:
            subprocess.run(
                ["git", "init", "--quiet", "--template=", directory],
                check=True,
                capture_output=True,
                text=True,
            )
            subprocess.run(
                [
                    "git",
                    "-c",
                    "user.name=Commit Message Test",
                    "-c",
                    "user.email=commit-message-test@example.com",
                    "-c",
                    "commit.gpgsign=false",
                    "commit",
                    "--quiet",
                    "--allow-empty",
                    "-F",
                    "-",
                ],
                input=message,
                cwd=directory,
                check=True,
                capture_output=True,
                text=True,
            )
            return subprocess.run(
                [sys.executable, "-B", str(HELPER)],
                cwd=directory,
                capture_output=True,
                text=True,
            )

    def test_missing_doc_warns_and_succeeds(self):
        for label in ("Feature", "Refactor"):
            with self.subTest(label=label):
                result = self.check_message(f"[{label}][GC] Update page handling")
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertIn("Warning: Missing doc link.", result.stderr)

    def test_documented_commits_succeed_without_warning(self):
        for label, url in (
            ("Feature", "https://example.com/design"),
            ("Refactor", "http://example.com/design"),
        ):
            with self.subTest(label=label):
                result = self.check_message(f"[{label}] Update behavior\n\ndoc: {url}")
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(result.stderr, "")

    def test_other_labels_do_not_require_docs(self):
        for label in ("BugFix", "Optimize", "Infra", "Testing", "Doc"):
            with self.subTest(label=label):
                result = self.check_message(f"[{label}] Update behavior")
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(result.stderr, "")

    def test_malformed_titles_still_fail(self):
        for message, error in (
            ("Update behavior", "Malformed title."),
            ("[Unknown] Update behavior", 'Invalid label "Unknown"'),
        ):
            with self.subTest(message=message):
                result = self.check_message(message)
                self.assertEqual(result.returncode, 1, result.stderr)
                self.assertIn(error, result.stderr)

    def test_exempt_commits_succeed_without_warning(self):
        for message in (
            'Revert "[Feature] Add behavior"\n\nThis reverts commit abc123.',
            "[AutoRoll] Roll revisions automatically",
        ):
            with self.subTest(message=message):
                result = self.check_message(message)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(result.stderr, "")


if __name__ == "__main__":
    unittest.main()
