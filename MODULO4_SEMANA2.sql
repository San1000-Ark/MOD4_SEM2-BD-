-- create database of university_academic_management
CREATE DATABASE university_academic_management;
-- create table of students
CREATE TABLE students (
    id_student INT AUTO_INCREMENT PRIMARY KEY,
    complete_name VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    gender ENUM('M', 'F', 'Otro') NOT NULL,
    identification VARCHAR(20) UNIQUE NOT NULL,
    profession VARCHAR(20) NOT NULL,
    birth_date DATE,
    init_date DATE NOT NULL
);
-- create table of teachers
CREATE TABLE teachers (
    id_teacher INT AUTO_INCREMENT PRIMARY KEY,
    complete_name VARCHAR(50) UNIQUE NOT NULL,
    institute_email VARCHAR(100) UNIQUE NOT NULL,
    academic_department ENUM('Ciencias', 'Humanidades', 'Ingeniería', 'Arte','Filosofia') NOT NULL,
    years_experience INT NOT NULL CHECK(years_experience >=0)
);
-- create table of courses
CREATE TABLE courses (
	id_course INT AUTO_INCREMENT PRIMARY KEY,
	name_course VARCHAR(50) UNIQUE NOT NULL,
	code_course VARCHAR(64) UNIQUE NOT NULL,
	credits INT NOT NULL CHECK(credits >0),
	semester INT NOT NULL CHECK(semester BETWEEN 1 AND 12),
    id_teacher INT NOT NULL,
	FOREIGN KEY (id_teacher) REFERENCES teachers(id_teacher)
);
-- create table of registration
CREATE TABLE registration(
	id_registration INT AUTO_INCREMENT PRIMARY KEY,
	id_student INT NOT NULL,
	id_course INT NOT NULL,
	registration_date DATE NOT NULL,
	final_calification DECIMAL NOT NULL,
    FOREIGN KEY (id_student) REFERENCES students(id_student),
    FOREIGN KEY (id_course) REFERENCES courses(id_course)
);
-- insert values to the students keys
INSERT INTO students (complete_name, email, gender, identification, profession, birth_date, init_date)
VALUES 
('Ana Martínez', 'ana.martinez@example.com', 'F', 'ID1001', 'Ingeniera', '1995-06-15', '2023-09-01'),
('Carlos Gómez', 'carlos.gomez@example.com', 'M', 'ID1002', 'Doctor', '1990-03-22', '2022-01-10'),
('Lucía Torres', 'lucia.torres@example.com', 'F', 'ID1003', 'Abogada', '1998-11-05', '2024-02-15'),
('Pedro Ramírez', 'pedro.ramirez@example.com', 'M', 'ID1004', 'Arquitecto', '1985-07-30', '2021-05-20'),
('Sofía Jiménez', 'sofia.jimenez@example.com', 'F', 'ID1005', 'Psicóloga', '1992-12-12', '2023-03-03'),
('Emilio Rojas', 'emilio.rojas@example.com', 'M', 'ID1006', 'Programador', '1996-08-18', '2024-09-10');

-- insert values to the teachers keys
INSERT INTO teachers (complete_name, institute_email, academic_department, years_experience)
VALUES
('María López', 'maria.lopez@institute.edu', 'Ciencias', 10),
('Juan Pérez', 'juan.perez@institute.edu', 'Ingeniería', 7),
('Laura Fernández', 'laura.fernandez@institute.edu', 'Humanidades', 5),
('Miguel Torres', 'miguel.torres@institute.edu', 'Arte', 12),
('Patricia Ruiz', 'patricia.ruiz@institute.edu', 'Ciencias', 8),
('Andrés Castillo', 'andres.castillo@institute.edu', 'Ingeniería', 15);

-- insert values into courses
INSERT INTO courses (name_course, code_course, credits, semester, id_teacher)
VALUES
('Matemáticas I', 'MAT101', 4, 1, 1),
('Programación Básica', 'INF102', 3, 1, 2),
('Historia Universal', 'HIS103', 2, 2, 3),
('Diseño Gráfico', 'ART104', 3, 1, 4),
('Física General', 'FIS105', 4, 2, 5),
('Estructuras de Datos', 'INF106', 4, 2, 6);

-- insert values of registrations into registrations(table)
INSERT INTO registration (id_student, id_course, registration_date, final_calification)
VALUES
(1, 1, '2025-01-10', '5,2'),
(2, 2, '2025-01-12', '2,5'),
(3, 3, '2025-01-15', '2,8'),
(4, 4, '2025-01-20', '9,6'),
(5, 5, '2025-01-22', '3,5'),
(6, 6, '2025-01-25', '5,8'),
(1, 2, '2025-01-10', '4,8'),
(3, 1, '2025-01-15', '9,4');

-- CONSULTS
-- Obtener el listado de todos los estudiantes junto con sus inscripciones y cursos (JOIN).
SELECT 
	students.complete_name AS student,
    courses.name_course AS course,
    registration.registration_date,
    registration.final_calification
FROM registration
JOIN students ON registration.id_student=students.id_student
JOIN courses ON registration.id_course=courses.id_course;

-- Listar los cursos dictados por docentes con más de 5 años de experiencia.
SELECT 
	courses.name_course AS course,
    teachers.complete_name AS teacher,
    teachers.years_experience AS experience
FROM courses
JOIN teachers ON courses.id_teacher=teachers.id_teacher
WHERE teachers.years_experience > 5;

-- Obtener el promedio de calificaciones por curso (GROUP BY + AVG).
SELECT 
	courses.name_course AS course,
    ROUND (AVG(registration.final_calification),2) AS prom_calification
FROM registration
JOIN courses ON registration.id_course=courses.id_course
GROUP BY courses.name_course;

-- Mostrar los estudiantes que están inscritos en más de un curso (HAVING COUNT(*) > 1).
SELECT 
	students.complete_name,
	COUNT(*) AS total_courses
FROM registration
JOIN students ON registration.id_student=students.id_student
GROUP BY students.complete_name
HAVING COUNT(*) > 1;


-- Agregar una nueva columna estado_academico a la tabla estudiantes (ALTER TABLE).
ALTER TABLE students 
ADD COLUMN academic_state ENUM('ACTIVE','INACTIVE');
SELECT * FROM students;

-- Eliminar un docente y observar el efecto en la tabla cursos (uso de ON DELETE en FK).
ALTER TABLE courses
DROP FOREIGN KEY id_teacher;
ALTER TABLE courses
ADD CONSTRAINT fk_courses_teacher
FOREIGN KEY (id_teacher) REFERENCES teachers(id_teacher)
ON DELETE CASCADE;
-- PROBAR LA ELIMINACION
DELETE FROM teachers WHERE id_teacher=1;










	




