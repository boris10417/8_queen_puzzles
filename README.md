# 8_queen_puzzles

solve problem in dart. And make UI in flutter to represent.

# problem

find all n*n plates that can place n queens. Queen should not conlict with each other.

# eight-queens-puzzle solvement:

## description:

After thinking few days.I focus on point 1:"Each rows has one queen and only one queen".

By this point 1,I had an idea.


1. In row 0, I set a queen in available column from input plates.Then collect all possible plates.

2. pass all possible plates to next round. Set new queen in row++ and collect branch possible plates.

3. repeat until last row.You will get all possible plates. If one plate queen's amount < n,it will be abandoned.


## conclusion:

1.Since each row only set queens one time. Execution time can be saved a lot contrast to brute-force solution.

2.Once (exist queens + peace positions) < N , the branch plates cannot satisfied requirement.And will be abandoned. Execution time can be saved a little bit.

