/*
Syntax: MySQL

Data Structure: 
{"peas": ["st_id", "timest", "correct", "subject"],
"studs": ["st_id", "test_grp"]
"checks": ["st_id", "sale_time", "subject", "money"]}

Metrics List:
ARPU
ARPAU 
CR
CR из активных
CR из активных по математике
*/

select
	s.test_grp,
	sum(c.money) / count(distinct s.st_id) as ARPU,
	sum(c.money) / count(distinct p.st_id) as ARPAU,
	count(distinct c.st_id) / count(distinct s.st_id) as CR,
	count(distinct c.st_id) / count(distinct p.st_id) as CR_active,
	count(distinct case when c.subject = 'math' then c.st_id end) / count(distinct case when p.subject = 'math' then p.st_id end) as CR_active_math
from studs s
left join (
			select
				s1.st_id,
				s2.subject
			from peas s1
			left join peas s2 on s1.st_id = s2.st_id and s2.subject = 'math'
			where s1.timest between @Дата_начала_эксперимента and @Дата_окончания_эксперимента 
			  and s2.timest between @Дата_начала_эксперимента and @Дата_окончания_эксперимента
			group by s1.st_id, s2.subject
		  ) p on s.st_id = p.st_id
left join checks c on c.st_id = s.st_id	and c.sale_time between @Дата_начала_эксперимента and @Дата_окончания_эксперимента
group by s.test_grp