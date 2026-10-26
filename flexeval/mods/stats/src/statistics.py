from math import isfinite
from statistics import mean, stdev


def numeric_summary(values):
    # Les réponses FlexEval sont enregistrées comme des chaînes.
    numbers = [
        float(value)
        for value in values
        if value is not None and value != ""
    ]

    if not all(isfinite(value) for value in numbers):
        raise ValueError("Une note contient une valeur non finie.")

    return {
        "n": len(numbers),
        "mean": mean(numbers) if numbers else None,
        "std": stdev(numbers) if len(numbers) >= 2 else None,
    }

def control_summary(rows, expected):
    """One success per complete response; missing answers are not failures."""

    participants = {}

    for row in rows:
        user = row["user_pseudo"]
        counts = participants.setdefault(user, {"n": 0, "correct": 0, "missing": 0})

        if any(row.get(column) in (None, "") for column in expected):
            counts["missing"] += 1
            continue

        counts["n"] += 1
        counts["correct"] += int(all(str(row[column]) == str(value)
                                     for column, value in expected.items()))
    for counts in participants.values():
        counts["rate"] = counts["correct"] / counts["n"] if counts["n"] else None

    return {"participants": participants}
