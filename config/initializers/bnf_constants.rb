#coding: utf-8
Padezh_list = ["Именительный", "Родительный", "Винительный", "Дательный",
               "Творительный", "Предложный"]
Gender_list = ["Мужской", "Женский", "Средний"]
Number_list = ["Единственное", "Множественное"]
Odush_list = ["Одушевленное", "Неодушевленное"]
Vid_list = ["Совершенный", "Несовершенный"]
Tense_list = ["Прошедшее", "Настоящее", "Будущее"]
Sem_val_list = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "K", "L",
    "M", "O", "P", "R", "S", "T", "U", "W"]
Pred_list = ["по", "на", "в", "с", "для", "до", "от", "к", "у", "за", "из"]
Sem_prizn_list = ["Одушевленный предмет", "Неодушевленный предмет",
                  "Пункт назначения", "Результат", "Время"]
Codificator_list = ["Местоимение", "Наречие", "Предлог", "Прилагательное",
                    "Союз", "Числительное", "Существительное", "Аббревиатура",
                    "Причастие", "Деепричастие"]
Person_list = ["Первое", "Второе", "Третье"]
Bnf_list = ["<описание словаря>", "<имя словаря>", "{<тело словаря>}",
            "<тело словаря>", "<словарная статья>", "<словарная статья понятий>",
            "<словарная статья вопросительных слов>", "<словарная статья предлогов>",
            "<словарная статья предикатов>", "<словарная статья характеристик>",
            "<словарная статья неизменяемых словоформ>", "<кодификатор части речи>", "{<падеж>}",
            "<падеж>", "<номер п/п>", "<словоформа>", "<род>", "<одушевленность>",
            "<число>", "<семантическая категория>", "<семантический признак>",
            "<имя семантической валентности>", "<синтаксический компонент МУ>",
            "<семантический компонент МУ>", "[<предлог>]", "<актант>", "<МУ>",
            "<тип вопроса>", "<предлог>", "<лицо>", "<время>",
            "<наклонение>", "<вид>", "<образец>",
            "{<образец>}"]
V_name_list = ["словарь вопросительных слов", "словарь понятий", "словарь неизменяемых словоформ",
               "словарь предикатов", "словарь характеристик", "словарь предлогов"]

Bnf_elements_lists = {["<падеж>", "padezh"] => Padezh_list,
            ["<род>", "gender"] => Gender_list,
            ["<число>", "number"] => Number_list,
            ["<лицо>", "person"] => Person_list,
            ["<одушевленность>", "odush"] => Odush_list,
            ["<вид>", "vid"] => Vid_list,
            ["<время>", "tense"] => Tense_list,
            ["<имя семантической валентности>", "sem_val"] => Sem_val_list,
            ["<предлог>", "pred"] => Pred_list,
            ["<семантический признак>", "sem_prizn"] => Sem_prizn_list,
            ["<кодификатор части речи>", "codificator"] => Codificator_list}
