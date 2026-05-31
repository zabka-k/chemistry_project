USE chemistry;

-- Почистим таблицы от старых записей 
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE sale_items;
TRUNCATE TABLE sales;
TRUNCATE TABLE prescriptions;
TRUNCATE TABLE medicines;
TRUNCATE TABLE users;
TRUNCATE TABLE roles;
TRUNCATE TABLE suppliers;
TRUNCATE TABLE purchase_order_items;
TRUNCATE TABLE purchase_orders;
SET FOREIGN_KEY_CHECKS = 1;


INSERT INTO roles (name) VALUES 
('ADMIN'),
('PHARMACIST'), 
('MANAGER');     -- Заведующий складом

INSERT INTO users (username, passwordd, email, role_id) VALUES 
('ivanov_admin', 'hash_pass_1', 'admin@pharmacy.by', 1),
('petrova_provisor', 'hash_pass_2', 'petrova@pharmacy.by', 2),
('kovalev_sklad', 'hash_pass_3', 'kovalev@pharmacy.by', 3),
('colesnic_admin', 'hash_pass_4', 'colesnic@pharmacy.by', 1),
('dulevich_provisor', 'hash_pass_5', 'dulevich@pharmacy.by', 2);

INSERT INTO suppliers (supplier_name, contact_info, reliability_rate) VALUES 
('РУП БЕЛФАРМАЦИЯ', 'г. Минск, ул. В. Хоружей, 11. Тел: +375 17 242-22-33', 5.00),
('ЗАО Шате-М Плюс (Фарма)', 'Минский р-н, р-н п. Привольный. Тел: +375 17 500-00-00', 4.80),
('ООО ДОМЕН-ФАРМ', 'г. Брест, ул. Пионерская, 52. Тел: +375 162 20-11-22', 4.50),
('ИООО АВА и компания', 'г. Минск, ул. Радиальная, 54Б. Тел: +375 17 399-44-55', 4.75);

INSERT INTO medicines (title, inn, manufacturer, price, stock_quantity, category, is_controlled) 
VALUES 
-- Безрецептурные и ходовые
('Цитрамон-Боримед', 'Acetylsalicylic acid / Paracetamol / Caffeine', 'БЗМП (Борисов)', 1.20, 450, 'Обезболивающее', FALSE),
('Анальгин-УБФ', 'Metamizole sodium', 'Белмедпрепараты (Минск)', 1.85, 300, 'Анальгетики', FALSE),
('АнвиМакс капсулы', 'Paracetamol / Ascorbic acid / Rimantadine', 'Минскинтеркапс', 14.20, 45, 'Противовирусные', FALSE),
('Арпетол 100мг', 'Umifenovir', 'Лекфарм (Логойск)', 11.50, 85, 'Противовирусные', FALSE),
('Мукалтин', 'Althaea officinalis extract', 'Галенофарм', 2.10, 5, 'От кашля', FALSE), -- Мало на складе (подсветится красным)
-- Кардиология и повседневные
('Каптоприл-НАН', 'Captopril', 'Академфарм (Минск)', 4.60, 110, 'Сердечно-сосудистые', FALSE),
('Магвит капсулы', 'Magnesium / Vitamin B6', 'Минскинтеркапс', 9.80, 60, 'Витамины и БАД', FALSE),
('Омепразол 20мг', 'Omeprazole', 'БЗМП (Борисов)', 3.40, 200, 'ЖКТ', FALSE),
-- Импортные популярные оригинальные препараты
('Но-Шпа 40мг', 'Drotaverine', 'Sanofi (Франция)', 8.90, 75, 'Спазмолитики', FALSE),
('Ксарелто 20мг', 'Rivaroxaban', 'Bayer (Германия)', 115.00, 12, 'Антикоагулянты', FALSE),
('ТераФлю Лимон', 'Paracetamol / Pheniramine / Phenylephrine', 'Haleon (Швейцария)', 22.40, 4, 'Противопростудные', FALSE), -- Мало на складе
-- Контролируемые/Рецептурные 
('Диазепам 5мг/мл амп.', 'Diazepam', 'Белмедпрепараты (Минск)', 18.50, 25, 'Транквилизаторы', TRUE),
('Клоназепам 2мг таб.', 'Clonazepam', 'Polfa (Польша)', 24.10, 14, 'Противоэпилептические', TRUE),
('Трамадол 50мг капс.', 'Tramadol', 'Органика', 15.30, 30, 'Наркотический анальгетик', TRUE);

INSERT INTO prescriptions (prescription_number, doctor_name, patient_name, expiry_date, is_valid) VALUES 
('БР-2026-0041', 'Матвеева О.И. (УЗ 1-я ГКБ Минска)', 'Козлов Андрей Сергеевич', '2026-08-15', TRUE),
('БР-2026-0092', 'Дмитриев С.В. (МНПЦ ХТГ)', 'Иванова Мария Николаевна', '2026-07-01', TRUE),
('БР-2025-0811', 'Тарасевич Е.А. (УЗ 34-я ЦРКП)', 'Смирнов Игорь Петрович', '2025-12-31', FALSE); -- Просрочен/Недействителе

INSERT INTO purchase_orders (supplier_id, user_id, order_date, status) VALUES 
(1, 3, '2026-05-20 10:00:00', 'DELIVERED'),
(3, 3, '2026-05-29 14:30:00', 'PENDING');

INSERT INTO purchase_order_items (purchase_order_id, medicine_id, quantity) VALUES 
(1, 4, 30),  
(1, 1, 125); 

