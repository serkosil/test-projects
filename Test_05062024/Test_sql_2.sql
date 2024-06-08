-- На Листах 2 и 3 файл CSV есть таблицы с логами событий. Нужно сравнить их между собой и найти события, которые есть в одной таблице, но нет в другой. Время (unixtime), при этом может быть разным для одного и того же события. После нахождения дополнительно описать способ, который был использован.

-- Запросы SQL
-- Создание временной таблицы с различиями между листами 2 и 3:
"CREATE TEMPORARY TABLE events_diff AS
SELECT * FROM 
(
    SELECT event_id, event_name, event_time
    FROM Sheet2
    EXCEPT
    SELECT event_id, event_name, event_time
    FROM Sheet3
) AS events_diff

UNION ALL

SELECT * FROM 
(
    SELECT event_id, event_name, event_time
    FROM Sheet3
    EXCEPT
    SELECT event_id, event_name, event_time
    FROM Sheet2
) AS events_diff;"

-- Создание нового листа со сводной таблицей:
"CREATE TABLE SummarySheet AS
SELECT * FROM events_diff;"

-- Объяснение:
-- В этом запросе я создаю временную таблицу 'events_diff', куда сначала выбираю события, которые есть в таблице с логами на листе 2, но отсутствуют на листе 3, затем наоборот - выбираю события на листе 3, которые отсутствуют на листе 2. Затем эти различия добавляю в новый лист SummarySheet как сводную таблицу.