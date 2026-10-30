SELECT 
app_id,
Round(100.0 *
count(CASE when event_type = 'click' then 1 else NULL end)/
count(CASE when event_type = 'impression' then 1 else NULL end),2) as CTR_rate
from events where timestamp BETWEEN '01/01/2022' and '12/31/2022'
GROUP BY app_id;

WITH user_cnf_details AS (
SELECT 
e.user_id,
e.signup_date,
t.action_date,
datediff(t.action_date,e.signup_date),
t.signup_action
from emails e
INNER JOIN texts t 
on e.email_id = t.email_id
where datediff(t.action_date,e.signup_date) = 1 and t.signup_action = 'Confirmed')

select user_id from user_cnf_details;

## OR

SELECT DISTINCT user_id
FROM emails 
INNER JOIN texts
  ON emails.email_id = texts.email_id
WHERE texts.action_date = DATE_ADD(emails.signup_date, INTERVAL 1 DAY)  
AND texts.signup_action = 'Confirmed';

WITH employee_uni_count as 
(SELECT
e.employee_id,
COALESCE(COUNT(DISTINCT q.query_id), 0) as unique_queries
from queries q 
RIGHT JOIN employees e 
on e.employee_id = q.employee_id
 AND q.query_starttime >= '2023-07-01T00:00:00Z'
 AND q.query_starttime < '2023-10-01T00:00:00Z'
GROUP BY e.employee_id)

SELECT 
DISTINCT unique_queries,
COUNT(employee_id) as employee_count
FROM employee_uni_count
GROUP BY unique_queries
ORDER BY unique_queries ASC;