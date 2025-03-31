import requests
import time
from bs4 import BeautifulSoup
from clients.post_client import upload_faculties
faculties = {
    'ФИТиП': 'Факультет информационных технологий и программирования',
    'ФТИИ': 'Факультет технологий искусственного интеллекта',
    'ФизФ': 'Физический факультет',
    'НОЦ инфохимии': 'Научно-образовательный центр инфохимии',
    'ФЭТ': 'Факультет экотехнологий',
    'ФПИ и КТ': 'Факультет программной инженерии и компьютерной техники',
    'ФПИн': 'Факультет прикладной информатики',
    'ФБИТ': 'Факультет безопасности информационных технологий',
    'ШРВ': 'Школа разработки видеоигр',
    'ФСУ и Р': 'Факультет систем управления и робототехники',
    'ЦПО': 'Центр прикладной оптики',
    'Ф фотоники': 'Факультет фотоники',
    'НОЦ ФиОИ': 'Научно-образовательный центр фотоники и оптоинформатики',
    'ИПСПД': 'Институт перспективных систем передачи данных',
    'МНОЦ ФН': 'Международный научно-образовательный центр физики наноструктур',
    'Центр ХИ': 'Центр химической инженерии',
    'ФНЭ': 'Факультет наноэлектроники',
    'ИЛТ': 'Институт лазерных технологий',
    'ФЭ и ЭТ': 'Факультет энергетики и экотехнологий',
    'ОЦ ЭИС': 'Образовательный центр "энергоэффективные инженерные системы"',
    'ФБТ': 'Факультет биотехнологий',
    'ФТМИ': 'Факультет технологического менеджмента и инноваций',
    'ИДУ': 'Институт дизайна и урбанистики',
    'ВШ ЦК': 'Высшая школа цифровой культуры',
    'Институт МР и П': 'Институт международного развития и партнерства'
}


def main():
    base_url = 'https://edu.itmo.ru'
    start_url = f'{base_url}/ru/napravleniya/'

    faculty_dict = {}

    response = requests.get(start_url)
    if response.status_code != 200:
        print(f"Ошибка при получении страницы {start_url}: {response.status_code}")
        return
    soup = BeautifulSoup(response.text, 'html.parser')

    main_container = soup.find('div', class_='directions-specialties__list')
    if not main_container:
        print("Не найден контейнер с классом 'directions-specialties__list' на главной странице")
        return

    for a in main_container.find_all('a'):
        time.sleep(2)
        first_link = a.get('href')
        if not first_link:
            continue
        first_url = base_url + first_link

        resp_first = requests.get(first_url)
        if resp_first.status_code != 200:
            print(f"Ошибка при получении страницы {first_url}: {resp_first.status_code}")
            continue
        soup_first = BeautifulSoup(resp_first.text, 'html.parser')

        second_container = soup_first.find('div', class_='directions-specialties__list')
        if not second_container:
            print(f"Не найден контейнер 'directions-specialties__list' на странице {first_url}")
            continue

        for a2 in second_container.find_all('a'):
            deps_div = a2.find('div', class_='directions-specialties__item-deps')
            if not deps_div:
                continue
            deps_text = deps_div.get_text(strip=True)

            if deps_text not in faculty_dict:
                second_link = a2.get('href')
                if not second_link:
                    continue
                second_url = base_url + second_link

                resp_third = requests.get(second_url)
                if resp_third.status_code != 200:
                    print(f"Ошибка при получении страницы {second_url}: {resp_third.status_code}")
                    continue
                soup_third = BeautifulSoup(resp_third.text, 'html.parser')

                cells = soup_third.find_all('div', class_='cell lg-4')
                faculty_name = None
                for cell in cells:
                    h3 = cell.find('h3')
                    if h3 and h3.get_text(strip=True) == 'Факультет':
                        full_text = cell.get_text(separator=" ", strip=True)
                        faculty_name = full_text.replace('Факультет', '', 1).strip()
                        break

                if faculty_name:
                    faculty_dict[deps_text] = faculty_name
                    print(f"Добавлена пара: '{deps_text}' -> '{faculty_name}'")
                else:
                    print(f"Факультет не найден на странице {second_url}")

    faculties = []

    for key, value in faculty_dict.items():
        faculties.append(value)

    return faculties


if __name__ == "__main__":
    faculties = main()
    upload_faculties(4, faculties)