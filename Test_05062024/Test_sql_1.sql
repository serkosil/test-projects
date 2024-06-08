-- 1. SQL-запрос для показа выкупа по сочетанию country+os за 01.04.2020:

SELECT country,
       os,
       COUNT(DISTINCT e.auction_id) / COUNT(DISTINCT r.auction_id) AS buyout
FROM Requests r
JOIN EVENTS e ON r.auction_id = e.auction_id
WHERE DATE(r.event_time) = '2020-04-01'
      AND DATE(e.event_time) = '2020-04-01'
GROUP BY country,
         os;

-- 2. SQL-запрос для показа процента неуникальных кликов для каждого из источников за 01.04.2020:

WITH UniqueClicks AS
    (SELECT DISTINCT auction_id,
                     url
     FROM EVENTS
     WHERE event_type = 'click' )
SELECT SOURCE,
       COUNT(*) * 100.0 /
    (SELECT COUNT(*)
     FROM EVENTS
     WHERE event_type = 'click') AS not_unique
FROM EVENTS
WHERE event_type = 'click'
     AND (auction_id,
          url) NOT IN
         (SELECT *
          FROM UniqueClicks)
     AND DATE(event_time) = '2020-04-01'
GROUP BY SOURCE;

-- 3. SQL-запрос для вывода auction_id, времени в таблице “Requests”, времени показа и времени первого клика этого аукциона:

SELECT r.auction_id,
       r.event_time AS request_time,
       e_show.event_time AS show_time,
       MIN(e_click.event_time) AS first_click_time
FROM Requests r
LEFT JOIN EVENTS e_show ON r.auction_id = e_show.auction_id
AND e_show.event_type = 'show'
LEFT JOIN EVENTS e_click ON r.auction_id = e_click.auction_id
AND e_click.event_type = 'click'
GROUP BY r.auction_id,
         request_time,
         show_time;