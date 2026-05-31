CREATE DATABASE IF NOT EXISTS chemistry;
USE chemistry;

SHOW TABLES;
DESCRIBE users;

-- ТАБЛИЦА РОЛЕЙ ПОЛЬЗОВАТЕЛЕЙ
CREATE TABLE IF NOT EXISTS roles (
    role_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- ТАБЛИЦА ПОЛЬЗОВАТЕЛЕЙ
CREATE TABLE IF NOT EXISTS users (
    user_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    passwordd VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role_id INT NOT NULL,
    FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE RESTRICT
);

-- ТАБЛИЦА ЛЕКАРСТВЕННЫХ СРЕДСТВ
CREATE TABLE IF NOT EXISTS medicines (
    medicine_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,                    -- Название препарата
    inn VARCHAR(150),                               -- Международное непатентованное название
    manufacturer VARCHAR(100) NOT NULL,             -- Производитель
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0), -- Остаток на складе
    category VARCHAR(100),                          -- Категория / классификация
    is_controlled BOOLEAN DEFAULT FALSE             -- Требуется ли рецепт
);

-- ТАБЛИЦА ПОСТАВЩИКОВ
CREATE TABLE IF NOT EXISTS suppliers (
    supplier_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(150) NOT NULL UNIQUE,
    contact_info TEXT,
    reliability_rate NUMERIC(3, 2) DEFAULT 5.00 CHECK (reliability_rate >= 0 AND reliability_rate <= 5)
);

-- ТАБЛИЦА ЗАКАЗОВ НА ЗАКУПКУ
CREATE TABLE IF NOT EXISTS purchase_orders (
    purchase_order_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expected_delivery_date DATE,
    status VARCHAR(50) DEFAULT 'PENDING',
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE CASCADE
);

-- ТАБЛИЦА ПОЗИЦИЙ В ЗАКАЗЕ НА ЗАКУПКУ
CREATE TABLE IF NOT EXISTS purchase_order_items (
    purchase_order_items_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    purchase_order_id INT NOT NULL,
    medicine_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (purchase_order_id) REFERENCES purchase_orders(purchase_order_id) ON DELETE CASCADE,
    FOREIGN KEY (medicine_id) REFERENCES medicines(medicine_id) ON DELETE CASCADE
);

-- ТАБЛИЦА РЕЦЕПТОВ
CREATE TABLE IF NOT EXISTS prescriptions (
    prescriptions_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prescription_number VARCHAR(50) NOT NULL UNIQUE,
    doctor_name VARCHAR(100) NOT NULL,
    patient_name VARCHAR(100) NOT NULL,
    expiry_date DATE NOT NULL,
    is_valid BOOLEAN DEFAULT TRUE
);

-- ТАБЛИЦА ТРАНЗАКЦИЙ ПРОДАЖ
CREATE TABLE IF NOT EXISTS sales (
    sale_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    pharmacist_id INT NOT NULL,
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount NUMERIC(10, 2) NOT NULL CHECK (total_amount >= 0),
    payment_method VARCHAR(50) NOT NULL,
    prescription_id INT,
    FOREIGN KEY (pharmacist_id) REFERENCES users(user_id) ON DELETE RESTRICT,
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescriptions_id) ON DELETE SET NULL
);

-- ТАБЛИЦА ПОЗИЦИЙ В ЧЕКЕ (Детализация продаж)
CREATE TABLE IF NOT EXISTS sale_items (
    sale_items_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    sale_id INT NOT NULL,
    medicine_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_sale NUMERIC(10, 2) NOT NULL CHECK (price_at_sale >= 0),
    FOREIGN KEY (sale_id) REFERENCES sales(sale_id) ON DELETE CASCADE,
    FOREIGN KEY (medicine_id) REFERENCES medicines(medicine_id) ON DELETE RESTRICT
);

-- ИНДЕКСЫ ДЛЯ ОПТИМИЗАЦИИ ПОИСКА
CREATE INDEX idx_medicines_title ON medicines(title);
CREATE INDEX idx_medicines_inn ON medicines(inn);
CREATE INDEX idx_prescriptions_number ON prescriptions(prescription_number);