#!/usr/bin/env python3
# Copyright 2020 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

import re

ERROR_NO_ERROR = 0
ERROR_MALFORMED_MESSAGE = 1
WARNING_MISSING_DOC = 100

AVAILABLE_LABELS = [
    "Feature",
    "Refactor",
    "Optimize",
    "BugFix",
    "Infra",
    "Testing",
    "Doc",
]

TITLE_PATTERN = re.compile(r"^(\[Reland\])?\[([A-Za-z]+)\]\s*(.*)")


def IsRevertedCommit(commit_lines):
    for line in commit_lines[1:]:
        if re.match(r"This reverts commit *", line):
            return True
    return False


def IsAutoRollCommit(commit_lines):
    if re.match(r"\[AutoRoll\] Roll revisions automatically *", commit_lines[0]):
        return True
    return False


def CheckCommitMessage(message):
    error_code, error_message = ERROR_NO_ERROR, ""
    commit_lines = message.strip().split("\n")

    # skip revert commit
    if IsRevertedCommit(commit_lines):
        return error_code, error_message
    elif IsAutoRollCommit(commit_lines):
        return error_code, error_message
    else:
        if label := re.match(TITLE_PATTERN, commit_lines[0]):
            if label.groups()[1] not in AVAILABLE_LABELS:
                return (
                    ERROR_MALFORMED_MESSAGE,
                    'Invalid label "'
                    + label.groups()[1]
                    + '", should be one of '
                    + ", ".join(AVAILABLE_LABELS[0:-2])
                    + " or "
                    + AVAILABLE_LABELS[-1]
                    + ".",
                )
            need_doc = label.groups()[1] in ["Feature", "Refactor"]
        # check title
        else:
            return (
                ERROR_MALFORMED_MESSAGE,
                "Malformed title. The title needs to specify a label like '[Label]'",
            )

        summary_found = False
        doc_found = False
        for line in commit_lines[1:]:
            if not line.strip():
                continue
            elif re.match(r"(doc):\s*https?://(.*)", line):
                doc_found = True

        if need_doc and not doc_found:
            return WARNING_MISSING_DOC, "Missing doc link."
    return error_code, error_message


if __name__ == "__main__":
    import subprocess
    import sys

    message = subprocess.check_output(
        ["git", "log", "-1", "--format=%B", "HEAD"], text=True
    )
    error_code, error_message = CheckCommitMessage(message)
    if error_code == WARNING_MISSING_DOC:
        print(
            "Warning: %s A doc link is recommended for Feature/Refactor commits "
            "but is not required." % error_message,
            file=sys.stderr,
        )
        error_code = ERROR_NO_ERROR
    elif error_code:
        print(error_message, file=sys.stderr)
    sys.exit(error_code)
