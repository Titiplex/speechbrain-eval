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