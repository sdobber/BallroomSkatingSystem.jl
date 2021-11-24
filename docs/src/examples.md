```@meta
CurrentModule = BallroomSkatingSystem
```

# Examples

## Single Dances

Following [Wikipedia](https://en.wikipedia.org/wiki/Skating_system), we can obtain places for the following results after judging:

### Results with a Clear Majority for Each Place

With judges as A,...,E and competitors 11, 12 and 13, we have the following places:

| Competitor | A | B | C | D | E |
| ---------- | --- | --- | --- | --- | --- |
| 11         | 1 | 1 | 2 | 1 | 2 |
| 12         | 2 | 2 | 1 | 3 | 1 |
| 13         | 3 | 3 | 3 | 2 | 3 |

We create a DataFrame with these results
```@example skating_single
using BallroomSkatingSystem # hide
results = DataFrame(Number = [11, 12, 13],
        JudgeA = [1, 2, 3],
        JudgeB = [1, 2, 3],
        JudgeC = [2, 1, 3],
        JudgeD = [1, 3, 2],
        JudgeE = [2, 1, 3])
nothing # hide
```
and obtain the final results by
```@example skating_single
calculation, places = skating_single_dance(results)
nothing # hide
```

The output contains the full calculation as a dataframe
```@example skating_single
calculation
```
as well as just the places:
```@example skating_single
places
```

### No Majority

With the following judgements 

| Competitor | A | B | C | D | E |
| ---------- | --- | --- | --- | --- | --- |
| 11         | 1 | 1 | 2 | 2 | 3 |
| 12         | 2 | 2 | 1 | 1 | 2 |
| 13         | 3 | 3 | 3 | 3 | 1 |

we obtain
```@example skating_single
results = DataFrame(Number = [11, 12, 13],
        JudgeA = [1, 2, 3],
        JudgeB = [1, 2, 3],
        JudgeC = [2, 1, 3],
        JudgeD = [2, 1, 3],
        JudgeE = [3, 2, 1])
calculation, places = skating_single_dance(results)
calculation
```

### Shared Places and Wins with 2nd Place

| Competitor | A | B | C | D | E |
| ---------- | --- | --- | --- | --- | --- |
| 11         | 1 | 1 | 3 | 3 | 4 |
| 12         | 2 | 2 | 2 | 2 | 2 |
| 13         | 3 | 3 | 4 | 1 | 1 | 
| 14         | 4 | 4 | 1 | 4 | 3 | 

gives

```@example skating_single
results = DataFrame(Number = [11, 12, 13, 14],
        JudgeA = [1, 2, 3, 4],
        JudgeB = [1, 2, 3, 4],
        JudgeC = [3, 2, 4, 1],
        JudgeD = [3, 2, 1, 4],
        JudgeE = [4, 2, 1, 3])
calculation, places = skating_single_dance(results)
calculation
```

## Multiple Dances

### 1st Example

The following examples are from the [TSO Homepage](https://tso.turnierprotokoll.de/tso_anh2.htm) (in German).

Assume we have a tournament with the following dances

* Waltz (abbreviated W)
* Tango (T)
* Viennese Waltz (V)
* Slowfox (S)
* Quickstep (Q)

and the following individual placements from the judges:

| Nr. | W-A | W-B | W-C | W-D | W-E | T-A | T-B | T-C | T-D | T-E | V-A | V-B | V-C | V-D | V-E | S-A | S-B | S-C | S-D | S-E | Q-A | Q-B | Q-C | Q-D | Q-E |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 25  | 1   | 1   | 2   | 5   | 3   | 1   | 2   | 2   | 3   | 4   | 1   | 1   | 2   | 2   | 3   | 2   | 2   | 5   | 1   | 5   | 2   | 6   | 2   | 6   | 1   |
| 35  | 2   | 2   | 5   | 2   | 5   | 5   | 3   | 1   | 2   | 2   | 3   | 2   | 1   | 1   | 2   | 1   | 1   | 2   | 5   | 2   | 1   | 5   | 1   | 5   | 2   |
| 45  | 4   | 5   | 3   | 1   | 1   | 3   | 1   | 3   | 1   | 3   | 5   | 3   | 3   | 6   | 1   | 5   | 6   | 3   | 2   | 3   | 3   | 2   | 4   | 2   | 4   |
| 55  | 3   | 3   | 6   | 3   | 6   | 4   | 4   | 4   | 4   | 1   | 2   | 6   | 6   | 3   | 4   | 3   | 3   | 1   | 3   | 6   | 5   | 1   | 5   | 1   | 3   |
| 65  | 6   | 6   | 1   | 4   | 4   | 2   | 5   | 5   | 5   | 5   | 4   | 4   | 5   | 5   | 6   | 6   | 4   | 6   | 6   | 4   | 4   | 4   | 6   | 3   | 6   |
| 75  | 5   | 4   | 4   | 6   | 2   | 6   | 6   | 6   | 6   | 6   | 6   | 5   | 4   | 4   | 5   | 4   | 5   | 4   | 4   | 1   | 6   | 3   | 3   | 4   | 5   |

We set up the results as follows:
```@example skating_combined
using BallroomSkatingSystem # hide
dances = ["Waltz", "Tango", "Viennese Waltz", "Slowfox", "Quickstep"]

resultsW = DataFrame(Number = [25, 35, 45, 55, 65, 75],
    JudgeA = [1, 2, 4, 3, 6, 5],
    JudgeB = [1, 2, 5, 3, 6, 4],
    JudgeC = [2, 5, 3, 6, 1, 4],
    JudgeD = [5, 2, 1, 3, 4, 6],
    JudgeE = [3, 5, 1, 6, 4, 2])

resultsT = DataFrame(Number = [25, 35, 45, 55, 65, 75],
    JudgeA = [1, 5, 3, 4, 2, 6],
    JudgeB = [2, 3, 1, 4, 5, 6],
    JudgeC = [2, 1, 3, 4, 5, 6],
    JudgeD = [3, 2, 1, 4, 5, 6],
    JudgeE = [4, 2, 3, 1, 5, 6])

resultsV = DataFrame(Number = [25, 35, 45, 55, 65, 75],
    JudgeA = [1, 3, 5, 2, 4, 6],
    JudgeB = [1, 2, 3, 6, 4, 5],
    JudgeC = [2, 1, 3, 6, 5, 4],
    JudgeD = [2, 1, 6, 3, 5, 4],
    JudgeE = [3, 2, 1, 4, 6, 5])

resultsS = DataFrame(Number = [25, 35, 45, 55, 65, 75],
    JudgeA = [2, 1, 5, 3, 6, 4],
    JudgeB = [2, 1, 6, 3, 4, 5],
    JudgeC = [5, 2, 3, 1, 6, 4],
    JudgeD = [1, 5, 2, 3, 6, 4],
    JudgeE = [5, 2, 3, 6, 4, 1])

resultsQ = DataFrame(Number = [25, 35, 45, 55, 65, 75],
    JudgeA = [2, 1, 3, 5, 4, 6],
    JudgeB = [6, 5, 2, 1, 4, 3],
    JudgeC = [2, 1, 4, 5, 6, 3],
    JudgeD = [6, 5, 2, 1, 3, 4],
    JudgeE = [1, 2, 4, 3, 6, 5])

results = [resultsW, resultsT, resultsV, resultsS, resultsQ]
nothing # hide
```

We calculate the final result by
```@example skating_combined
places_text, rule10_11, reports, places = skating_combined(dances, results)
nothing # hide
```

We can see the final placement in the `places` DataFrame:
```@example skating_combined
places
```

The calculation of the sum of the individual places can be found in the first return value
```@example skating_combined
places_text
```

In this example, Rule 11 needed to be applied. The separate calculations are reported for Rule 10 in
```@example skating_combined
rule10_11[1]
```
and for Rule 11 in 
```@example skating_combined
rule10_11[2]
```

Finally, `reports` contains the calculations for the individual dances (similar to the first section).


### 2nd Example

Consider the following results

| Nr. | W-A | W-B | W-C | W-D | W-E | T-A | T-B | T-C | T-D | T-E | V-A | V-B | V-C | V-D | V-E | S-A | S-B | S-C | S-D | S-E | Q-A | Q-B | Q-C | Q-D | Q-E |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 27  | 2 | 2 | 5 | 2 | 5 | 1 | 2 | 2 | 3 | 4 | 1 | 1 | 1 | 1 | 1 | 3 | 3 | 1 | 3 | 6 | 2 | 6 | 2 | 6 | 1 |
| 37  | 3 | 3 | 6 | 3 | 6 | 3 | 1 | 3 | 1 | 3 | 2 | 3 | 4 | 5 | 6 | 1 | 1 | 2 | 5 | 2 | 4 | 4 | 6 | 3 | 6 |
| 47  | 4 | 5 | 3 | 1 | 1 | 2 | 5 | 5 | 5 | 5 | 3 | 4 | 5 | 6 | 2 | 4 | 5 | 4 | 4 | 1 | 1 | 5 | 1 | 5 | 2 |
| 57  | 1 | 1 | 2 | 5 | 3 | 4 | 4 | 4 | 4 | 1 | 4 | 5 | 6 | 2 | 3 | 5 | 6 | 3 | 2 | 3 | 6 | 3 | 3 | 4 | 5 |
| 67  | 6 | 6 | 1 | 4 | 4 | 6 | 6 | 6 | 6 | 6 | 5 | 2 | 2 | 3 | 4 | 2 | 2 | 5 | 1 | 5 | 5 | 1 | 5 | 1 | 4 |
| 77  | 5 | 4 | 4 | 6 | 2 | 5 | 3 | 1 | 2 | 2 | 6 | 6 | 3 | 4 | 5 | 6 | 4 | 6 | 6 | 4 | 3 | 2 | 4 | 2 | 3 |

We set up and run the calculations:
```@example skating_combined
dances = ["Waltz", "Tango", "Viennese Waltz", "Slowfox", "Quickstep"]

resultsW = DataFrame(Number = [27, 37, 47, 57, 67, 77],
        JudgeA = [2, 3, 4, 1, 6, 5],
        JudgeB = [2, 3, 5, 1, 6, 4],
        JudgeC = [5, 6, 3, 2, 1, 4],
        JudgeD = [2, 3, 1, 5, 4, 6],
        JudgeE = [5, 6, 1, 3, 4, 2])

    resultsT = DataFrame(Number = [27, 37, 47, 57, 67, 77],
        JudgeA = [1, 3, 2, 4, 6, 5],
        JudgeB = [2, 1, 5, 4, 6, 3],
        JudgeC = [2, 3, 5, 4, 6, 1],
        JudgeD = [3, 1, 5, 4, 6, 2],
        JudgeE = [4, 3, 5, 1, 6, 2])

    resultsV = DataFrame(Number = [27, 37, 47, 57, 67, 77],
        JudgeA = [1, 2, 3, 4, 5, 6],
        JudgeB = [1, 3, 4, 5, 2, 6],
        JudgeC = [1, 4, 5, 6, 2, 3],
        JudgeD = [1, 5, 6, 2, 3, 4],
        JudgeE = [1, 6, 2, 3, 4, 5])

    resultsS = DataFrame(Number = [27, 37, 47, 57, 67, 77],
        JudgeA = [3, 1, 4, 5, 2, 6],
        JudgeB = [3, 1, 5, 6, 2, 4],
        JudgeC = [1, 2, 4, 3, 5, 6],
        JudgeD = [3, 5, 4, 2, 1, 6],
        JudgeE = [6, 2, 1, 3, 5, 4])

    resultsQ = DataFrame(Number = [27, 37, 47, 57, 67, 77],
        JudgeA = [2, 4, 1, 6, 5, 3],
        JudgeB = [6, 4, 5, 3, 1, 2],
        JudgeC = [2, 6, 1, 3, 5, 4],
        JudgeD = [6, 3, 5, 4, 1, 2],
        JudgeE = [1, 6, 2, 5, 4, 3])

results = [resultsW, resultsT, resultsV, resultsS, resultsQ]
places_text, rule10_11, reports, places = skating_combined(dances, results)
nothing # hide
```

We obtain the following final places
```@example skating_combined
places_text
```

Calculations for Rule 10:
```@example skating_combined
rule10_11[1]
```
...and for Rule 11:
```@example skating_combined
rule10_11[2]
```