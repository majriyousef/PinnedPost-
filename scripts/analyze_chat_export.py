#!/usr/bin/env python3
"""Summarize an anonymized CSV/JSONL chat export without external packages."""

from __future__ import annotations

import argparse
import csv
import json
import re
from collections import Counter
from pathlib import Path


EXPECTED = {"conversation_id", "timestamp", "sender", "message"}
DROP_PATTERNS = {
    "price": re.compile(r"\b(?:too much|expensive|cant afford|can't afford|budget)\b", re.I),
    "no_reply": re.compile(r"\b(?:no reply|no answer|ghosted)\b", re.I),
    "work_time": re.compile(r"\b(?:work|busy|later|tomorrow)\b", re.I),
    "stop": re.compile(r"\b(?:stop|not interested|dont want|don't want|no thanks)\b", re.I),
}


def read_rows(path: Path) -> list[dict[str, str]]:
    if path.suffix.lower() == ".jsonl":
        return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines() if line.strip()]
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("path", type=Path, help="Anonymized .csv or .jsonl export")
    args = parser.parse_args()

    rows = read_rows(args.path)
    if not rows:
        raise SystemExit("No rows found")
    missing = EXPECTED - set(rows[0])
    if missing:
        raise SystemExit(f"Missing columns: {', '.join(sorted(missing))}")

    conversations = {row["conversation_id"] for row in rows}
    senders = Counter(row["sender"].strip().lower() for row in rows)
    signals = Counter()
    for row in rows:
        text = row["message"].lower()
        for label, pattern in DROP_PATTERNS.items():
            if pattern.search(text):
                signals[label] += 1

    print(json.dumps({
        "rows": len(rows),
        "conversations": len(conversations),
        "senders": senders,
        "possible_drop_signals": signals,
        "warning": "Keyword signals require manual backread; they are not final classifications.",
    }, indent=2, default=dict))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
