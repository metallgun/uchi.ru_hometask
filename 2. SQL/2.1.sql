/*
Syntax: MySQL
Data Structure: {"peas": ["st_id", "timest", "correct", "subject"]}
*/

/*
1. Подготовим данные для анализа. 
Соберем одну таблицу при помощи двух таблиц peas: слева останется таблица с ответами пользователя, которые были верными.
Справа появятся данные об ответах при следующем условии: ответы были даны в течение часа после ответа из левой части, ответы были верными.
*/
with tab1 as 
(
	select p1.*, p2.timest as timest_from_p2 from peas p1
	join peas p2 on p1.st_id = p2.st_id
	 and p2.timest between p1.timest and date_add(p1.timest, interval 1 hour)
	 and extract(year_month from ps1.timest) = 202003
	 and p1.correct = True
	 and p2.correct = True
)

/*2. Посчитаем количество ответов из правой части и выберем тех студентов, которые получили более 20 ответов.*/
select 
	st_id,
	count(timest_from_p2) as tasks_completed
group by st_id having count(timest_from_p2) >= 20
from tab1
