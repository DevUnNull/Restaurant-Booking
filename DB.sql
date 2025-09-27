-- MySQL Database Script for Restaurant Booking System
-- Create database RestaurantBooking
CREATE DATABASE IF NOT EXISTS RestaurantBooking;

USE RestaurantBooking;

-- Create Roles table
CREATE TABLE Roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- Create Users table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    role_id INT,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone_number VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    avatar VARCHAR(500),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    status VARCHAR(20),
    role VARCHAR(20),
    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);

-- Create Tables table
CREATE TABLE Tables (
    table_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(100) NOT NULL,
    capacity INT,
    floor INT,
    table_type VARCHAR(100),
    status VARCHAR(20),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME
);

-- Create Reservations table
CREATE TABLE Reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    table_id INT,
    reservation_date DATE,
    reservation_time TIME,
    guest_count INT,
    special_requests TEXT,
    status VARCHAR(20),
    total_amount DECIMAL(18,2),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    cancellation_reason VARCHAR(500),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (table_id) REFERENCES Tables(table_id)
);

-- Create Menu_Items table
CREATE TABLE Menu_Items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(255) NOT NULL,
    item_code VARCHAR(50) UNIQUE,
    description TEXT,
    price DECIMAL(18,2),
    image_url VARCHAR(500),
    category VARCHAR(100),
    calories INT,
    status VARCHAR(20),
    created_by INT,
    updated_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    FOREIGN KEY (created_by) REFERENCES Users(user_id),
    FOREIGN KEY (updated_by) REFERENCES Users(user_id)
);

-- Create Order_Items table
CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT,
    item_id INT,
    quantity INT,
    unit_price DECIMAL(18,2),
    special_instructions TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id),
    FOREIGN KEY (item_id) REFERENCES Menu_Items(item_id)
);

-- Create Work_Schedules table
CREATE TABLE Work_Schedules (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    work_date DATE,
    shift VARCHAR(20),
    start_time TIME,
    end_time TIME,
    work_position VARCHAR(100),
    notes TEXT,
    status VARCHAR(20),
    assigned_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (assigned_by) REFERENCES Users(user_id)
);

-- Create Services table
CREATE TABLE Services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(255) NOT NULL,
    service_code VARCHAR(50) UNIQUE,
    description TEXT,
    price DECIMAL(18,2),
    promotion_info TEXT,
    start_date DATE,
    end_date DATE,
    status VARCHAR(20),
    created_by INT,
    updated_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    FOREIGN KEY (created_by) REFERENCES Users(user_id),
    FOREIGN KEY (updated_by) REFERENCES Users(user_id)
);

-- Create Time_Slots table
CREATE TABLE Time_Slots (
    slot_id INT AUTO_INCREMENT PRIMARY KEY,
    applicable_date DATE,
    start_time TIME,
    end_time TIME,
    slot_type VARCHAR(20),
    status VARCHAR(20),
    block_reason VARCHAR(255),
    created_by INT,
    approved_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    FOREIGN KEY (created_by) REFERENCES Users(user_id),
    FOREIGN KEY (approved_by) REFERENCES Users(user_id)
);

-- Create Reviews table
CREATE TABLE Reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    reservation_id INT,
    rating INT,
    comment TEXT,
    status VARCHAR(20),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id)
);

-- Create Restaurant_Info table
CREATE TABLE Restaurant_Info (
    info_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_name VARCHAR(255) NOT NULL,
    address VARCHAR(500),
    contact_phone VARCHAR(20),
    email VARCHAR(255),
    description TEXT,
    open_hours VARCHAR(100),
    banner_image TEXT,
    updated_at DATETIME
);

-- Create Gallery_Images table
CREATE TABLE Gallery_Images (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    image_url VARCHAR(500),
    image_title VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create Promotions table
CREATE TABLE Promotions (
    promotion_id INT AUTO_INCREMENT PRIMARY KEY,
    promotion_name VARCHAR(255),
    description TEXT,
    discount_percentage DECIMAL(5,2),
    discount_amount DECIMAL(18,2),
    start_date DATE,
    end_date DATE,
    status VARCHAR(20),
    created_by INT,
    updated_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    FOREIGN KEY (created_by) REFERENCES Users(user_id),
    FOREIGN KEY (updated_by) REFERENCES Users(user_id)
);

-- Create System_Settings table
CREATE TABLE System_Settings (
    setting_id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) UNIQUE,
    setting_value VARCHAR(255),
    description TEXT,
    updated_at DATETIME,
    updated_by INT,
    FOREIGN KEY (updated_by) REFERENCES Users(user_id)
);

-- Create Email_Verification table
CREATE TABLE Email_Verification (
    verification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    otp_code VARCHAR(6) NOT NULL,
    reset_token VARCHAR(255),
    expiration_time DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Create Indexes for Email_Verification table
CREATE INDEX idx_user_id ON Email_Verification (user_id);
CREATE INDEX idx_otp_code ON Email_Verification (otp_code);
CREATE INDEX idx_reset_token ON Email_Verification (reset_token);
CREATE INDEX idx_expiration_time ON Email_Verification (expiration_time);