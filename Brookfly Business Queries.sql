#SQL Project Interesting Questions
use nimi3260school; 

#Question 1: 
#Who are the three students with the highest report card per class? 
#Since Brookfly Prive Middle School is such a prestigious school, we are specifically interested 
#in which students at Brookfly have the best grades. Knowing who our top students are will help 
#recruit them for high school and college in the future. Having it be based on class type helps 
#us acknowledge the curriculum the student is best at and where they should direct their attention 
#in the future.
set @rank = 1;
set @class = '';
set @grade = 0;

select * from (
	select classNo as Class_Number, name as Class_Name, studentid as Student_ID, firstName as 'Student_First_Name', lastName as 'Student_Last_Name', percentage as 'Grade_Percentage',
		@rank := if(@class = classNo, 
							 if(@grade = percentage, @rank, @rank+1)
								, 1) as Student_Rank,
					@class := classNo as dummyclass,
					@grade := percentage as dummygrade 
		 from (
			select c.classNo, name, s.studentId, firstName, lastName, percentage from class c
				join report r on c.classNo = r.classNo
				join student s on r.studentid = s.studentid) sq1
			order by classNo, percentage desc) sq2
	where Student_Rank <=3
    order by Class_Number, Student_Rank;   
    
#Question 2: 
#The principal wants to wish each student on his/her birthday. 
#This report allows the principal to run every morning to show the student whose birthday it is. 
#This allows each student to be recognized and admired on their special day. 
select studentid as 'Student ID', firstname as 'First Name', lastname as 'Last Name', dob as 'Birthday' from student
	where dayofmonth(dob) = dayofmonth(current_date) and monthname(dob) = monthname(current_date)
    order by lastname, firstname;  
    
#Question 3:  
#Which two days of the week are the least assignments due? 
#Since this school is so elite, a lot of work is required from our students. 
#With this being said we want to know when the least number of assignments are due during
#the school week. With this in mind, we can structure school events around the time where the 
#least assignments are due to help with our students' stress levels. 
select dayname(duedate) as 'Day of Week',  count(*) as 'Number of Assignments' from assignment a 
group by dayname(duedate) having count(*) <=(select max(top2) from 
	(select distinct count(*) as top2 from assignment
    group by dayname(duedate)
    order by count(*) asc
    limit 2) sq)    
order by count(*) asc;
 
 
 #Question 4: 
 # What are the highest scorers for each assignment?
select distinct firstName as 'First Name'
	, lastName as 'Last Name'
    , assignment.assignmentID as 'Assignment ID'
    , Description 
    , concat(max(round(score/grade.maxScore*100, 2)), '%') as 'Score'
from student
join grade on grade.studentID = student.studentID
join assignment on assignment.assignmentID = grade.assignmentID
where score/grade.maxScore > 0.9
group by description
order by firstName;

#Question 5: 
#What parents do not have bills?
select parentID as 'Parent ID'
	, concat(lastName, ', ',firstName) as 'Name'
from parent
where parentID not in (select parentID from billing);

# Using a function to grab the overall letter grade of each student
delimiter //
create function letterGetter(ppercent int) returns varchar(2)
deterministic
begin
	declare grade varchar(2);
	if ppercent >= 90 then set grade = 'A';
    elseif ppercent >= 80 and ppercent < 90 then set grade = 'B';
    elseif ppercent >= 70 and ppercent < 80 then set grade = 'C';
    elseif ppercent >= 60 and ppercent < 70 then set grade = 'D';
    elseif ppercent < 60 then set grade = 'F';
    else set grade = 'unknown';
    end if;
return(grade);
end //
delimiter ;

#Question 6: 
# What students are not passing and what are their parent's emails? Send them an email. Using a function.
select grade.studentID as 'Student ID'
	, concat(student.lastName, ', ', student.firstName) as 'Student Name'
	, round(avg(score/maxScore * 100), 2) as Grade
    , letterGetter(avg(round(score/maxScore * 100 , 2))) as 'Letter Grade'
    , parent.parentID as 'Parent ID'
    , concat(parent.lastName, ', ', parent.firstName) as 'Parent Name'
    , parent.email as 'Parent Email'
from grade
join student on student.studentID = grade.studentID
join parent on parent.parentID = student.parentID
group by grade.studentID having Grade < 70
order by grade;


#Question 7:  
#What's the total cost of faculty?
select Position 
	, concat('$', format(sum(salary) , '$')) as 'Total Cost per Position'
from staff
group by position; 

#Question 8:  
# How many calendar events did each staff member make? Who has the most?
SELECT s.staffID AS 'Staff ID', s.firstName AS 'First Name', s.lastName AS 'Last Name',
				s.position AS 'Position', COUNT( c.eventNo ) AS 'Total Events' FROM staff s
	JOIN calendar c ON s.staffID = c.staffID
    GROUP BY s.staffID
    ORDER BY COUNT( c.eventNo ) DESC;
    
#Question 9:  
#What is the average grade in each class?
SELECT cl.classNo AS 'Class Number', cl.name AS 'Class Name',
				s.firstName AS 'Instructor First Name', s.lastName AS 'Instructor Last Name',
                AVG( r.percentage ) AS 'Average Percentage' FROM class cl
	JOIN staff s ON cl.staffID = s.staffID
    JOIN report r ON cl.classNo = r.classNo
    GROUP BY cl.classNo
    ORDER BY AVG( r.percentage ) DESC;
    
#Question 10: 
#What is the letter grade for every class that each student is in? 
#Return the letter grades for each student
DROP FUNCTION letterGrade;

DELIMITER //

CREATE FUNCTION letterGrade( p_percent dec )
	RETURNS varchar(1)
    DETERMINISTIC
    BEGIN
		DECLARE percentage dec;
        DECLARE grade varchar(1);
	
		SET percentage = p_percent;
        
        CASE
			WHEN percentage >= 90 THEN SET grade = 'A';
			WHEN percentage >= 80 THEN SET grade = 'B';
			WHEN percentage >= 70 THEN SET grade = 'C';
			WHEN percentage >= 60 THEN SET grade = 'D';
			ELSE SET grade = 'F';
		END CASE;
        
        RETURN grade;
	END //

DELIMITER ;

SELECT studentID, classNo, letterGrade( percentage ) FROM report
	ORDER BY studentID; 
    
#Question 11: 
# Returns the class average of faculties hired between a period of time.
select staff.firstName as 'Name', avg(grade.score) as 'Average Score', staff.hireDate
from staff 
	left join class on staff.staffID = class.staffID
    left join assignment on class.classNo = assignment.classNo
    left join grade on assignment.assignmentID = grade.assignmentID
group by staff.staffID 
having staff.hireDate between '2007-10-10' and '2008-10-10'
order by staff.staffid;

#Question 12: 
#Categorize the the staff based on their salaries.Display leading zeroes before maximum and minimum salary.
select concat(staff.firstName,' ', staff.lastName) as 'Name', 'Hansomely paid' as 'Pay grade', lpad(staff.salary, 7, '0') as 'Normalized Salary' from staff 
where staff.salary>=38000
UNION
select concat(staff.firstName,' ', staff.lastName) as 'Name', 'Just paid' as 'Pay grade',lpad(staff.salary, 7, '0') as 'Normalized Salary' from staff 
where staff.salary<38000 AND staff.salary > 27000
UNION 
select concat(staff.firstName,' ', staff.lastName) as 'Name', 'Underpaid' as 'Pay grade', lpad(staff.salary, 7, '0') as 'Normalized Salary' from staff 
where staff.salary<=35000;

#Question 13: 
# print the number of students lying in various percent ranges for courses of staff which are faculty position for all the classes that they are taking
select distinct class.name as 'Class Name',
    sum(case when report.percentage<75 and report.percentage > 65 then 1 else 0 end) AverageCount,
    sum(case when report.percentage < 65 then 1 else 0 end) BelowAverageCount,
    sum(case when report.percentage>75 then 1 else 0 end) Excellent
    from report
		left join class on class.classNo = report.classNo
	group by class.name