# 8_queen_puzzles

Solve problem in dart. And make UI in flutter to represent.

[Demo video on YouTube](https://youtube.com/shorts/2aUiFo_UUKQ?si=4BqURHZURoC9DwaK)

## Problem Statement

Find all n*n plates that can place n queens. Queens should not conlict with each other.

## Solution Approach

### Description:

After thinking few days.I focus on point 1:"Each rows has one queen and only one queen".

By this point 1,I designed the following algorithm:


1. For row 0, I place a queen in available column from input plates.Then collect all possible plates.

2. Pass all possible plates to next round. Place new queen in row++ and collect branch possible plates.

3. Repeat until last row.You will get all possible plates. If one plate queen's amount < n,it will be abandoned.


### conclusion:

1.Since each row only place queens one time. Execution time can be reduced a lot compared to brute-force solution.

2.Once (exist queens + peace positions) < N , the branch plates cannot satisfied requirement.And will be abandoned. Execution time can be saved a little bit.

