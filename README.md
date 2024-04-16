# Lineup Optimization in the NBA

## By: Harshal Rukhaiyar and Vaughn Hajra

## Background and Data

### Relevant Literature & Techniques
- Key Article: [Elite 5-Player Lineups using Plus/Minus](https://www.degruyter.com/document/doi/10.1515/jqas-2022-0039/html)
- And LOTS of other research!

## Research Design
- Used to determine key variables for success (lineups data)
- Used to identify players with desired traits (individual data)
- Key in finding individual player replacements (individual data)
- Techniques Used:
  - Binary Decision Tree
  - DBSCAN: Clustering
  - Random Forests

## Our Scenario (Why One Team?)
- The 2022-2023 Miami Heat postseason problem: starter Tyler Herro broke his hand in the first game!
- Our job, as the “analytics team” is to:
  1. Investigate what makes a successful lineup for this specific team
  2. Determine which players would have the most success in this lineup

## Data: Sources and Theoretical Framework
### Data sources:
- NBA.com regular season lineup advanced statistics: [Link!](https://www.nba.com/stats/lineups/advanced?CF=MIN*GE*12&GroupQuantity=5&Season=2022-23&SeasonType=Playoffs&TeamID=1610612748&dir=D&slug=advanced&sort=TS_PCT)
  - 5-player Miami Heat with at least 3 games played and 12 minutes played together
- Basketball Reference: [Link](https://www.basketball-reference.com/teams/MIA/2023.html)
  - Individual player per game stats (especially interested in shooting and rebounding)
  - Individual player bio (especially interested in position, height, and weight)
  - Theoretical Framework:
    - We want data that captures a lineup’s synergy and regular season experience together
    - We also want to identify individual features that may work well in new lineups
    - We can also use postseason lineup stats to confirm our research

### Review of Methods
- First, used google sheets and googlesheets4 package for data wrangling
- Employed binary decision trees to investigate which factors led to lineup success
- Used DBSCAN, a nonparametric clustering algorithm, to find natural groupings
- Used random forests to determine individual keys to success
- Used training/test splits to validate models

## Thank You!

Sources:
- [Basketball Reference](https://www.basketball-reference.com/about/bpm2.html)
- [NBA Stats](https://www.nba.com/stats/lineups/advanced?CF=MIN*GE*12&GroupQuantity=5&Season=2022-23&SeasonType=Playoffs&TeamID=1610612748&dir=D&slug=advanced&sort=TS_PCT)
- [YouTube Video](https://www.youtube.com/watch?v=_A9Tq6mGtLI&t=179s)
- [DBSCAN Package](https://cran.r-project.org/web/packages/dbscan/readme/README.html)
- [SlidesGo for Presentation Template](https://slidesgo.com/)
