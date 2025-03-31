import requests
import logging
from clients.post_client import upload_programs
from Entities.EducationalProgram import EducationalProgram
from clients.get_client import get_subjects, get_fields, get_faculties
from bs4 import BeautifulSoup
from logging_config.setup_logging import setup_logging

setup_logging()

logger = logging.getLogger(__name__)

# Парсер
class ItmoParser:
    BASE_URL = "https://abit.itmo.ru"

    API_PROGRAMS_SHORT = (
        "https://abitlk.itmo.ru/api/v1/programs/short"
        "?languages=&priceFrom=&priceTo=&title=&lang=ru"
        "&degree=bachelor&limit=100&page={page}"
    )

    def __init__(self):
        # Справочные данные запрашиваем один раз
        self.faculties_dict = get_faculties(4)
        self.fields_dict = get_fields()
        self.subjects_dict = get_subjects()

    def parse_all_programs(self) -> list[EducationalProgram]:
        programs = []

        links, names = self.get_program_slugs()
        i = 0
        for link_tag in links:
            if link_tag == 'https://abit.itmo.ru/program/bachelor/ai':
                continue
            relative_link = link_tag
            full_link = relative_link

            program_name = names[i]
            i += 1

            program_objs = self.parse_program_page(full_link, program_name)
            programs.extend(program_objs)
            logger.info(f"Parsed {relative_link}")

        return programs


    def get_program_slugs(self) -> (list[str], list[str]):
        page = 1
        slugs = []
        names = []
        while True:
            url = self.API_PROGRAMS_SHORT.format(page=page)
            resp = requests.get(url)
            if resp.status_code != 200:
                print(f"Ошибка запроса {url}, код {resp.status_code}")
                break

            data = resp.json()
            groups = data.get('result', {}).get('groups', [])
            meta = data.get('meta_data', {})
            total = meta.get('total', 0)

            if not groups:
                break

            for g in groups:
                slug = g.get('slug')
                name = g.get('name')
                if slug:
                    slugs.append(slug)
                if name:
                    names.append(name)

            limit = 100
            if page * limit >= total:
                break

            page += 1

        for i in range(len(slugs)):
            slugs[i] = 'https://abit.itmo.ru/program/bachelor/' + slugs[i]
        return slugs, names

    def parse_program_page(self, url: str, program_name: str) -> list[EducationalProgram]:
        resp = requests.get(url)
        if resp.status_code != 200:
            print(f"Ошибка при запросе {url}")
            return []

        soup = BeautifulSoup(resp.text, "html.parser")

        cost = self.extract_cost(soup)
        faculty_div = soup.select_one("div.Information_information__link__cfN2l span")
        faculty_name = faculty_div.get_text(strip=True).lower() if faculty_div else ""
        faculty_id = self.faculties_dict.get(faculty_name, None)
        if faculty_id is None:
            faculty_id = 0

        directions = soup.select("div.Directions_table__item__206L0")

        programs = []

        for direction_block in directions:
            field_code = self.extract_field_code(direction_block)

            field_id = self.fields_dict.get(field_code, None)
            if field_id is None:
                field_id = 0

            local_name = self.extract_local_name(direction_block)
            final_name = local_name if local_name else program_name

            budget_places, paid_places = self.extract_places(direction_block)

            required_subjects, optional_subjects = self.extract_subjects(direction_block)

            obj = EducationalProgram(
                name=final_name,
                budget_places=budget_places,
                paid_places=paid_places,
                link=url,
                faculties=[faculty_id] if faculty_id else []
            )
            obj.cost = cost
            obj.fields = [field_id] if field_id else []
            obj.required_subjects = required_subjects
            obj.optional_subjects = optional_subjects
            programs.append(obj)

        return programs

    def extract_cost(self, soup: BeautifulSoup) -> int:
        card_divs = soup.select("div.Information_card__rshys")
        for div in card_divs:
            header = div.select_one("div.Information_card__header__6PpVf")
            if not header:
                continue
            header_text = header.get_text(strip=True).lower()
            if header_text.startswith("стоимость"):
                text_div = div.select_one("div.Information_card__text__txwcx")
                if text_div:
                    raw_cost = text_div.get_text(strip=True)
                    clean = raw_cost.replace(" ", "").replace("₽", "").replace("\xa0", "")
                    try:
                        return int(clean)
                    except:
                        pass
        return 0

    def extract_field_code(self, direction_block: BeautifulSoup) -> str:

        p_tag = direction_block.select_one("p")
        if p_tag:
            text = p_tag.get_text(strip=True)

            import re
            match = re.match(r"(\d\d?\.\d\d?\.\d\d?)", text)
            if match:
                return match.group(1)
        return ""

    def extract_local_name(self, direction_block: BeautifulSoup) -> str:
        span = direction_block.select_one("h5")
        if span:
            return span.get_text(strip=True)
        return ""

    def extract_places(self, direction_block: BeautifulSoup) -> tuple[int, int]:
        budget = 0
        paid = 0

        place_divs = direction_block.select("div.Directions_table__places__RWYBT")
        for pdiv in place_divs:
            p_tag = pdiv.select_one("p")

            if not p_tag:
                continue
            text_p = p_tag.get_text(strip=True).lower()
            if "бюджет" in text_p:
                span = pdiv.select_one("span")
                if span and span.get_text(strip=True).isdigit():
                    budget = int(span.get_text(strip=True))
            elif "контракт" in text_p:
                span = pdiv.select_one("span")
                if span and span.get_text(strip=True).isdigit():
                    paid = int(span.get_text(strip=True))
        return (budget, paid)

    def extract_subjects(self, direction_block: BeautifulSoup) -> tuple[list[int], list[int]]:
        place_divs = direction_block.select("div.Directions_table__places__RWYBT")

        all_sequences = []
        for pdiv in place_divs:
            p_tag = pdiv.select_one("p")
            if p_tag:
                continue
            span = pdiv.select_one("span")
            if span:
                text_line = span.get_text(strip=True)
                if text_line:
                    all_sequences.append(text_line)

        if len(all_sequences) == 1:
            parts = all_sequences[0].split(" или ")
            if len(parts) == 2:
                seq1 = self.decode_subjects_sequence(parts[0])
                seq2 = self.decode_subjects_sequence(parts[1])
                # required_subjects = intersection
                required = sorted(list(set(seq1) & set(seq2)))
                # optional_subjects = (union - intersection)
                union_ = set(seq1) | set(seq2)
                diff = union_ - set(required)
                optional = sorted(list(diff))
                return required, optional
            else:
                seq1 = self.decode_subjects_sequence(all_sequences[0])
                return seq1, []
        elif len(all_sequences) >= 2:
            seq1 = self.decode_subjects_sequence(all_sequences[0])
            seq2 = self.decode_subjects_sequence(all_sequences[1])
            required = sorted(list(set(seq1) & set(seq2)))
            union_ = set(seq1) | set(seq2)
            diff = union_ - set(required)
            optional = sorted(list(diff))
            return required, optional
        else:
            return [], []

    def decode_subjects_sequence(self, seq: str) -> list[int]:
        result_ids = []
        i = 0
        while i < len(seq):
            # Проверяем, не "ИЯ" ли это
            if seq[i:i+2] == "ИЯ":
                subj_id = self.subjects_dict.get("Иностранный язык", None)
                if subj_id:
                    result_ids.append(subj_id)
                i += 2
                continue
            elif seq[i] == "И":
                subj_id = self.subjects_dict.get("Информатика", None)
                if subj_id:
                    result_ids.append(subj_id)
                i += 1
            else:
                letter = seq[i]
                i += 1
                subj_id = self.find_subject_by_first_letter(letter)
                if subj_id:
                    result_ids.append(subj_id)
        return result_ids

    def find_subject_by_first_letter(self, letter: str) -> int | None:
        letter = letter.upper()
        for subj_name, subj_id in self.subjects_dict.items():
            if subj_name[0].upper() == letter:
                return subj_id
        return None


def main():
    parser = ItmoParser()
    all_programs = parser.parse_all_programs()

    for prog in all_programs:
        upload_programs(4, prog)
        logger.info(f"Uploaded {prog.name}")


if __name__ == "__main__":
    main()