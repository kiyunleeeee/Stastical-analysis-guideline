# Stastical-analysis-guideline
Program guiding basic statistical analysis

* The program has been used in biotech/neuroscience/pharamaceutical field.
* The program contains statistical models, normal distribution tests, data transformation, hypothesis tests, post-hoc tests, etc.
* Please refer to the example dataset "stastical analysis example.txt". This program is modified and adapted to the dataset.




## Example
### Two-way ANOVA result
| | Df | Sum Sq | Mean Sq | F value | Pr(>F) | |
--- | --- | --- | --- | --- | --- | --- |
drug | 1 | 17.16 | 17.16 | 0.7735 | 0.3895700 | |
time | 1 | 434.85 | 434.85 | 19.6062 | 0.0002588 | *** |
drug:time | 1 | 187.55 | 187.55 | 8.4564 | 0.0086976 | ** |
Residuals | 20 | 443.58 | 22.18 |  |  |  |



### Tukey's honest significance difference test
| | diff | lwr | upr |  p adj |
--- | --- | --- | --- | --- |
d2:t1-d1:t1 | 7.281944 | -0.3283835 | 14.892272 | 0.0638218 |
d1:t2-d1:t1 | 14.104167 | 6.4938387 | 21.714495 | 0.0002428 |
d2:t2-d1:t1 | 10.204167 | 2.5938387 | 17.814495 | 0.0063236 |
d1:t2-d2:t1 | 6.822222 | -0.7881057 | 14.432550 | 0.0889307 |
d2:t2-d2:t1 | 2.922222 | -4.6881057 | 10.532550 | 0.7084004 |
d2:t2-d1:t2 | -3.900000 | -11.5103280 | 3.710328 | 0.4936741 |
