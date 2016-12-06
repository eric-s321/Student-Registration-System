--select cl.classid, co.title, e.B#, s.firstname. e.classid
--from classes cl join courses co join enrollments e join students s
--on cl.dept_code = co.dept_code and cl.course# = co.course#
--and cl.classid=e.classid and e.B# = s.B#
--where cl.classid = 'c0001';





select cl.classid, co.title, s.B#, s.firstname 
from classes cl join courses co 
	on cl.dept_code=co.dept_code and cl.course#=co.course# 
join enrollments e
	on e.classid = cl.classid
join students s
	on s.B# = e.B#
where cl.classid='c0001'
/
