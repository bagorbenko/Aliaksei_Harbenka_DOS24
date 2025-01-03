USE lab_tests;

SELECT a.an_name, a.an_price
FROM Analysis a
JOIN Orders o ON a.an_id = o.ord_an
WHERE o.ord_datetime BETWEEN '2024-04-24' AND '2024-05-31';
