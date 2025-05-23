class EducationalProgram:
    def __init__(self, name, budget_places, paid_places, link, faculties):
        self.name = name
        self.faculties = faculties
        self.budget_places = budget_places
        self.paid_places = paid_places
        self.link = link.rstrip('/')
        self.cost = None
        self.fields = None
        self.required_subjects = []
        self.optional_subjects = []

    def __repr__(self):
        return (f"EducationalProgram(name='{self.name}', budget_places={self.budget_places}, "
                f"paid_places={self.paid_places}, link='{self.link}', faculties={self.faculties})")

    def __str__(self):
        return (f"Программа: {self.name}\nФакультеты: {self.faculties}\n"
                f"Бюджетные места: {self.budget_places}\nПлатные места: {self.paid_places}\n"
                f"Ссылка: {self.link}\n"
                f"Цена: {self.cost}\n"
                f"Направления: {self.fields}\n"
                f"Обязательные предметы: {self.required_subjects}\n"
                f"Предметы на выбор: {self.optional_subjects}")