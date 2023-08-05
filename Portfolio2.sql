SELECT *
FROM Worksheet$




--Total of Broadband Subscription Per year

SELECT Year, SUM([Fixed broadband subscriptions]) AS TotalBroadbandSubscription
FROM Worksheet$ 
JOIN Portfolio..S
WHERE Code is not null
or [Fixed broadband subscriptions] is not null
GROUP BY Year
ORDER BY 1,2

--Total subscriptions per countries

SELECT Entity, SUM([Fixed broadband subscriptions]) AS 'Total Broadband Subscriptions'
FROM Worksheet$
WHERE Code is not null
or [Fixed broadband subscriptions] is not null
GROUP BY Entity
ORDER BY 1,2 ASC


