#Использовать ".."

Имя = АргументыКоманднойСтроки[0];
Пароль = АргументыКоманднойСтроки[1];

ФильтрКонфигураций = "Конвертация данных";
ФильтрВерсий = "3\.0\.5";
ФильтрЗагрузок = "Полный дистрибутив";

Обозреватель = Новый ОбозревательСайта1С(Имя, Пароль);

СписокКонфигураций = Обозреватель.ПолучитьСписокПриложений(ФильтрКонфигураций);

Для Каждого ТекКонфигурация Из СписокКонфигураций Цикл
	Сообщить(СтрШаблон("%1 : %2", ТекКонфигурация.Имя, ТекКонфигурация.Путь));
	СписокВерсий = Обозреватель.ПолучитьВерсииПриложения(ТекКонфигурация.Путь, ФильтрВерсий);
	Для Каждого ТекВерсия Из СписокВерсий Цикл
		Сообщить(СтрШаблон("%1 %2 : %3 : %4", Символы.Таб, ТекВерсия.Версия, ТекВерсия.Дата, ТекВерсия.Путь));
		СписокСсылок = Обозреватель.ПолучитьСсылкиДляЗагрузки(ТекВерсия.Путь, ФильтрЗагрузок);
		Для Каждого ТекСсылка Из СписокСсылок Цикл
			Сообщить(СтрШаблон("%1%1 %2 : %3 (Скачать: %4) Имя файла: %5",
							   Символы.Таб,
							   ТекСсылка.Имя,
							   ТекСсылка.Путь,
							   ТекСсылка.ПутьДляЗагрузки,
							   ТекСсылка.ИмяФайла));
			ИмяФайла = ОбъединитьПути(ТекущийКаталог(), ТекСсылка.ИмяФайла);
			ВремФайл = Новый Файл(ИмяФайла);
			Обозреватель.ЗагрузитьФайл(ТекСсылка.ПутьДляЗагрузки, ИмяФайла);
			КаталогДляРаспаковки = ОбъединитьПути(ТекущийКаталог(), "tmp", "distr", ВремФайл.ИмяБезРасширения);
			Распаковщик.РаспаковатьАрхив(ИмяФайла, КаталогДляРаспаковки);
			Распаковщик.РаспаковатьШаблонКонфигурации1С(ОбъединитьПути(КаталогДляРаспаковки, "1cv8.efd"),
														КаталогДляРаспаковки,
														"1cv8.cf");

		КонецЦикла;
		Для Каждого ТекВерсияО Из ТекВерсия.ВерсииДляОбновления Цикл
			Сообщить(СтрШаблон("%1%1 %2", Символы.Таб, СокрЛП(ТекВерсияО)));
		КонецЦикла;
	КонецЦикла;
КонецЦикла;
