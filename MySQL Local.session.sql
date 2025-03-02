SELECT a.an_name, a.an_price
FROM Analysis a
JOIN Orders o ON a.an_id = o.ord_an
WHERE o.ord_datetime BETWEEN '2020-02-05' AND DATE_ADD('2020-02-05', INTERVAL 7 DAY);
