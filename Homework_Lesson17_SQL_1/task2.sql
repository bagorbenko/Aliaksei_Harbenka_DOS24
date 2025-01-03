SELECT s.student_name, c.course_name
FROM Students s
LEFT JOIN Courses c ON s.student_id = c.student_id;
