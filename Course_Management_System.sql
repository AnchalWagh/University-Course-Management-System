#   Project : University Course Management System   #

#Create the Database
CREATE DATABASE course_management;
USE course_management;

#Create All Tables
#1. students 
CREATE TABLE students( 
student_id INT PRIMARY KEY AUTO_INCREMENT, 
name VARCHAR(50), 
major VARCHAR(50), 
enrollment_year INT 
);

#2. courses 
CREATE TABLE courses( 
course_id VARCHAR(10) PRIMARY KEY, 
course_name VARCHAR(50), 
credits INT, 
department VARCHAR(50) 
);

#3. instructors 
CREATE TABLE instructors( 
instructor_id VARCHAR(10) PRIMARY KEY, 
name VARCHAR(50), 
department VARCHAR(50) 
);

#4. sections 
CREATE TABLE sections( 
section_id VARCHAR(10) PRIMARY KEY, 
course_id VARCHAR(10), 
instructor_id VARCHAR(10), 
semester VARCHAR(20), 
year INT, room VARCHAR(10), 
FOREIGN KEY (course_id) REFERENCES courses(course_id), 
FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id) 
);

#5. enrollments 
CREATE TABLE enrollments( 
enrollment_id VARCHAR(10) PRIMARY KEY, 
student_id INT, section_id VARCHAR(10), 
grade DECIMAL(3,1), 
FOREIGN KEY (student_id) REFERENCES students(student_id), 
FOREIGN KEY (section_id) REFERENCES sections(section_id) 
);

ALTER TABLE enrollments 
ADD CONSTRAINT chk_grade CHECK (grade <= 4.0 AND grade >= 0.0);

#Insert Values 
INSERT INTO students (name, major, enrollment_year) VALUES 
("Amit Sharma", "Information Technology", 2023), 
("Riya Patel", "Computer Science and Engineering", 2024), 
("Suresh Kumar", "Artificial Intelligence and Data Science", 2025),
("Priya Singh", "Artificial Intelligence & Machine Learning", 2023), 
("Nikhil Verma", "Electronics Engineering", 2024), 
("Sneha Joshi", "Electrical Engineering", 2025), 
("Rohan Das", "Information Technology", 2023), 
("Kavita Mehra", "Computer Science and Engineering", 2024), 
("Harshil Shah", "Artificial Intelligence and Data Science", 2025), 
("Ananya Rao", "Artificial Intelligence & Machine Learning", 2024), 
("Manish Kumar", "Information Technology", 2023), 
("Pooja Singh", "Computer Science and Engineering", 2024), 
("Rajesh Verma", "Artificial Intelligence & Machine Learning", 2025), 
("Anjali Mehta", "Electronics Engineering", 2023), 
("Vikram Sharma", "Electrical Engineering", 2024);

SELECT * FROM students;

INSERT INTO courses VALUES 
("C101", "Database Management", 4, "Information Technology"), 
("C102", "Data Structures", 3, "Computer Science and Engineering"), 
("C103", "Full Stack Web Development", 4, "Information Technology"), 
("C104", "Artificial Intelligence", 4, "Artificial Intelligence & Machine Learning"), 
("C105", "Cloud Computing", 3, "Information Technology"), 
("C106", "Machine Learning", 4, "Artificial Intelligence and Data Science"), 
("C107", "Computer Networks", 3, "Computer Science and Engineering"),
("C108", "Cybersecurity Fundamentals", 4, "Information Technology"), 
("C109", "Python Programming", 3, "Artificial Intelligence & Machine Learning"), 
("C110", "Digital Electronics", 3, "Electronics Engineering");

SELECT * FROM courses;

INSERT INTO instructors VALUES 
("I101", "Professor Mehta", "Information Technology"), 
("I102", "Professor Banerjee", "Computer Science and Engineering"), 
("I103", "Professor Sharma", "Artificial Intelligence and Data Science"), 
("I104", "Professor Iyer", "Artificial Intelligence & Machine Learning"), 
("I105", "Professor Rao", "Electronics Engineering"), 
("I106", "Professor Thomas", "Electrical Engineering");

SELECT * FROM instructors;

INSERT INTO sections VALUES 
("S101", "C101", "I101", "Fall 2024", 2024, "Room-A1"), 
("S102", "C102", "I102", "Spring 2024", 2024, "Room-B2"), 
("S103", "C103", "I101", "Summer 2024", 2024, "Room-C3"), 
("S104", "C104", "I104", "Fall 2025", 2025, "Room-D4"), 
("S105", "C105", "I101", "Spring 2024", 2024, "Room-A2"), 
("S106", "C106", "I103", "Spring 2025", 2025, "Room-B3"), 
("S107", "C107", "I102", "Summer 2024", 2024, "Room-C4"), 
("S108", "C108", "I101", "Fall 2025", 2025, "Room-A3"), 
("S109", "C109", "I104", "Spring 2024", 2024, "Room-D5"), 
("S110", "C110", "I105", "Spring 2024", 2024, "Room-E1");

SELECT * FROM sections;

INSERT INTO enrollments VALUES 
("E001", 1, "S101", 2.8), 
("E002", 2, "S102", 3.6), 
("E003", 3, "S106", 2.5), 
("E004", 4, "S104", 3.2), 
("E005", 5, "S110", 3.0), 
("E006", 6, "S106", 3.7), 
("E007", 7, "S103", 2.9), 
("E008", 8, "S102", 3.4), 
("E009", 9, "S106", 3.8), 
("E010", 10, "S109", 2.6), 
("E011", 11, "S105", 3.1), 
("E012", 12, "S102", 3.3), 
("E013", 13, "S109", 2.7), 
("E014", 14, "S110", 3.5), 
("E015", 15, "S106", 3.9);

SELECT * FROM enrollments;

# Queries
# 1.List all students enrolled in the "Computer Science and Engineering" department courses.
SELECT s.student_id, s.name, s.major 
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN sections se ON e.section_id = se.section_id
JOIN courses c ON se.course_id = c.course_id
WHERE c.department = "Computer Science and Engineering";

# 2.Find the average grade per course.
SELECT ROUND(AVG(e.grade),2) AS Average_Grade, 
c.course_name AS Course_Name
FROM enrollments e
JOIN sections se ON e.section_id = se.section_id
JOIN courses c ON se.course_id = c.course_id
GROUP BY c.course_name;

# 3.Count the number of students taught by each instructor.
SELECT i.name AS Instructor, COUNT(e.student_id) AS Total_Student
FROM instructors i
LEFT JOIN sections se ON i.instructor_id = se.instructor_id
LEFT JOIN enrollments e ON se.section_id = e.section_id
GROUP BY i.name;

# 4.List all courses offered in the 'Fall 2024' semester.
SELECT c.course_id, se.semester, se.year, c.course_name 
FROM sections se
JOIN courses c ON se.course_id = c.course_id
WHERE se.semester = "Fall 2024" AND se.year = 2024;

# 5.Find the instructor with the most sections taught.
SELECT i.instructor_id, i.name, COUNT(se.section_id) AS Total_sections
FROM instructors i
JOIN sections se ON i.instructor_id = se.instructor_id
GROUP BY i.instructor_id
ORDER BY Total_sections DESC
LIMIT 1;

# 6.Calculate the total number of credit hours each student is enrolled in for the current semester.
SELECT s.student_id, s.name, SUM(c.credits) AS Total_Credits
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN sections se ON e.section_id = se.section_id
JOIN courses c ON se.course_id = c.course_id
WHERE se.semester = "Spring 2025"
GROUP BY s.student_id, s.name;

# 7.Identify students who have a grade average above 3.5 (on a 4.0 scale).
SELECT s.student_id, s.name, ROUND(AVG(e.grade),2) AS Avg_grade
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
GROUP BY s.student_id
HAVING AVG(e.grade) > 3.5;

# 8.Find courses that have no enrolled students.
SELECT c.course_id, c.course_name, c.department, e.enrollment_id
FROM courses c
LEFT JOIN sections se ON c.course_id = se.course_id
LEFT JOIN enrollments e ON se.section_id = e.section_id
WHERE e.enrollment_id IS NULL;

# 9.List the top 5 students with the highest overall GPA.
SELECT s.student_id, s.name, s.major, ROUND(AVG(e.grade),2) AS GPA
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.name
ORDER BY AVG(e.grade) DESC
LIMIT 5;

# 10.Show the grade distribution (number of A, B, C, etc.) for a specific course.
SELECT 
    CASE
        WHEN e.grade >= 3.5 THEN "A"
        WHEN e.grade >= 3.0 THEN "B"
        WHEN e.grade >= 2.0 THEN "C"
        WHEN e.grade >= 1.0 THEN "D"
        ELSE "F"
    END AS Grade_Range,
    se.course_id,
    COUNT(*) AS Total_Students
FROM enrollments e
JOIN sections se ON e.section_id = se.section_id
WHERE se.course_id = "C106"
GROUP BY Grade_Range
ORDER BY Grade_Range;
