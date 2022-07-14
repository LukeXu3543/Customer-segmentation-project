Q1. Highest-spending
/* First find out the segment that has the most people with high spending score.
The result indicates that segment C has most high-spending customers, indicating that
it may be a good market to target.*/
SELECT segmentation, COUNT(spending_score) AS high_spending FROM customers
WHERE spending_score = 'High'
GROUP BY segmentation
ORDER BY high_spending DESC

Q2. Gender-spending
/*To explore which gender is more interested in the company's product */
SELECT gender, COUNT(spending_score) AS gender_spending FROM customers
WHERE spending_score = 'High'
GROUP BY gender 
ORDER BY gender_spending DESC

Q3. Marital-status
/* The result shows that ALL customers who have a high spending score
are married, indicating a very strong relationship between customers' interests in
automobile and their marital status*/
SELECT ever_married, COUNT(spending_score) AS marriage_spending FROM customers
WHERE spending_score = 'High' AND ever_married IS NOT NULL
GROUP BY ever_married 
ORDER BY marriage_spending DESC

Q4. Age spending
/* To find a relationship between customers' age and their spending score, I categorized
people into 3 groups based on their ages. The result indicates that older people
tend to have higher spending score on automobile, which is a bit counter-intuitive.*/

SELECT (CASE WHEN age BETWEEN 0 AND 30 THEN 'young'
            WHEN age BETWEEN 30 AND 60 THEN 'middle-aged'
		    WHEN age IS NULL THEN 'age-unknown'
			ELSE 'elder'
	   END) AS age_group
,COUNT(spending_score) AS age_spending FROM customers
WHERE spending_score = 'High'
GROUP BY age_group 
ORDER BY age_spending DESC


Q5. Graduate or not
/* The result indicates that customers who are graduates are more attracted
by automobile. */
SELECT graduated, COUNT(spending_score) AS graduate_spending FROM customers
WHERE spending_score = 'High' AND graduated IS NOT NULL
GROUP BY graduated 
ORDER BY graduate_spending DESC


Q6. Professions
/* The result is very reasonable. Well-paid professions such as executive and lawyer
are more likely to afford automobile. However, it is interesting that the top three
professions are far more likely to have high spending scores than the rest professions. 
It can be inferred that these three jobs require more long-distance travelling.*/

SELECT profession, COUNT(spending_score) AS profession_spending FROM customers
WHERE spending_score = 'High' AND profession IS NOT NULL
GROUP BY profession 
ORDER BY profession_spending DESC


Q7. Work experience
/* For numeric values such as work experience, it is better to use an aggregate function
to find the pattern. The result indicates that on average, as customers' work experience increases,
their spending score decreases. This is reasonable as people with longer work years are
more likely to have possessed automobile and thus not interested in buying a new one.*/

SELECT spending_score, ROUND(AVG(work_experience),2) AS average_experience_year
FROM customers
GROUP BY spending_score
ORDER BY average_experience_year DESC


Q8. Family Size
/* This result is reasonable as well. Small-to-medium size family have higher spending
score on automobile. When a family is too large(over 4 people) or too small (1 person),
it is far less likely to be interested in buying an automobile*/

SELECT spending_score, ROUND(AVG(family_size),2) AS average_size
FROM customers
GROUP BY spending_score
ORDER BY average_size DESC


Q9. Best segment vs Worst segment --- gender
/* As the result indicates, the worst segment, D, has a higher male percentage.
The rest 3 segments are very similar considering their gender composition. This 
result fails to explain why D has the lowest spending score since previous result
indicates that male customers tend to have higher spending score*/

SELECT segmentation, 
100 * SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END)/COUNt(*) AS Male_percent,
100 * SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END)/COUNT(*) AS Female_percent
FROM customers
GROUP BY segmentation
ORDER BY male_percent DESC


Q10. Best vs Worst segment ------- marital status
/*This result indicates a strong relationship between customers' spending score and their marital 
status. Segment C's high spending score can be perfectly explained by the segment's marriage rate.
Comparatively, segment D's low spending score can be largely attributed to its low marriage rate.*/

SELECT segmentation, 
ROUND(1.0 * SUM(CASE WHEN ever_married = 'true' THEN 1 ELSE 0 END)/COUNt(*),2)AS married_percent,
ROUND(1.0 * SUM(CASE WHEN ever_married = 'false' THEN 1 ELSE 0 END)/COUNT(*),2) AS unmarried_percent
FROM customers
GROUP BY segmentation
ORDER BY married_percent DESC



Q11. Best vs Worst segment ------- graduate
/* The result is also aligned with previous assumption about customers' graduation condition.
Segment C's high spending score can be largely attributed by its high graduate rate, and the lowest
graduate rate of segment D contributes to its low spending score.*/

SELECT segmentation, 
ROUND(1.0 * SUM(CASE WHEN graduated = 'true' THEN 1 ELSE 0 END)/COUNt(*),2)AS graduate_percent,
ROUND(1.0 * SUM(CASE WHEN graduated = 'false' THEN 1 ELSE 0 END)/COUNT(*),2) AS ungraduate_percent
FROM customers
GROUP BY segmentation
ORDER BY graduate_percent DESC



Q12. Best vs Worst segment ------ professions
/* The result is generally aligned with previous assumption. As shown by the result, although segment C
does not have the most executives and lawyers, it has the most artists. The number of artists in segment
C is significantly higher than those of other segments, making up for its lag in the 
numbers of the other two professions. Segment D has fewest numbers in all three professions,
which explains its low spending score.*/


(SELECT segmentation, profession, COUNT(*) FROM customers
WHERE profession = 'Executive'
GROUP BY segmentation, profession
ORDER BY COUNT(*) DESC)

UNION ALL

(SELECT segmentation, profession, COUNT(*) FROM customers
WHERE profession = 'Lawyer'
GROUP BY segmentation, profession
ORDER BY COUNT(*) DESC)

UNION ALL 

(SELECT segmentation, profession, COUNT(*) FROM customers
WHERE profession = 'Artist'
GROUP BY segmentation, profession
ORDER BY COUNT(*) DESC)




Q13. Best vs Worst ------ numeric
/* Finally, let's compare the average values of four segments' numeric data. As indicated by the result,
Segment D has the lowest average age, the highest average work experience, and the highest average family size. 
Comparatively, segment C has the highest average age, the lowest average work experience, and a medium average family
size. All these traits match the assumption made in previous analysis. */

SELECT tbl1.segmentation, average_age, average_exp, average_size FROM

(SELECT segmentation, ROUND(AVG(age),0) AS average_age FROM customers
GROUP BY segmentation
ORDER BY average_age DESC) tbl1

JOIN

(SELECT segmentation, ROUND(AVG(work_experience),2) AS average_exp FROM customers
GROUP BY segmentation
ORDER BY average_exp DESC) tbl2

ON tbl1.segmentation = tbl2.segmentation

JOIN

(SELECT segmentation, ROUND(AVG(family_size),2) AS average_size FROM customers
GROUP BY segmentation
ORDER BY average_size DESC) tbl3

ON tbl2.segmentation = tbl3.segmentation
