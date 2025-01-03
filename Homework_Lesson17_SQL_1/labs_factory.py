from sqlalchemy import create_engine, Column, Integer, String, DECIMAL, ForeignKey, DateTime
from sqlalchemy.orm import declarative_base, sessionmaker, relationship
import factory
from datetime import datetime
import random
from config import DATABASE_URL_LABS


engine = create_engine(DATABASE_URL_LABS)
Session = sessionmaker(bind=engine)
session = Session()

Base = declarative_base()

class Group(Base):
    __tablename__ = 'Groups'
    gr_id = Column(Integer, primary_key=True, autoincrement=True)
    gr_name = Column(String(255))        # Название группы, например: "Гематология", "Биохимия"
    gr_temp = Column(String(255))        # Температурный режим хранения

    analyses = relationship("Analysis", backref="group")

class Analysis(Base):
    __tablename__ = 'Analysis'
    an_id = Column(Integer, primary_key=True, autoincrement=True)
    an_name = Column(String(255))        # Название анализа
    an_cost = Column(DECIMAL(10, 2))     # Себестоимость анализа
    an_price = Column(DECIMAL(10, 2))    # Розничная цена анализа
    an_group = Column(Integer, ForeignKey('Groups.gr_id'))  # ID группы анализов

class Orders(Base):
    __tablename__ = 'Orders'
    ord_id = Column(Integer, primary_key=True, autoincrement=True)
    ord_datetime = Column(DateTime, default=datetime.utcnow)
    ord_an = Column(Integer, ForeignKey('Analysis.an_id'))  # ID анализа

# фабрика для Group подобная на настоящую группу (фейкер слажал в 1 раз, некрасиво вышло)
class GroupFactory(factory.Factory):
    class Meta:
        model = Group

    gr_name = factory.Iterator([
        "Гематология",
        "Биохимия",
        "Радиология",
        "Иммунология",
        "Микробиология"
    ])
    gr_temp = factory.Iterator([
        "-8°C",
        "-4°C",
        "0°C",
        "4°C"
        "8°C",
        "12°C",
        "16°C",
        "20°C"
    ])

# фабрика для Analysis (аналогично)
class AnalysisFactory(factory.Factory):
    class Meta:
        model = Analysis

    an_name = factory.Iterator([
        "Общий анализ крови",
        "Биохимический анализ крови",
        "МРТ головного мозга",
        "Рентген грудной клетки",
        "Тест на глюкозу",
        "Анализ мочи",
        "УЗИ брюшной полости",
        "ЭКГ сердца"
    ])
    an_cost = factory.LazyAttribute(lambda _: round(random.uniform(100, 2000), 2))
    an_price = factory.LazyAttribute(lambda _: round(random.uniform(500, 5000), 2))
    an_group = factory.LazyAttribute(lambda _: random.randint(1, 5))

# фабрика для Orders
class OrdersFactory(factory.Factory):
    class Meta:
        model = Orders

    ord_datetime = factory.Faker('date_time_between', start_date='-1y', end_date='now')
    ord_an = factory.LazyAttribute(lambda _: random.randint(1, 10))

# заполняем данными
def fake_new_data():
    groups = GroupFactory.create_batch(5)
    session.add_all(groups)
    session.commit()

    analyses = AnalysisFactory.create_batch(10)
    session.add_all(analyses)
    session.commit()

    orders = OrdersFactory.create_batch(20)
    session.add_all(orders)
    session.commit()

    print("База данных заполнена тестовыми данными.")

if __name__ == "__main__":
    Base.metadata.create_all(engine)

    fake_new_data()


