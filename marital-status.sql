/* The result shows that ALL customers who have a high spending score
are married, indicating a very strong relationship between customers' interests in
automobile and their marital status*/
SELECT ever_married, COUNT(spending_score) AS marriage_spending FROM customers
WHERE spending_score = 'High' AND ever_married IS NOT NULL
GROUP BY ever_married 
ORDER BY marriage_spending DESC