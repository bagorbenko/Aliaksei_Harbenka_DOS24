from sqlalchemy import create_engine, Column, Integer, String, ForeignKey
from sqlalchemy.orm import declarative_base, sessionmaker, relationship
import factory
import random
from config import DATABASE_URL_STUDY


engine = create_engine(DATABASE_URL_STUDY)
Session = sessionmaker(bind=engine)
session = Session()

Base = declarative_base()


class Student(Base):
    __tablename__ = 'Students'
    student_id = Column(Integer, primary_key=True, autoincrement=True)
    student_name = Column(String(255))

class Course(Base):
    __tablename__ = 'Courses'
    course_id = Column(Integer, primary_key=True, autoincrement=True)
    course_name = Column(String(255))
    student_id = Column(Integer, ForeignKey('Students.student_id'))

STUDENT_NAMES = [
    "Иван Петров", "Мария Смирнова", "Алексей Иванов", "Ольга Кузнецова", 
    "Дмитрий Соколов", "Анна Попова", "Николай Васильев", "Екатерина Михайлова",
    "Сергей Фёдоров", "Татьяна Павлова"
]

COURSE_NAMES = [
    "Математика", "Физика", "Информатика", "История", 
    "Литература", "Биология", "Химия", "География", "Экономика", "Философия"
]

class StudentFactory(factory.Factory):
    class Meta:
        model = Student

    student_name = factory.Iterator(STUDENT_NAMES)

# фабрика для курсов
class CourseFactory(factory.Factory):
    class Meta:
        model = Course

    course_name = factory.Iterator(COURSE_NAMES)
    student_id = factory.LazyAttribute(lambda _: random.choice([None] + list(range(1, len(STUDENT_NAMES) + 1))))

# функция для заполнения базы данных
def populate_data():
    students = StudentFactory.create_batch(len(STUDENT_NAMES))
    session.add_all(students)
    session.commit()

    courses = CourseFactory.create_batch(len(COURSE_NAMES))
    session.add_all(courses)
    session.commit()

    print("Таблицы Students и Courses заполнены тестовыми данными.")

if __name__ == "__main__":
    populate_data()