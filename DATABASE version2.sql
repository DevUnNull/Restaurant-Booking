CREATE DATABASE IF NOT EXISTS RestaurantBooking;

USE RestaurantBooking;
-- Create Roles table
CREATE TABLE Roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
    );

CREATE TABLE Promotion_Level (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    promotion_level ENUM('1','2','3') NOT NULL,
    description VARCHAR(255)
    );

    -- Create Users table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    role_id INT,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    avatar VARCHAR(500),
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other') DEFAULT 'Other',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    status ENUM('ACTIVE', 'INACTIVE', 'BANNED') DEFAULT 'ACTIVE',
    promotion_level_id int,
    FOREIGN KEY (role_id) REFERENCES Roles(role_id),
    FOREIGN KEY (promotion_level_id) REFERENCES Promotion_Level(category_id)
    );

    -- Create Tables table
CREATE TABLE Tables (
    table_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(100) NOT NULL,
    capacity INT,
    floor INT,
    table_type VARCHAR(100),
    status ENUM('AVAILABLE', 'RESERVED', 'MAINTENANCE') DEFAULT 'AVAILABLE',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME
    );

-- Create table menu_categor
CREATE TABLE menu_category (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
    );

-- Create table BlogCategories
CREATE TABLE BlogCategories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description text ,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_by INT NULL,
    img_url VARCHAR(255) NOT NULL,
    FOREIGN KEY (created_by) REFERENCES Users(user_id)
    );

-- Create Menu_Items table
CREATE TABLE Menu_Items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(255) NOT NULL,
    item_code VARCHAR(50) UNIQUE,
    description TEXT,
    price DECIMAL(18,2),
    image_url VARCHAR(500),
    category_id int,
    calories INT,
    status ENUM('AVAILABLE', 'UNAVAILABLE', 'ARCHIVED') DEFAULT 'AVAILABLE',
    created_by INT,
    updated_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    FOREIGN KEY (created_by) REFERENCES Users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (updated_by) REFERENCES Users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (category_id) REFERENCES menu_category(id) 
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
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_by INT,
    updated_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    FOREIGN KEY (created_by) REFERENCES Users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (updated_by) REFERENCES Users(user_id) ON DELETE SET NULL
    );

-- Create Work_Schedules table
CREATE TABLE Work_Schedules (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    work_date DATE,
    shift VARCHAR(20),
    start_time TIME,
    end_time TIME,
    work_position VARCHAR(100),
    notes TEXT,
    status ENUM('CONFIRMED', 'TENTATIVE', 'CANCELLED') DEFAULT 'TENTATIVE',
    assigned_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_by) REFERENCES Users(user_id) ON DELETE SET NULL
    );

-- Create Time_Slots table
CREATE TABLE Time_Slots (
    slot_id INT AUTO_INCREMENT PRIMARY KEY,
    applicable_date DATE,
    start_time TIME,
    end_time TIME,
    slot_type VARCHAR(20),
    status ENUM('OPEN', 'BLOCKED', 'FULL') DEFAULT 'OPEN',
    block_reason VARCHAR(255),
    created_by INT,
    approved_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    FOREIGN KEY (created_by) REFERENCES Users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (approved_by) REFERENCES Users(user_id) ON DELETE SET NULL
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
    status ENUM('PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED', 'NO_SHOW') DEFAULT 'PENDING',
    total_amount DECIMAL(18,2),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    cancellation_reason VARCHAR(500),
    -- Ghi chú: Nếu một user bị xóa, các lượt đặt bàn của họ sẽ được giữ lại nhưng không còn liên kết (user_id = NULL).
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (table_id) REFERENCES Tables(table_id) ON DELETE SET NULL
    );

-- Create Order_Items table
CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT,
    item_id INT,
    quantity INT,
    unit_price DECIMAL(18,2),
    status ENUM('PENDING', 'PREPARING', 'SERVED', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    special_instructions TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    -- Ghi chú: Nếu một lượt đặt bàn bị xóa, tất cả các món ăn trong đó cũng sẽ bị xóa.
    FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES Menu_Items(item_id) ON DELETE SET NULL
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
    status ENUM('ACTIVE', 'INACTIVE', 'EXPIRED') DEFAULT 'ACTIVE',
    created_by INT,
    updated_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    promotion_level_id int,
    FOREIGN KEY (created_by) REFERENCES Users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (updated_by) REFERENCES Users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (promotion_level_id) REFERENCES Promotion_Level(category_id)
    );

-- Create Payments table
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL, -- Ví dụ: Cash, Credit Card, E-Wallet
    payment_status ENUM('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED') NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    amount BIGINT NOT NULL,
    promotion_id INT,
    transaction_id VARCHAR(100),
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id) ON DELETE CASCADE,
    FOREIGN KEY (promotion_id) REFERENCES Promotions(promotion_id) ON DELETE SET NULL
    );

    -- Indexes for Payments table (Không thay đổi)
    CREATE INDEX idx_reservation_id ON Payments (reservation_id);
    CREATE INDEX idx_promotion_id ON Payments (promotion_id);
    CREATE INDEX idx_payment_status ON Payments (payment_status);
    CREATE INDEX idx_payment_method ON Payments (payment_method);

-- Create Reviews table
CREATE TABLE Reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    reservation_id INT UNIQUE,
    rating INT,
    comment TEXT,
    status ENUM('PENDING_APPROVAL', 'APPROVED', 'REJECTED') DEFAULT 'PENDING_APPROVAL',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id) ON DELETE CASCADE
    );

-- Create Email_Verification table
CREATE TABLE Email_Verification (
    verification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    otp_code VARCHAR(6) NOT NULL,
    reset_token VARCHAR(255),
    expiration_time DATETIME NOT NULL,
    status ENUM('PENDING', 'VERIFIED', 'EXPIRED') DEFAULT 'PENDING',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
    );

    -- Indexes for Email_Verification table
    CREATE INDEX idx_user_id ON Email_Verification (user_id);
    CREATE INDEX idx_otp_code ON Email_Verification (otp_code);
    CREATE INDEX idx_reset_token ON Email_Verification (reset_token);
    CREATE INDEX idx_expiration_time ON Email_Verification (expiration_time);


-- Create System_Settings table
CREATE TABLE System_Settings (
    setting_id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) UNIQUE,
    setting_value VARCHAR(255),
    description TEXT,
    updated_at DATETIME,
    updated_by INT,
    FOREIGN KEY (updated_by) REFERENCES Users(user_id) ON DELETE SET NULL
    );


-- Create table posts
CREATE TABLE posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    content TEXT,
    thumbnail VARCHAR(255),
    category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by int,
    FOREIGN KEY (category_id) REFERENCES BlogCategories(id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)

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


-- Create Report_Statistics table
CREATE TABLE Report_Statistics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_date DATE NOT NULL,
    month INT NOT NULL,
    year INT NOT NULL,
    total_bookings INT DEFAULT 0,
    successful_bookings INT DEFAULT 0,
    cancelled_bookings INT DEFAULT 0,
    total_revenue DECIMAL(15,2) DEFAULT 0,
    UNIQUE(report_date)
    );


    INSERT INTO Roles (role_name) VALUES
    ('ADMIN'),
    ('STAFF'),
    ('CUSTOMER'),
    ('MANAGER');

    INSERT INTO Promotion_Level (promotion_level, description) VALUES
    ('1', 'Khách hàng mới/Cấp độ đồng'),
    ('2', 'Cấp độ bạc'),
    ('3', 'Cấp độ vàng');



    -- Thiết lập biến băm mật khẩu
    SET @admin_pass_hash = '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9';
    SET @manager_pass_hash = '866485796cfa8d7c0cf7111640205b83076433547577511d81f8030ae99ecea5';
    SET @customer_pass_hash = 'a502859c2f527607137f758776384a445e05a103328574136e2f4e857640e797';
    SET @staff_password_hash = '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92';


    INSERT INTO Users (role_id, full_name, email, phone_number, password, status, created_at, updated_at, promotion_level_id) VALUES
    (1, 'System Administrator', 'admin@restaurant.com', '0123456789', @admin_pass_hash, 'ACTIVE', NOW(), NOW(), NULL), 
    (4, 'Restaurant Manager', 'manager@restaurant.com', '0123456788', @manager_pass_hash, 'ACTIVE', NOW(), NOW(), NULL); 

    INSERT INTO Users (role_id, full_name, email, phone_number, password, date_of_birth, gender, status, created_at, updated_at, promotion_level_id) VALUES
    -- Customer Users 
    (3, 'Phạm Thu Hà', 'hapham@email.com', '0981112233', @customer_pass_hash, '1995-05-15', 'Female', 'ACTIVE', NOW(), NOW(), 1),
    (3, 'Hoàng Đức Anh', 'anhhoang@email.com', '0972223344', @customer_pass_hash, '1992-10-20', 'Male', 'ACTIVE', NOW(), NOW(), 2),
    (3, 'Vũ Thị Lan', 'lanvu@email.com', '0963334455', @customer_pass_hash, '1998-01-28', 'Female', 'ACTIVE', NOW(), NOW(), 1),
    (3, 'Đặng Minh Khôi', 'khoidang@email.com', '0954445566', @customer_pass_hash, '2001-03-05', 'Male', 'ACTIVE', NOW(), NOW(), 3),
    (3, 'Bùi Thị Thảo', 'thaobui@email.com', '0945556677', @customer_pass_hash, '1993-07-12', 'Female', 'ACTIVE', NOW(), NOW(), 1),
    (3, 'Trịnh Văn Long', 'longtrinh@email.com', '0936667788', @customer_pass_hash, '1989-11-25', 'Male', 'ACTIVE', NOW(), NOW(), 2),
    (3, 'Hồ Ngọc Mai', 'maiho@email.com', '0927778899', @customer_pass_hash, '2000-08-01', 'Female', 'ACTIVE', NOW(), NOW(), 1),
    (3, 'Ngô Tuấn Kiệt', 'kietngo@email.com', '0918889900', @customer_pass_hash, '1997-04-19', 'Male', 'ACTIVE', NOW(), NOW(), 3),
    (3, 'Đỗ Phương Anh', 'anhdo@email.com', '0909990011', @customer_pass_hash, '1996-02-14', 'Female', 'ACTIVE', NOW(), NOW(), 1),
    (3, 'Phan Thành Trung', 'trungphan@email.com', '0987654321', @customer_pass_hash, '1994-06-30', 'Male', 'ACTIVE', NOW(), NOW(), 2),
    (3, 'Lê Thị Mỹ Anh', 'myanhle@email.com', '0319000011', @customer_pass_hash, '1999-09-09', 'Female', 'ACTIVE', NOW(), NOW(), 1),
    (3, 'Vũ Thành Nam', 'namvu@email.com', '0329000012', @customer_pass_hash, '1991-12-03', 'Male', 'ACTIVE', NOW(), NOW(), 3),
    (3, 'Nguyễn Thanh Tùng', 'tungnguyen@email.com', '0339000013', @customer_pass_hash, '1988-03-22', 'Male', 'ACTIVE', NOW(), NOW(), 1),
    (3, 'Trần Ngọc Bích', 'bichtran@email.com', '0349000014', @customer_pass_hash, '1990-05-18', 'Female', 'ACTIVE', NOW(), NOW(), 2),
    (3, 'Phạm Văn Hòa', 'hoapham@email.com', '0359000015', @customer_pass_hash, '2002-07-07', 'Male', 'ACTIVE', NOW(), NOW(), 1),
    (3, 'Đỗ Minh Quân', 'quando@email.com', '0369000016', @customer_pass_hash, '1995-10-10', 'Male', 'ACTIVE', NOW(), NOW(), 3),
    (3, 'Hoàng Kim Thoa', 'thoahoang@email.com', '0379000017', @customer_pass_hash, '1993-01-29', 'Female', 'ACTIVE', NOW(), NOW(), 1),
    (3, 'Bùi Đình Khoát', 'khoatbui@email.com', '0389000018', @customer_pass_hash, '1997-04-05', 'Male', 'ACTIVE', NOW(), NOW(), 2),
    (3, 'Hồ Ngọc Hà', 'haho@email.com', '0399000019', @customer_pass_hash, '1996-08-16', 'Female', 'ACTIVE', NOW(), NOW(), 1),
    (3, 'Ngô Văn Đức', 'ducngo@email.com', '0309000020', @customer_pass_hash, '1998-11-27', 'Male', 'ACTIVE', NOW(), NOW(), 3),

    -- Staff Users 
    (2, 'Trần Thu Hà', 'hatran@gmail.com', '0121111101', @staff_password_hash, '1987-03-10', 'Female', 'ACTIVE', NOW(), NOW(), NULL),
    (2,'Nguyễn Văn Minh', 'minhnguyen@gmail.com', '0121111102', @staff_password_hash, '1985-06-25', 'Male', 'ACTIVE', NOW(), NOW(), NULL),
    (2, 'Phạm Thị Lan', 'lanpham@gmail.com', '0121111103', @staff_password_hash, '1991-09-05', 'Female', 'ACTIVE', NOW(), NOW(), NULL),
    (2, 'Lê Đức Khoa', 'khoale@gmail.com', '0121111104', @staff_password_hash, '1983-12-08', 'Male', 'ACTIVE', NOW(), NOW(), NULL),
    (2, 'Đỗ Thị Yến', 'yendo@gmail.com', '0121111105', @staff_password_hash, '1990-02-17', 'Female', 'ACTIVE', NOW(), NOW(), NULL),
    (2, 'Hoàng Gia Huy', 'huyhoang@gmail.com', '0121111106', @staff_password_hash, '1986-07-29', 'Male', 'ACTIVE', NOW(), NOW(), NULL),
    (2, 'Nguyễn Thị Trang', 'trangnguyen@gmail.com', '0121111107', @staff_password_hash, '1992-10-14', 'Female', 'ACTIVE', NOW(), NOW(), NULL),
    (2, 'Vũ Đình Long', 'longvu@gmail.com', '0121111108', @staff_password_hash, '1984-01-24', 'Male', 'ACTIVE', NOW(), NOW(), NULL),
    (2, 'Phạm Mai Thủy', 'thuypham@gmail.com', '0121111109', @staff_password_hash, '1993-04-11', 'Female', 'ACTIVE', NOW(), NOW(), NULL),
    (2, 'Trần Quang Duy', 'duytran10@gmail.com', '0121111110', @staff_password_hash, '1988-08-03', 'Male', 'ACTIVE', NOW(), NOW(), NULL),
    (2, 'Bùi Văn Hiệp', 'hiep11@gmail.com', '0121111111', @staff_password_hash, '1982-11-20', 'Male', 'ACTIVE', NOW(), NOW(), NULL),
    (2, 'Nguyễn Thị Mai', 'mai12@gmail.com', '0121111112', @staff_password_hash, '1995-03-01', 'Female', 'ACTIVE', NOW(), NOW(), NULL),
    (2, 'Lê Hữu Cường', 'cuong13@gmail.com', '0121111113', @staff_password_hash, '1989-05-26', 'Male', 'ACTIVE', NOW(), NOW(), NULL),
    (2, 'Đào Hồng Oanh', 'oanh14@gmail.com', '0121111114', @staff_password_hash, '1994-07-17', 'Female', 'INACTIVE', NOW(), NOW(), NULL),
    (2, 'Phạm Trung Giang', 'giang15@gmail.com', '0121111115', @staff_password_hash, '1980-10-06', 'Male', 'INACTIVE', NOW(), NOW(), NULL),
    (2, 'Võ Thị Lệ', 'le18@gmail.com', '0121111118', @staff_password_hash, '1996-01-21', 'Female', 'INACTIVE', NOW(), NOW(), NULL);

    INSERT INTO Tables ( table_name, capacity, floor, table_type, status) VALUES
    ( '101', 4, 1, 'Trong nhà, gần cửa sổ', 'AVAILABLE'),
    ( '102', 2, 1, 'Trong nhà, bàn đôi', 'AVAILABLE'),
    ( '103', 4, 1, 'Trong nhà, khu vực trung tâm', 'AVAILABLE'),
    ( '104 (VIP)', 8, 1, 'Phòng VIP nhỏ (Trong nhà)', 'RESERVED'),
    ( '105', 2, 1, 'Trong nhà, khu vực yên tĩnh', 'AVAILABLE'),
    ( '106 (Góc ấm cúng)', 4, 1, 'Trong nhà, góc ấm cúng', 'AVAILABLE'),
    ( '107 (Lối đi)', 6, 1, 'Trong nhà, gần lối đi', 'MAINTENANCE'),
    ( '108', 4, 1, 'Trong nhà', 'AVAILABLE'),
    ( '109', 2, 1, 'Trong nhà', 'AVAILABLE'),
    ( '110', 4, 1, 'Trong nhà', 'AVAILABLE'),
    ( '111', 10, 1, 'Trong nhà, bàn tròn lớn', 'AVAILABLE'),
    ( '112', 4, 1, 'Trong nhà, gần cửa sổ', 'AVAILABLE'),
    ( '201', 4, 2, 'Trong nhà, gần cửa sổ (Tầng 2)', 'RESERVED'),
    ( '202', 4, 2, 'Trong nhà (Tầng 2)', 'AVAILABLE'),
    ( '203 (View)', 2, 2, 'Trong nhà, cạnh cửa sổ lớn', 'AVAILABLE'),
    ( '204', 6, 2, 'Trong nhà (Tầng 2)', 'AVAILABLE'),
    ( '205', 10, 2, 'Trong nhà, bàn tròn lớn (Tầng 2)', 'AVAILABLE'),
    ( '206', 4, 2, 'Trong nhà (Tầng 2)', 'AVAILABLE'),
    ( '207 (VIP Lớn)', 16, 2, 'Phòng VIP lớn, view thành phố (Trong nhà)', 'AVAILABLE'),
    ( '208 (View)', 2, 2, 'Trong nhà, cạnh cửa sổ lớn', 'AVAILABLE'),
    ( '209', 4, 2, 'Trong nhà (Tầng 2)', 'AVAILABLE'),
    ( '210', 4, 2, 'Trong nhà (Tầng 2)', 'AVAILABLE'),
    ( '211', 2, 2, 'Trong nhà (Tầng 2)', 'AVAILABLE'),
    ( '212', 8, 2, 'Trong nhà, gần quầy bar (Tầng 2)', 'AVAILABLE'),
    ( '301', 4, 3, 'Trong nhà, view đẹp (Tầng 3)', 'AVAILABLE'),
    ( '302', 2, 3, 'Trong nhà, bàn đôi (Tầng 3)', 'AVAILABLE'),
    ( '303', 6, 3, 'Trong nhà (Tầng 3)', 'AVAILABLE'),
    ( '304 (View)', 4, 3, 'Trong nhà, cạnh cửa sổ lớn', 'AVAILABLE'),
    ( '305', 4, 3, 'Trong nhà (Tầng 3)', 'AVAILABLE'),
    ( '306', 8, 3, 'Trong nhà, bàn lớn (Tầng 3)', 'AVAILABLE'),
    ( '307', 2, 3, 'Trong nhà (Tầng 3)', 'AVAILABLE'),
    ( '308', 4, 3, 'Trong nhà, gần cửa sổ (Tầng 3)', 'AVAILABLE'),
    ( '309', 4, 3, 'Trong nhà (Tầng 3)', 'AVAILABLE'),
    ( '310', 2, 3, 'Trong nhà (Tầng 3)', 'AVAILABLE'),
    ( '311', 6, 3, 'Trong nhà (Tầng 3)', 'AVAILABLE'),
    ( '312', 4, 3, 'Trong nhà, góc yên tĩnh (Tầng 3)', 'AVAILABLE'),
    ( '401 (VIP Đôi)', 2, 4, 'Phòng VIP cho cặp đôi (Trong nhà)', 'AVAILABLE'),
    ( '402', 4, 4, 'Trong nhà, view toàn cảnh (Tầng 4)', 'AVAILABLE'),
    ( '403', 4, 4, 'Trong nhà (Tầng 4)', 'AVAILABLE'),
    ( '404', 2, 4, 'Trong nhà (Tầng 4)', 'AVAILABLE'),
    ( '405', 6, 4, 'Trong nhà (Tầng 4)', 'AVAILABLE'),
    ( '406', 4, 4, 'Trong nhà (Tầng 4)', 'AVAILABLE'),
    ( '407', 8, 4, 'Trong nhà, bàn lớn (Tầng 4)', 'AVAILABLE'),
    ( '408', 4, 4, 'Trong nhà (Tầng 4)', 'AVAILABLE'),
    ( '409', 2, 4, 'Trong nhà (Tầng 4)', 'AVAILABLE'),
    ( '410', 4, 4, 'Trong nhà (Tầng 4)', 'AVAILABLE'),
    ( '411', 12, 4, 'Trong nhà, bàn tiệc lớn (Tầng 4)', 'AVAILABLE'),
    ( '412', 4, 4, 'Trong nhà, gần cửa sổ (Tầng 4)', 'AVAILABLE');


    INSERT INTO menu_category ( name) VALUES
    ( 'Khai Vị'), 
    ( 'Gỏi'), 
    ( 'Món Chính'), 
    ( 'Cơm / Bún / Mì'), 
    ( 'Lẩu'), 
    ( 'Tráng Miệng'), 
    ( 'Đồ Uống'), 
    (' HẢI'), 
    (' Việt'); 

    INSERT INTO Reservations (user_id, table_id, reservation_date, reservation_time, guest_count, special_requests, status, total_amount, cancellation_reason, created_at, updated_at) VALUES
    (4, 1, '2025-06-05', '19:00:00', 4, NULL, 'COMPLETED', 950000.00, NULL, '2025-06-01 10:00:00', '2025-06-05 20:30:00'),
    (5, 2, '2025-06-10', '20:30:00', 2, 'Bàn ngoài trời N-01', 'COMPLETED', 620000.00, NULL, '2025-06-05 15:00:00', '2025-06-10 22:00:00'),
    (6, 6, '2025-06-12', '12:00:00', 3, NULL, 'COMPLETED', 450000.00, NULL, '2025-06-11 08:00:00', '2025-06-12 13:30:00'),
    (7, 4, '2025-06-15', '18:00:00', 6, 'Phòng VIP', 'CANCELLED', NULL, 'Kế hoạch kinh doanh bị hoãn', '2025-06-10 11:00:00', '2025-06-13 14:00:00'),
    (8, 17, '2025-06-18', '19:30:00', 5, 'Bàn tròn lớn', 'COMPLETED', 1300000.00, NULL, '2025-06-15 16:00:00', '2025-06-18 21:00:00'),
    (9, 2, '2025-06-20', '20:00:00', 2, NULL, 'COMPLETED', 700000.00, NULL, '2025-06-16 12:00:00', '2025-06-20 21:45:00'),
    (10, 15, '2025-06-23', '11:30:00', 2, 'Bàn ban công', 'COMPLETED', 580000.00, NULL, '2025-06-22 09:00:00', '2025-06-23 13:00:00'),
    (11, 13, '2025-06-25', '19:00:00', 3, NULL, 'NO_SHOW', NULL, NULL, '2025-06-20 18:00:00', '2025-06-25 23:59:59'),
    (12, 1, '2025-06-28', '18:30:00', 4, 'Yêu cầu không có hải sản trong món ăn.', 'COMPLETED', 1100000.00, NULL, '2025-06-24 13:00:00', '2025-06-28 20:45:00'),
    (13, 7, '2025-06-30', '19:45:00', 6, NULL, 'COMPLETED', 1500000.00, NULL, '2025-06-26 17:00:00', '2025-06-30 21:30:00'),
    (5, 17, '2025-07-03', '19:00:00', 4, 'Ghế cao cho em bé.', 'COMPLETED', 1050000.00, NULL, '2025-06-28 11:00:00', '2025-07-03 21:00:00'),
    (4, 2, '2025-07-07', '20:00:00', 2, NULL, 'COMPLETED', 580000.00, NULL, '2025-07-01 09:00:00', '2025-07-07 21:30:00'),
    (7, 1, '2025-07-10', '12:30:00', 3, NULL, 'COMPLETED', 400000.00, NULL, '2025-07-08 15:00:00', '2025-07-10 14:00:00'),
    (8, 4, '2025-07-13', '18:30:00', 8, 'Phòng VIP T1-03', 'COMPLETED', 2500000.00, NULL, '2025-07-05 14:00:00', '2025-07-13 21:00:00'),
    (9, 15, '2025-07-15', '20:30:00', 2, 'Bàn ban công', 'COMPLETED', 750000.00, NULL, '2025-07-10 10:00:00', '2025-07-15 22:00:00'),
    (10, 13, '2025-07-18', '19:00:00', 4, NULL, 'COMPLETED', 1200000.00, NULL, '2025-07-14 16:00:00', '2025-07-18 20:30:00'),
    (11, 1, '2025-07-20', '19:30:00', 5, NULL, 'COMPLETED', 1100000.00, NULL, '2025-07-15 11:00:00', '2025-07-20 21:00:00'),
    (6, 6, '2025-07-22', '18:00:00', 4, NULL, 'CANCELLED', NULL, 'Tìm được địa điểm khác.', '2025-07-16 13:00:00', '2025-07-18 10:00:00'),
    (13, 2, '2025-07-24', '20:00:00', 2, NULL, 'COMPLETED', 650000.00, NULL, '2025-07-20 17:00:00', '2025-07-24 21:30:00'),
    (12, 17, '2025-07-26', '19:00:00', 5, 'Bàn gần khu vực nhạc sống.', 'COMPLETED', 1400000.00, NULL, '2025-07-21 12:00:00', '2025-07-26 21:00:00'),
    (4, 6, '2025-07-28', '18:30:00', 3, 'Bàn ngoài trời N-01', 'COMPLETED', 850000.00, NULL, '2025-07-25 15:00:00', '2025-07-28 20:30:00'),
    (5, 1, '2025-07-29', '20:00:00', 2, 'Trang trí hoa đơn giản.', 'COMPLETED', 720000.00, NULL, '2025-07-25 10:00:00', '2025-07-29 21:45:00'),
    (8, 13, '2025-07-30', '19:30:00', 4, NULL, 'COMPLETED', 980000.00, NULL, '2025-07-25 16:00:00', '2025-07-30 21:30:00'),
    (10, 2, '2025-07-31', '19:00:00', 2, NULL, 'NO_SHOW', NULL, NULL, '2025-07-28 11:00:00', '2025-07-31 23:59:59'),
    (9, 19, '2025-07-31', '18:00:00', 10, 'Phòng T2-VIP cho họp mặt bạn bè.', 'COMPLETED', 3500000.00, NULL, '2025-07-25 09:00:00', '2025-07-31 22:00:00'),
    (4, 2, '2025-08-10', '19:30:00', 2, 'Bàn khu vực yên tĩnh.', 'COMPLETED', 550000.00, NULL, '2025-08-05 10:00:00', '2025-08-10 21:00:00'),
    (7, 17, '2025-08-12', '19:00:00', 5, NULL, 'COMPLETED', 1250000.00, NULL, '2025-08-07 14:00:00', '2025-08-12 21:00:00'),
    (6, 1, '2025-08-15', '12:00:00', 3, NULL, 'COMPLETED', 480000.00, NULL, '2025-08-14 09:30:00', '2025-08-15 13:30:00'),
    (8, 17, '2025-08-20', '18:00:00', 8, 'Cần 2 ghế ăn cho trẻ em.', 'COMPLETED', 1850000.00, NULL, '2025-08-16 14:00:00', '2025-08-20 20:00:00'),
    (11, 6, '2025-08-22', '20:30:00', 2, NULL, 'COMPLETED', 780000.00, NULL, '2025-08-18 10:00:00', '2025-08-22 22:00:00'),
    (13, 1, '2025-08-25', '19:00:00', 4, NULL, 'COMPLETED', 1100000.00, NULL, '2025-08-20 17:00:00', '2025-08-25 21:00:00'),
    (5, 4, '2025-08-27', '18:30:00', 6, 'Phòng riêng', 'CANCELLED', NULL, 'Sự kiện bị hủy', '2025-08-20 11:00:00', '2025-08-25 09:00:00'),
    (10, 15, '2025-08-28', '20:00:00', 2, 'Bàn ban công', 'COMPLETED', 600000.00, NULL, '2025-08-25 15:00:00', '2025-08-28 21:30:00'),
    (12, 2, '2025-08-30', '19:00:00', 2, 'Bữa tối lãng mạn.', 'COMPLETED', 880000.00, NULL, '2025-08-25 12:00:00', '2025-08-30 21:00:00'),
    (9, 1, '2025-08-31', '12:30:00', 3, NULL, 'COMPLETED', 450000.00, NULL, '2025-08-28 10:00:00', '2025-08-31 14:00:00'),
    (5, 6, '2025-09-02', '19:00:00', 2, 'Trang trí hoa hồng.', 'NO_SHOW', NULL, NULL, '2025-08-28 11:00:00', '2025-09-02 23:59:59'),
    (9, 15, '2025-09-08', '20:30:00', 2, 'Bánh kem nhỏ cho 2 người.', 'COMPLETED', 920000.00, NULL, '2025-09-01 15:00:00', '2025-09-08 22:00:00'),
    (10, 4, '2025-09-15', '11:30:00', 4, 'Yêu cầu phòng riêng nếu T3-VIP sẵn.', 'COMPLETED', 1300000.00, NULL, '2025-09-10 08:00:00', '2025-09-15 13:30:00'),
    (7, 1, '2025-09-25', '18:30:00', 3, NULL, 'CANCELLED', NULL, 'Bị bệnh đột xuất.', '2025-09-20 17:00:00', '2025-09-24 23:00:00'),
    (8, 2, '2025-09-28', '20:00:00', 2, NULL, 'COMPLETED', 650000.00, NULL, '2025-09-24 10:00:00', '2025-09-28 21:30:00'),
    (11, 17, '2025-09-30', '19:00:00', 5, 'Bàn T2-02 (bàn tròn)', 'COMPLETED', 1350000.00, NULL, '2025-09-25 14:00:00', '2025-09-30 21:00:00'),
    (4, 1, '2025-10-05', '19:00:00', 4, 'Bàn gần cửa sổ nếu có thể', 'COMPLETED', 1150000.00, NULL, '2025-09-29 11:30:00', '2025-10-05 20:45:00'),
    (7, 6, '2025-10-10', '18:30:00', 3, NULL, 'NO_SHOW', NULL, NULL, '2025-10-04 15:00:00', '2025-10-10 23:59:59'),
    (9, 2, '2025-10-11', '20:30:00', 2, 'Bàn ở khu vực quầy bar', 'COMPLETED', 750000.00, NULL, '2025-10-07 19:00:00', '2025-10-11 22:00:00'),
    (5, 2, '2025-10-18', '20:00:00', 2, 'Trang trí lãng mạn cho 2 người', 'CONFIRMED', NULL, NULL, '2025-10-12 10:00:00', NULL),
    (11, 1, '2025-10-19', '18:30:00', 5, 'Bàn rộng rãi cho 5 người.', 'CONFIRMED', NULL, NULL, '2025-10-13 09:00:00', NULL),
    (6, 7, '2025-10-20', '19:30:00', 5, NULL, 'CANCELLED', NULL, 'Thay đổi kế hoạch đột xuất', '2025-10-15 12:00:00', '2025-10-16 08:00:00'),
    (8, 19, '2025-10-22', '18:00:00', 8, 'Chuẩn bị phòng VIP cho tiệc sinh nhật', 'CONFIRMED', NULL, NULL, '2025-10-01 10:00:00', NULL),
    (10, 15, '2025-10-23', '20:00:00', 2, 'Bàn ban công BC-01 nếu thời tiết đẹp.', 'CONFIRMED', NULL, NULL, '2025-10-10 10:00:00', NULL),
    (4, 17, '2025-10-25', '19:00:00', 3, 'Cần 1 ghế ăn cho trẻ em', 'CONFIRMED', NULL, NULL, '2025-10-18 16:00:00', NULL),
    (14, 4, '2025-10-27', '19:30:00', 4, 'Bàn khu vực yên tĩnh', 'COMPLETED', 890000.00, NULL, '2025-10-20 15:00:00', '2025-10-27 21:00:00'),
    (15, 13, '2025-11-05', '18:00:00', 3, NULL, 'CONFIRMED', NULL, NULL, '2025-10-25 10:00:00', NULL),
    (16, 1, '2025-11-10', '12:00:00', 2, NULL, 'CANCELLED', NULL, 'Thay đổi kế hoạch công việc.', '2025-10-28 09:00:00', '2025-10-30 14:00:00'),
    (17, 15, '2025-11-15', '20:00:00', 2, 'Bàn ban công', 'COMPLETED', 680000.00, NULL, '2025-11-01 16:00:00', '2025-11-15 21:30:00'),
    (18, 7, '2025-11-20', '19:00:00', 5, 'Yêu cầu phòng riêng', 'NO_SHOW', NULL, NULL, '2025-11-10 12:00:00', '2025-11-20 23:59:59'),
    (19, 2, '2025-11-25', '18:30:00', 3, NULL, 'COMPLETED', 770000.00, NULL, '2025-11-15 14:00:00', '2025-11-25 20:30:00'),
    (20, 17, '2025-11-29', '20:30:00', 4, 'Trang trí tiệc nhỏ', 'CONFIRMED', NULL, NULL, '2025-11-20 11:00:00', NULL),
    (21, 6, '2025-12-05', '12:30:00', 6, NULL, 'COMPLETED', 1500000.00, NULL, '2025-11-28 08:00:00', '2025-12-05 14:30:00'),
    (22, 1, '2025-12-10', '19:00:00', 2, 'Gần cửa sổ', 'CONFIRMED', NULL, NULL, '2025-12-01 17:00:00', NULL),
    (23, 19, '2025-12-15', '19:30:00', 10, 'Phòng T2-VIP', 'COMPLETED', 3800000.00, NULL, '2025-12-05 10:00:00', '2025-12-15 22:30:00');


INSERT INTO Menu_Items (item_name, item_code, description, price, image_url, category_id, calories, status, created_by, updated_by, created_at, updated_at) VALUES
-- KHAI VỊ (APPETIZERS)
('Gỏi Tôm Thái', 'KV001', 'Gỏi tôm kiểu Thái chua cay', 120000.00, NULL, 1, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Chả Giò Rế Hải Sản', 'KV010', 'Chả giò giòn rụm với nhân hải sản tươi ngon', 95000.00, NULL, 1, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Gỏi Cuốn Tôm Thịt', 'KV011', 'Gỏi cuốn truyền thống với tôm, thịt, bún và rau thơm', 75000.00, NULL, 1, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Nem Nướng Nha Trang', 'KV012', 'Nem nướng thơm lừng ăn kèm bánh tráng và rau sống', 125000.00, NULL, 1, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Chạo Tôm Bọc Mía', 'KV013', 'Tôm xay nhuyễn bọc quanh thân mía ngọt', 135000.00, NULL, 1, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Đậu Hũ Chiên Sả Ớt', 'KV014', 'Đậu hũ non chiên vàng giòn, thơm mùi sả ớt', 65000.00, NULL, 1, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),

-- GỎI (SALADS)
('Gỏi Ngó Sen Tôm Thịt', 'GOI010', 'Gỏi ngó sen giòn mát kết hợp với tôm sú và thịt ba rọi', 145000.00, NULL, 2, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Gỏi Xoài Xanh Hải Sản', 'GOI011', 'Gỏi xoài xanh chua ngọt cùng mực và tôm', 155000.00, NULL, 2, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Nộm Bò Bóp Thấu', 'GOI012', 'Thịt bò tái chanh trộn cùng hành tây, khế chua và rau thơm', 160000.00, NULL, 2, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Gỏi Gà Xé Phay', 'GOI013', 'Thịt gà ta xé nhỏ trộn với hành tây, rau răm', 135000.00, NULL, 2, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Gỏi Sứa Đu đủ', 'GOI014', 'Sứa giòn sần sật trộn với đu đủ bào sợi', 120000.00, NULL, 2, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),

-- MÓN CHÍNH (MAIN COURSES)
('Sườn Non Nướng Mật Ong', 'MC-H010', 'Sườn non mềm ngọt, thấm vị mật ong nướng trên than hồng', 185000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Thịt Kho Tộ', 'MC-H011', 'Thịt ba rọi kho trong tộ đất theo kiểu truyền thống', 125000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Ba Rọi Chiên Giòn Sốt Mắm Tỏi', 'MC-H012', 'Thịt ba rọi chiên giòn rụm, áo lớp sốt mắm tỏi đậm đà', 155000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Heo Quay Chảo', 'MC-H013', 'Thịt heo quay với lớp da giòn tan, thịt mềm mọng nước', 195000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Bún Chả Hà Nội', 'MC-H014', 'Chả viên và chả miếng nướng than hoa ăn cùng bún và nước mắm chua ngọt', 85000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Bò Bít Tết', 'MC001', 'Bò bít tết phục vụ với khoai tây chiên và salad', 250000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Bò Lúc Lắc Khoai Tây Chiên', 'MC-B010', 'Thịt bò thái hạt lựu xào nhanh trên lửa lớn', 195000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Bò Cuốn Lá Lốt', 'MC-B011', 'Thịt bò băm nướng trong lá lốt thơm lừng', 145000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Phở Bò Đặc Biệt', 'MC-B012', 'Phở bò với đầy đủ tái, nạm, gầu, gân, sách', 90000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Bún Bò Huế', 'MC-B013', 'Bún bò chuẩn vị Huế với giò heo, chả cua, tiết', 85000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Bò Nhúng Dấm', 'MC-B014', 'Set bò nhúng dấm ăn kèm rau sống và bún', 280000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Bò Kho Bánh Mì', 'MC-B015', 'Bò hầm mềm rục, đậm đà gia vị, ăn kèm bánh mì nóng giòn', 95000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Gà Nướng Mắc Khén', 'MC-G010', 'Gà ta nướng cùng hạt mắc khén Tây Bắc', 350000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Gà Hấp Lá Chanh', 'MC-G011', 'Gà ta hấp giữ trọn vị ngọt, thơm mùi lá chanh', 320000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Cánh Gà Chiên Nước Mắm', 'MC-G012', 'Cánh gà chiên vàng giòn, sốt nước mắm tỏi ớt', 125000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Cơm Gà Hội An', 'MC-G013', 'Cơm nấu nước luộc gà, ăn kèm gà xé và rau răm', 85000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Gà Xào Sả Ớt', 'MC-G014', 'Thịt gà xào săn chắc, cay nồng vị sả ớt', 145000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Mì Ý Hải Sản', 'MC002', 'Mì Ý sốt cà chua với tôm và mực', 180000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Cua Rang Me', 'MC-HS010', 'Cua thịt chắc ngọt sốt me chua chua ngọt ngọt', 450000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Tôm Sú Hấp Bia', 'MC-HS011', 'Tôm sú tươi sống hấp với bia và sả', 250000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Mực Một Nắng Nướng Sa Tế', 'MC-HS012', 'Mực một nắng dai ngọt, nướng cay thơm', 280000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Cá Diêu Hồng Chiên Xù', 'MC-HS013', 'Cá diêu hồng chiên giòn, ăn kèm bánh tráng và rau sống', 190000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Nghêu Hấp Thái', 'MC-HS014', 'Nghêu tươi hấp kiểu Thái chua cay', 120000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Hàu Nướng Mỡ Hành', 'MC-HS015', 'Hàu sữa béo ngậy nướng với mỡ hành và đậu phộng', 150000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Cháo Hàu Sữa', 'MC-HS016', 'Cháo trắng nấu với hàu sữa và nấm rơm', 85000.00, NULL, 3, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),

-- CƠM / BÚN / MÌ
('Cơm Tấm Sườn Bì Chả', 'COM010', 'Dĩa cơm tấm đầy đủ sườn nướng, bì, chả trứng', 75000.00, NULL, 4, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Cơm Chiên Hải Sản', 'COM011', 'Cơm chiên với tôm, mực và rau củ', 95000.00, NULL, 4, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Mì Xào Bò Rau Cải', 'MI010', 'Mì trứng xào với thịt bò mềm và rau cải ngọt', 90000.00, NULL, 4, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Bún Thịt Nướng Chả Giò', 'BUN010', 'Bún tươi ăn kèm thịt nướng, chả giò, rau sống và nước mắm', 80000.00, NULL, 4, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),

-- LẨU (HOT POT)
('Lẩu Hải Sản', 'L001', 'Lẩu thập cẩm với các loại hải sản tươi sống', 450000.00, NULL, 5, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Lẩu Thái Tomyum Hải Sản', 'LAU010', 'Nước lẩu Thái chua cay, ăn kèm tôm, mực, nghêu, cá và rau', 480000.00, NULL, 5, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Lẩu Riêu Cua Bắp Bò Sườn Sụn', 'LAU011', 'Lẩu riêu cua đồng ngọt thanh, ăn kèm bắp bò và sườn sụn', 450000.00, NULL, 5, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Lẩu Nấm Thiên Nhiên', 'LAU012', 'Nước lẩu ngọt từ xương hầm và các loại nấm bổ dưỡng', 380000.00, NULL, 5, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),

-- TRÁNG MIỆNG (DESSERTS)
('Kem Vani Dâu', 'TD001', 'Kem viên vị vani và dâu', 50000.00, NULL, 6, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Chè Hạt Sen Long Nhãn', 'TM010', 'Chè hạt sen bùi bùi và long nhãn ngọt thanh', 45000.00, NULL, 6, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Bánh Flan Caramel', 'TM011', 'Bánh flan mềm mịn, béo ngậy vị trứng sữa', 35000.00, NULL, 6, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Rau Câu Dừa', 'TM012', 'Rau câu làm từ nước dừa tươi mát lạnh', 30000.00, NULL, 6, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Trái Cây Theo Mùa', 'TM013', 'Dĩa trái cây tươi ngon theo mùa', 70000.00, NULL, 6, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Sữa Chua Nếp Cẩm', 'TM014', 'Sữa chua sánh mịn ăn kèm nếp cẩm dẻo thơm', 40000.00, NULL, 6, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),

-- ĐỒ UỐNG (BEVERAGES)
('Trà Đào Cam Sả', 'NU001', 'Trà đào kết hợp với vị thơm của cam và sả', 45000.00, NULL, 7, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Nước Suối', 'NU002', 'Nước khoáng tinh khiết', 20000.00, NULL, 7, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Coca-Cola', 'DU011', NULL, 25000.00, NULL, 7, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('7 Up', 'DU012', NULL, 25000.00, NULL, 7, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Pepsi', 'DU013', NULL, 25000.00, NULL, 7, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Red Bull', 'DU014', NULL, 30000.00, NULL, 7, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Nước Cam Vắt', 'DU015', NULL, 50000.00, NULL, 7, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Nước Chanh', 'DU016', NULL, 40000.00, NULL, 7, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Nước Dừa Tươi', 'DU017', NULL, 45000.00, NULL, 7, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Sinh Tố Bơ', 'DU018', NULL, 55000.00, NULL, 7, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Sinh Tố Xoài', 'DU019', NULL, 55000.00, NULL, 7, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Cà Phê Sữa Đá', 'DU020', NULL, 40000.00, NULL, 7, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Cà Phê Đen Đá', 'DU021', NULL, 35000.00, NULL, 7, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Trà Đá', 'DU022', NULL, 5000.00, NULL, 7, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Trà Lipton', 'DU023', NULL, 30000.00, NULL, 7, NULL, 'AVAILABLE', 2, 2, NOW(), NOW()),
('Bia Tiger', 'DU030', NULL, 25000.00, NULL, 7, NULL, 'AVAILABLE', 2,2, NOW(), NOW());


INSERT INTO Order_Items (reservation_id, item_id, quantity, unit_price, status, special_instructions) VALUES
(1, 19, 1, 185000.00, 'SERVED', NULL), 
(1, 40, 1, 190000.00, 'SERVED', NULL), 
(1, 51, 1, 450000.00, 'SERVED', NULL), 
(1, 60, 2, 45000.00, 'SERVED', NULL), 
(1, 54, 2, 25000.00, 'SERVED', NULL), 
(2, 33, 1, 145000.00, 'SERVED', NULL), 
(2, 45, 1, 75000.00, 'SERVED', NULL), 
(2, 63, 1, 50000.00, 'SERVED', NULL), 
(2, 59, 2, 55000.00, 'SERVED', 'Không đường'), 
(2, 60, 2, 45000.00, 'SERVED', NULL), 
(3, 13, 1, 145000.00, 'SERVED', NULL), 
(3, 20, 1, 125000.00, 'PREPARING', 'Ít mắm'), 
(3, 46, 1, 45000.00, 'SERVED', NULL), 
(3, 52, 2, 25000.00, 'SERVED', NULL), 
(3, 53, 2, 25000.00, 'PREPARING', NULL), 
(4, 17, 1, 195000.00, 'SERVED', NULL), 
(4, 40, 1, 190000.00, 'SERVED', NULL), 
(4, 60, 4, 45000.00, 'SERVED', NULL), 
(5, 21, 1, 280000.00, 'SERVED', NULL), 
(5, 23, 1, 350000.00, 'PREPARING', NULL), 
(5, 37, 1, 75000.00, 'SERVED', NULL), 
(5, 41, 1, 480000.00, 'SERVED', NULL), 
(5, 52, 4, 25000.00, 'SERVED', NULL), 
(6, 40, 1, 190000.00, 'SERVED', NULL), 
(6, 42, 1, 150000.00, 'CANCELLED', NULL), 
(6, 46, 1, 80000.00, 'SERVED', NULL), 
(6, 48, 2, 50000.00, 'SERVED', NULL), 
(6, 60, 2, 45000.00, 'SERVED', NULL), 
(6, 54, 2, 28000.00, 'SERVED', NULL), 
(6, 51, 2, 20000.00, 'SERVED', NULL), 
(7, 31, 1, 280000.00, 'PREPARING', 'Không cay'), 
(7, 4, 1, 75000.00, 'SERVED', NULL), 
(7, 59, 2, 55000.00, 'SERVED', NULL), 
(7, 54, 4, 25000.00, 'SERVED', NULL), 
(8, 43, 1, 380000.00, 'SERVED', 'Ít cay'), 
(8, 21, 1, 280000.00, 'SERVED', NULL), 
(8, 52, 2, 25000.00, 'SERVED', NULL), 
(8, 53, 2, 25000.00, 'SERVED', NULL), 
(9, 16, 1, 250000.00, 'SERVED', 'Thịt chín kỹ'), 
(9, 24, 1, 320000.00, 'SERVED', NULL), 
(9, 33, 1, 120000.00, 'SERVED', NULL), 
(9, 42, 1, 450000.00, 'PREPARING', 'Ít riêu cua'), 
(10, 12, 1, 155000.00, 'SERVED', NULL), 
(10, 31, 1, 280000.00, 'SERVED', 'Rất cay'), 
(10, 38, 1, 95000.00, 'SERVED', NULL), 
(10, 41, 1, 480000.00, 'SERVED', 'Bỏ tôm'), 
(10, 54, 8, 28000.00, 'SERVED', NULL), 
(11, 14, 1, 195000.00, 'SERVED', NULL), 
(11, 17, 1, 195000.00, 'PREPARING', NULL), 
(11, 25, 1, 125000.00, 'SERVED', NULL), 
(11, 36, 1, 75000.00, 'SERVED', NULL),
(11, 48, 1, 70000.00, 'PENDING', NULL), 
(11, 53, 8, 25000.00, 'SERVED', NULL), 
(12, 10, 1, 155000.00, 'SERVED', NULL), 
(12, 39, 1, 90000.00, 'SERVED', NULL), 
(12, 60, 2, 45000.00, 'SERVED', NULL), 
(12, 56, 4, 50000.00, 'PREPARING', NULL), 
(13, 20, 1, 125000.00, 'CANCELLED', NULL), 
(13, 17, 1, 195000.00, 'SERVED', NULL), 
(13, 51, 2, 20000.00, 'SERVED', NULL), 
(13, 52, 2, 25000.00, 'SERVED', NULL),
(14, 14, 1, 195000.00, 'SERVED', NULL), 
(14, 21, 1, 280000.00, 'SERVED', NULL), 
(14, 23, 1, 350000.00, 'SERVED', NULL), 
(14, 46, 2, 80000.00, 'SERVED', NULL), 
(14, 41, 1, 480000.00, 'PREPARING', 'Thêm nấm'), 
(14, 54, 10, 28000.00, 'SERVED', NULL), 
(14, 60, 5, 45000.00, 'SERVED', NULL), 
(15, 8, 1, 160000.00, 'SERVED', NULL), 
(15, 22, 1, 95000.00, 'SERVED', NULL), 
(15, 33, 1, 120000.00, 'SERVED', NULL), 
(15, 43, 1, 80000.00, 'SERVED', NULL), 
(15, 60, 1, 45000.00, 'SERVED', NULL), 
(15, 54, 8, 28000.00, 'SERVED', NULL), 
(16, 19, 1, 90000.00, 'SERVED', NULL), 
(16, 24, 1, 320000.00, 'SERVED', NULL), 
(16, 38, 1, 95000.00, 'PENDING', NULL), 
(16, 43, 1, 380000.00, 'SERVED', NULL), 
(16, 54, 4, 25000.00, 'SERVED', NULL), 
(16, 56, 2, 50000.00, 'PREPARING', NULL),
(17, 16, 1, 250000.00, 'SERVED', 'Medium Rare'), 
(17, 33, 1, 145000.00, 'SERVED', NULL), 
(17, 35, 1, 85000.00, 'SERVED', NULL), 
(17, 40, 1, 450000.00, 'SERVED', NULL), 
(17, 53, 6, 25000.00, 'SERVED', NULL), 
(18, 10, 1, 155000.00, 'SERVED', NULL), 
(18, 17, 1, 195000.00, 'SERVED', NULL), 
(18, 46, 1, 45000.00, 'SERVED', NULL), 
(18, 60, 2, 45000.00, 'SERVED', NULL), 
(19, 13, 1, 145000.00, 'SERVED', NULL), 
(19, 20, 1, 125000.00, 'PREPARING', NULL), 
(19, 60, 4, 45000.00, 'SERVED', NULL), 
(19, 57, 3, 45000.00, 'SERVED', NULL), 
(20, 17, 1, 195000.00, 'PENDING', NULL), 
(20, 31, 1, 280000.00, 'PREPARING', NULL), 
(20, 45, 2, 75000.00, 'SERVED', NULL), 
(20, 42, 1, 450000.00, 'SERVED', NULL), 
(20, 54, 6, 28000.00, 'SERVED', NULL), 
(21, 8, 1, 160000.00, 'SERVED', NULL), 
(21, 25, 1, 125000.00, 'SERVED', 'Không ớt'), 
(21, 36, 1, 75000.00, 'SERVED', NULL), 
(21, 60, 2, 45000.00, 'SERVED', NULL), 
(21, 59, 3, 55000.00, 'PREPARING', NULL), 
(21, 60, 3, 55000.00, 'SERVED', NULL), 
(22, 11, 1, 185000.00, 'SERVED', NULL), 
(22, 42, 1, 150000.00, 'SERVED', NULL), 
(22, 46, 1, 80000.00, 'SERVED', NULL),
(22, 60, 2, 45000.00, 'SERVED', NULL),
(22, 54, 5, 28000.00, 'SERVED', NULL), 
(23, 17, 1, 195000.00, 'SERVED', NULL), 
(23, 40, 1, 190000.00, 'SERVED', NULL), 
(23, 42, 1, 450000.00, 'PREPARING', NULL),
(23, 52, 2, 25000.00, 'SERVED', NULL),
(23, 51, 4, 20000.00, 'SERVED', NULL), 
(24, 7, 1, 145000.00, 'PENDING', NULL), 
(24, 39, 1, 90000.00, 'SERVED', NULL),
(24, 54, 2, 25000.00, 'SERVED', NULL), 
(25, 21, 1, 280000.00, 'SERVED', NULL),
(25, 23, 1, 350000.00, 'SERVED', NULL), 
(25, 24, 1, 320000.00, 'SERVED', NULL),
(25, 45, 4, 75000.00, 'SERVED', NULL), 
(25, 41, 1, 480000.00, 'PREPARING', NULL), 
(25, 43, 1, 380000.00, 'SERVED', NULL), 
(25, 54, 10, 28000.00, 'SERVED', NULL), 
(25, 60, 5, 45000.00, 'SERVED', NULL), 
(26, 10, 1, 120000.00, 'SERVED', NULL), 
(26, 42, 1, 150000.00, 'SERVED', NULL), 
(26, 60, 2, 45000.00, 'SERVED', NULL), 
(26, 56, 4, 50000.00, 'PREPARING', NULL), 
(27, 16, 1, 250000.00, 'SERVED', 'Tái vừa'),
(27, 21, 1, 280000.00, 'SERVED', NULL), 
(27, 25, 1, 125000.00, 'SERVED', NULL), 
(27, 42, 1, 450000.00, 'SERVED', NULL),
(27, 52, 2, 25000.00, 'SERVED', NULL), 
(27, 53, 2, 25000.00, 'SERVED', NULL), 
(28, 20, 1, 125000.00, 'SERVED', NULL), 
(28, 22, 1, 95000.00, 'SERVED', NULL), 
(28, 52, 2, 25000.00, 'SERVED', NULL), 
(28, 57, 2, 45000.00, 'PREPARING', NULL), 
(28, 57, 2, 40000.00, 'SERVED', NULL), 
(29, 23, 1, 350000.00, 'SERVED', NULL), 
(29, 31, 1, 280000.00, 'SERVED', NULL), 
(29, 33, 1, 120000.00, 'SERVED', NULL),
(29, 45, 2, 75000.00, 'SERVED', NULL), 
(29, 41, 1, 480000.00, 'SERVED', NULL), 
(29, 54, 10, 28000.00, 'SERVED', NULL), 
(29, 52, 2, 25000.00, 'SERVED', NULL), 
(30, 3, 1, 95000.00, 'SERVED', NULL), 
(30, 17, 1, 195000.00, 'SERVED', NULL), 
(30, 40, 1, 190000.00, 'SERVED', NULL), 
(30, 60, 2, 45000.00, 'SERVED', NULL), 
(30, 53, 6, 25000.00, 'SERVED', NULL), 
(31, 1, 1, 120000.00, 'SERVED', NULL), 
(31, 14, 1, 195000.00, 'SERVED', NULL), 
(31, 21, 1, 280000.00, 'PREPARING', NULL), 
(31, 36, 2, 75000.00, 'SERVED', NULL), 
(31, 54, 6, 28000.00, 'SERVED', NULL), 
(32, 16, 1, 250000.00, 'SERVED', 'Tái vừa'), 
(32, 25, 1, 125000.00, 'SERVED', NULL), 
(32, 46, 4, 35000.00, 'PREPARING', NULL),
(33, 17, 1, 195000.00, 'SERVED', NULL), 
(33, 46, 1, 45000.00, 'SERVED', NULL), 
(33, 59, 2, 55000.00, 'SERVED', NULL), 
(33, 54, 6, 28000.00, 'SERVED', NULL), 
(33, 52, 2, 25000.00, 'SERVED', NULL), 
(34, 8, 1, 160000.00, 'SERVED', NULL), 
(34, 16, 1, 250000.00, 'SERVED', 'Thịt chín vừa'),
(34, 46, 2, 35000.00, 'SERVED', NULL), 
(34, 60, 2, 45000.00, 'SERVED', 'Ít đá'),
(34, 54, 6, 28000.00, 'SERVED', NULL), 
(35, 20, 1, 125000.00, 'CANCELLED', NULL), 
(35, 21, 1, 85000.00, 'SERVED', NULL), 
(35, 47, 2, 30000.00, 'SERVED', NULL), 
(35, 52, 2, 25000.00, 'SERVED', NULL), 
(35, 54, 4, 25000.00, 'SERVED', NULL), 
(36, 1, 1, 120000.00, 'SERVED', NULL),
(36, 40, 1, 190000.00, 'SERVED', NULL), 
(36, 60, 2, 45000.00, 'SERVED', NULL), 
(36, 54, 2, 25000.00, 'SERVED', NULL),
(37, 13, 1, 145000.00, 'SERVED', NULL), 
(37, 16, 1, 250000.00, 'SERVED', NULL), 
(37, 35, 1, 85000.00, 'SERVED', NULL), 
(37, 46, 1, 45000.00, 'SERVED', NULL), 
(37, 60, 2, 45000.00, 'SERVED', NULL), 
(37, 53, 6, 25000.00, 'SERVED', NULL), 
(38, 11, 1, 155000.00, 'PENDING', NULL),
(38, 21, 1, 280000.00, 'PREPARING', NULL), 
(38, 24, 1, 320000.00, 'SERVED', NULL), 
(38, 38, 1, 95000.00, 'SERVED', NULL), 
(38, 48, 1, 70000.00, 'SERVED', NULL), 
(38, 54, 10, 28000.00, 'SERVED', NULL),
(39, 20, 1, 125000.00, 'SERVED', NULL), 
(39, 35, 1, 85000.00, 'SERVED', NULL), 
(39, 52, 4, 25000.00, 'SERVED', NULL),
(40, 1, 1, 120000.00, 'SERVED', NULL), 
(40, 31, 1, 280000.00, 'PREPARING', NULL), 
(40, 60, 2, 45000.00, 'SERVED', NULL), 
(40, 53, 4, 25000.00, 'SERVED', NULL), 
(41, 14, 1, 195000.00, 'SERVED', NULL), 
(41, 7, 1, 145000.00, 'SERVED', NULL), 
(41, 45, 2, 75000.00, 'SERVED', NULL),
(41, 41, 1, 480000.00, 'SERVED', NULL), 
(41, 54, 8, 28000.00, 'SERVED', NULL), 
(42, 4, 1, 75000.00, 'SERVED', NULL), 
(42, 16, 1, 250000.00, 'SERVED', NULL), 
(42, 23, 1, 350000.00, 'SERVED', NULL), 
(42, 42, 1, 150000.00, 'SERVED', NULL), 
(42, 60, 2, 45000.00, 'SERVED', NULL), 
(42, 54, 8, 28000.00, 'SERVED', NULL), 
(43, 13, 1, 145000.00, 'PENDING', NULL), 
(43, 33, 1, 145000.00, 'PREPARING', NULL), 
(43, 51, 2, 20000.00, 'PENDING', NULL), 
(44, 5, 1, 125000.00, 'SERVED', NULL), 
(44, 19, 1, 90000.00, 'SERVED', NULL), 
(44, 39, 1, 90000.00, 'SERVED', NULL), 
(44, 46, 2, 35000.00, 'SERVED', NULL), 
(44, 54, 10, 28000.00, 'SERVED', NULL), 
(45, 8, 1, 160000.00, 'SERVED', NULL), 
(45, 16, 1, 250000.00, 'SERVED', 'Tái vừa'), 
(45, 50, 2, 45000.00, 'SERVED', 'Thêm đào'),
(45, 59, 2, 50000.00, 'SERVED', NULL), 
(46, 11, 1, 185000.00, 'SERVED', NULL), 
(46, 23, 1, 350000.00, 'SERVED', NULL), 
(46, 41, 1, 480000.00, 'PREPARING', 'Không sả'), 
(46, 53, 6, 25000.00, 'SERVED', NULL), 
(47, 21, 1, 280000.00, 'SERVED', NULL), 
(47, 37, 1, 75000.00, 'SERVED', NULL), 
(47, 53, 4, 25000.00, 'SERVED', NULL),
(48, 1, 1, 120000.00, 'SERVED', NULL), 
(48, 14, 1, 195000.00, 'SERVED', NULL), 
(48, 24, 1, 320000.00, 'SERVED', NULL), 
(48, 38, 2, 95000.00, 'SERVED', NULL), 
(48, 42, 1, 450000.00, 'SERVED', NULL), 
(48, 54, 12, 28000.00, 'SERVED', NULL), 
(49, 4, 1, 75000.00, 'SERVED', NULL), 
(49, 42, 1, 150000.00, 'SERVED', NULL), 
(49, 60, 2, 45000.00, 'SERVED', NULL), 
(49, 57, 2, 45000.00, 'SERVED', NULL), 
(50, 6, 1, 135000.00, 'SERVED', NULL), 
(50, 17, 1, 195000.00, 'SERVED', NULL), 
(50, 25, 1, 125000.00, 'SERVED', NULL), 
(50, 39, 1, 80000.00, 'PENDING', NULL),
(50, 59, 3, 55000.00, 'SERVED', 'Cho bé ít đá'), 
(50, 52, 3, 25000.00, 'SERVED', NULL), 
(57, 10, 1, 155000.00, 'SERVED', NULL), 
(57, 40, 1, 190000.00, 'SERVED', NULL), 
(57, 60, 4, 45000.00, 'PREPARING', NULL), 
(59, 16, 1, 250000.00, 'SERVED', NULL), 
(59, 31, 1, 280000.00, 'PREPARING', NULL), 
(59, 60, 2, 45000.00, 'SERVED', NULL);

SET @manager_id = 2;
INSERT INTO Work_Schedules (user_id, work_date, shift, start_time, end_time, work_position, notes, status, assigned_by) VALUES
(24, '2025-01-28', 'Ca Lễ', '18:00:00', '00:00:00', 'Phục vụ bàn A', NULL, 'CONFIRMED', @manager_id),
(25, '2025-01-29', 'Ca Lễ', '09:00:00', '15:00:00', 'Pha chế chính', NULL, 'CONFIRMED', @manager_id),
(26, '2025-01-30', 'Ca Chiều', '12:00:00', '18:00:00', 'Thu ngân', NULL, 'CONFIRMED', @manager_id),
(27, '2025-03-05', 'Ca Sáng', '07:00:00', '13:00:00', 'Phục vụ bàn B', NULL, 'CANCELLED', @manager_id),
(28, '2025-03-05', 'Ca Sáng', '07:00:00', '13:00:00', 'Phụ bếp', NULL, 'CONFIRMED', @manager_id),
(29, '2025-05-01', 'Ca Lễ', '14:00:00', '21:00:00', 'Pha chế phụ', NULL, 'CONFIRMED', @manager_id),
(30, '2025-05-02', 'Ca Chiều', '13:00:00', '19:00:00', 'Phục vụ bàn A', NULL, 'CONFIRMED', @manager_id),
(31, '2025-06-19', 'Ca Chiều', '12:00:00', '20:00:00', 'Hỗ trợ Kho', NULL, 'CONFIRMED', @manager_id),
(24, '2025-07-02', 'Ca Chiều', '13:00:00', '20:00:00', 'Phục vụ bàn A', NULL, 'CONFIRMED', @manager_id),
(25, '2025-07-04', 'Ca Tối', '18:00:00', '23:00:00', 'Pha chế chính', NULL, 'CONFIRMED', @manager_id),
(26, '2025-07-06', 'Ca Sáng', '08:00:00', '14:00:00', 'Thu ngân', NULL, 'CONFIRMED', @manager_id),
(27, '2025-07-06', 'Ca Tối', '16:00:00', '22:00:00', 'Phục vụ bàn B', NULL, 'CONFIRMED', @manager_id),
(28, '2025-07-10', 'Ca Chiều', '12:00:00', '17:00:00', 'Phụ bếp', NULL, 'CONFIRMED', @manager_id),
(32, '2025-08-16', 'Ca Tối', '18:00:00', '23:30:00', 'Thu ngân', NULL, 'CONFIRMED', @manager_id),
(33, '2025-08-17', 'Ca Sáng', '08:00:00', '14:00:00', 'Phụ bếp', NULL, 'CONFIRMED', @manager_id),
(30, '2025-09-12', 'Ca Sáng', '08:30:00', '14:30:00', 'Phục vụ bàn A', NULL, 'CONFIRMED', @manager_id),
(31, '2025-09-14', 'Ca Tối', '18:00:00', '23:00:00', 'Hỗ trợ Kho', NULL, 'CONFIRMED', @manager_id),
(32, '2025-09-15', 'Ca Chiều', '14:00:00', '20:00:00', 'Thu ngân', NULL, 'CONFIRMED', @manager_id),
(33, '2025-09-17', 'Ca Sáng', '07:30:00', '13:00:00', 'Phụ bếp', NULL, 'CANCELLED', @manager_id),
(34, '2025-09-17', 'Ca Sáng', '07:00:00', '14:00:00', 'Phụ bếp', NULL, 'CONFIRMED', @manager_id),
(35, '2025-09-20', 'Ca Tối', '17:00:00', '23:00:00', 'Phục vụ bàn B', NULL, 'CONFIRMED', @manager_id),
(36, '2025-09-24', 'Ca Chiều', '14:00:00', '20:00:00', 'Phục vụ bàn A', NULL, 'TENTATIVE', @manager_id),
(24, '2025-09-28', 'Ca Tối', '18:00:00', '23:30:00', 'Phục vụ bàn B', NULL, 'CONFIRMED', @manager_id),
(25, '2025-09-29', 'Ca Sáng', '08:00:00', '12:00:00', 'Pha chế chính', NULL, 'TENTATIVE', @manager_id),
(34, '2025-10-10', 'Ca Sáng', '07:30:00', '13:30:00', 'Phục vụ bàn A', NULL, 'CONFIRMED', @manager_id),
(35, '2025-10-12', 'Ca Tối', '17:00:00', '23:00:00', 'Pha chế', NULL, 'CONFIRMED', @manager_id),
(36, '2025-11-20', 'Ca Chiều', '14:00:00', '21:00:00', 'Phục vụ bàn B', NULL, 'TENTATIVE', @manager_id),
(24, '2025-11-20', 'Ca Tối', '18:00:00', '23:00:00', 'Phục vụ bàn A', NULL, 'TENTATIVE', @manager_id),
(26, '2025-12-05', 'Ca Chiều', '13:00:00', '20:00:00', 'Thu ngân', NULL, 'CONFIRMED', @manager_id),
(27, '2025-12-07', 'Ca Tối', '18:00:00', '23:00:00', 'Phục vụ bàn A', NULL, 'TENTATIVE', @manager_id),
(28, '2025-12-10', 'Ca Sáng', '08:00:00', '14:00:00', 'Phụ bếp', NULL, 'CONFIRMED', @manager_id),
(29, '2025-12-12', 'Ca Tối', '17:00:00', '23:00:00', 'Pha chế phụ', NULL, 'TENTATIVE', @manager_id),
(30, '2025-12-14', 'Ca Chiều', '14:00:00', '20:00:00', 'Phục vụ bàn B', NULL, 'CONFIRMED', @manager_id),
(31, '2025-12-18', 'Ca Hành chính', '09:00:00', '17:00:00', 'Hỗ trợ Kho', NULL, 'CONFIRMED', @manager_id),
(32, '2025-12-20', 'Ca Tối', '19:00:00', '23:30:00', 'Thu ngân', NULL, 'CONFIRMED', @manager_id),
(33, '2025-12-24', 'Ca Tối (Lễ)', '17:00:00', '00:00:00', 'Phụ bếp chính', NULL, 'CONFIRMED', @manager_id),
(27, '2025-12-25', 'Ca Sáng', '08:00:00', '14:00:00', 'Phục vụ bàn B', NULL, 'CONFIRMED', @manager_id),
(34, '2025-12-25', 'Ca Sáng (Lễ)', '08:00:00', '15:00:00', 'Phục vụ bàn A', NULL, 'CONFIRMED', @manager_id),
(25, '2025-12-25', 'Ca Chiều (Lễ)', '14:00:00', '22:00:00', 'Pha chế chính', NULL, 'TENTATIVE', @manager_id),
(26, '2025-12-25', 'Ca Tối (Lễ)', '18:00:00', '00:00:00', 'Thu ngân', NULL, 'TENTATIVE', @manager_id),
(35, '2025-12-31', 'Ca Tối (Giao Thừa)', '18:00:00', '01:00:00', 'Pha chế', NULL, 'CONFIRMED', @manager_id),
(36, '2025-12-31', 'Ca Tối (Giao Thừa)', '17:00:00', '00:30:00', 'Phục vụ bàn B', NULL, 'CONFIRMED', @manager_id),
(28, '2026-01-01', 'Ca Sáng (Lễ)', '09:00:00', '16:00:00', 'Phụ bếp', NULL, 'TENTATIVE', @manager_id),
(29, '2026-01-01', 'Ca Chiều (Lễ)', '15:00:00', '23:00:00', 'Pha chế phụ', NULL, 'TENTATIVE', @manager_id);

INSERT INTO Services 
(service_name, service_code, description, price, promotion_info, start_date, end_date, status, created_by, updated_by) VALUES
('Đặt bàn trước', 'RESV001', 'Khách hàng đặt bàn trước để đảm bảo chỗ ngồi.', 0.00, 'Miễn phí hủy trong vòng 24h.', '2025-01-01', '2025-12-31', 'active', 1, 1),
('Tổ chức tiệc sinh nhật', 'BDAY001', 'Trang trí và tổ chức tiệc sinh nhật trọn gói.', 3000000.00, 'Tặng bánh kem 1 tầng cho gói từ 3 triệu.', '2025-01-01', '2025-12-31', 'active', 1, 1),
('Tiệc công ty / hội nghị', 'CORP001', 'Cung cấp không gian và menu cho tiệc công ty.', 10000000.00, 'Giảm 10% cho đoàn trên 50 khách.', '2025-02-01', '2025-12-31', 'active', 1, 1),
('Set ăn trưa doanh nghiệp', 'LUNCH001', 'Combo bữa trưa nhanh cho nhân viên văn phòng.', 120000.00, 'Giảm 15% cho đặt trước theo tuần.', '2025-01-01', '2025-12-31', 'active', 1, 1),
('Tiệc cocktail đứng', 'COCK001', 'Tiệc cocktail & finger food.', 6000000.00, 'Tặng miễn phí trang trí hoa.', '2025-02-01', '2025-12-31', 'active', 1, 1),
('Tiệc kỷ niệm ngày cưới', 'ANNIV001', 'Trang trí lãng mạn và menu đặc biệt cho cặp đôi.', 5000000.00, 'Tặng 1 chai champagne.', '2025-01-01', '2025-12-31', 'active', 1, 1);

INSERT INTO Reviews (user_id, reservation_id, rating, comment, status, created_at, updated_at) VALUES
(4, 1, 5, 'Trải nghiệm tuyệt vời. Thức ăn tươi ngon và phục vụ rất chuyên nghiệp. Đặc biệt thích món Sườn Nướng Mật Ong.', 'APPROVED', '2025-06-05 21:30:00', NOW()),
(8, 5, 5, 'Phòng VIP rất đáng tiền cho buổi tiệc của chúng tôi. Lẩu Hải Sản tuyệt hảo.', 'APPROVED', '2025-06-19 10:00:00', NOW()),
(9, 6, 4, 'Bàn ngoài trời ấm cúng, món Bò Bít Tết chuẩn vị. Phục vụ chu đáo, nhưng có hơi chậm ở khâu thanh toán.', 'APPROVED', '2025-06-21 14:00:00', NOW()),
(12, 9, 4, 'Không gian đẹp, các yêu cầu đặc biệt về dị ứng hải sản được đáp ứng tốt.', 'APPROVED', '2025-06-29 09:30:00', NOW()),
(11, 17, 5, 'Món Lẩu Riêu Cua rất đậm đà. Nhân viên phục vụ bàn T1-01 rất nhiệt tình.', 'APPROVED', '2025-07-21 10:00:00', NOW()),
(9, 25, 5, 'Tổ chức sự kiện tại T2-VIP thành công rực rỡ! Cảm ơn quản lý đã hỗ trợ sát sao.', 'APPROVED', '2025-08-01 15:00:00', NOW()),
(12, 34, 4, 'Bữa tối kỷ niệm tuyệt vời. Yêu thích món Nộm Bò Bóp Thấu.', 'APPROVED', '2025-08-31 09:00:00', NOW()),
(4, 42, 5, 'Rất hài lòng về chất lượng đồ ăn và không gian.', 'APPROVED', '2025-10-06 14:00:00', NOW()),
(14, 51, 4, 'Món Cánh Gà Chiên Nước Mắm ngon tuyệt. Không gian yên tĩnh như yêu cầu.', 'APPROVED', '2025-10-28 08:30:00', NOW()),
(5, 2, 3, 'Nhà hàng quá ồn ào vào buổi tối, chất lượng món khai vị không đồng đều.', 'PENDING_APPROVAL', '2025-06-11 12:00:00', NULL),
(10, 7, 4, 'View ban công rất đẹp, nhưng cần có rèm che bớt nắng vào buổi trưa hè.', 'PENDING_APPROVAL', '2025-06-24 16:00:00', NULL),
(21, 58, 4, 'Set ăn trưa khá đầy đủ, tốc độ ra món nhanh. Rất phù hợp cho nhóm công ty.', 'PENDING_APPROVAL', '2025-12-06 13:00:00', NULL),
(5, 22, 3, 'Trang trí ổn, nhưng đồ uống có giá quá cao. Cảm thấy không xứng đáng với số tiền bỏ ra.', 'REJECTED', '2025-07-30 11:00:00', NOW()),
(17, 54, 2, 'Dịch vụ không được như kỳ vọng, không gian hơi tối so với ảnh quảng cáo.', 'REJECTED', '2025-11-16 09:00:00', NOW());


INSERT INTO Restaurant_Info (info_id, restaurant_name, address, contact_phone, email, description, open_hours, banner_image, updated_at) VALUES
(1, 'The Harmony Diner', '54 Liễu Giai, Ba Đình, Hà Nội', 
 '024-3941-8989', 
 'contact.hanoi@theharmony.vn', 
 'The Harmony Diner mang đến trải nghiệm ẩm thực tinh hoa Á-Âu trong không gian thượng đỉnh hiện đại, với tầm nhìn bao quát toàn cảnh thành phố Hà Nội. Địa điểm lý tưởng cho các buổi tiệc và sự kiện đẳng cấp.', 
 'Thứ 2 - Thứ 6: 10:30 - 23:00; Thứ 7 & CN: 09:30 - 23:30', 
 'https://storage.harmony.com/images/hanoi-banner-sky-view.jpg', 
 NOW());


SET @admin_user_id = 1;
INSERT INTO System_Settings (setting_key, setting_value, description, updated_at, updated_by) VALUES
('RESERVATION_MAX_GUESTS', '12', 'Số lượng khách tối đa cho một lần đặt bàn trực tuyến.', NOW(), @admin_user_id),
('RESERVATION_BUFFER_MINUTES', '30', 'Thời gian chờ (phút) giữa hai lượt đặt bàn liên tiếp trên cùng một bàn.', NOW(), @admin_user_id),
('RESERVATION_CUTOFF_TIME', '21:30', 'Thời điểm cuối cùng trong ngày mà khách có thể đặt bàn online.', NOW(), @admin_user_id),
('FEE_TAX_PERCENTAGE', '10.00', 'Phần trăm thuế VAT áp dụng cho hóa đơn.', NOW(), @admin_user_id),
('FEE_SERVICE_PERCENTAGE', '5.00', 'Phần trăm phí dịch vụ áp dụng cho tổng hóa đơn.', NOW(), @admin_user_id),
('APP_STATUS_MODE', 'LIVE', 'Trạng thái hiện tại của ứng dụng (LIVE/MAINTENANCE).', NOW(), @admin_user_id),
('EMAIL_CONTACT_SUPPORT', 'support@theharmony.vn', 'Địa chỉ email hỗ trợ chính thức của nhà hàng.', NOW(), @admin_user_id);


INSERT INTO Report_Statistics (report_date, `month`, `year`, total_bookings, successful_bookings, cancelled_bookings, total_revenue) VALUES 
('2025-01-01', 1, 2025, 25, 23, 2, 15500000.00),
('2025-01-02', 1, 2025, 30, 30, 0, 21000000.00),
('2025-01-03', 1, 2025, 42, 39, 3, 29800000.00),
('2025-01-04', 1, 2025, 50, 48, 2, 41200000.00),
('2025-01-05', 1, 2025, 45, 45, 0, 38700000.00),
('2025-01-06', 1, 2025, 28, 27, 1, 19900000.00),
('2025-01-07', 1, 2025, 26, 25, 1, 18500000.00),
('2025-01-08', 1, 2025, 31, 29, 2, 22400000.00),
('2025-01-09', 1, 2025, 33, 33, 0, 25300000.00),
('2025-01-10', 1, 2025, 41, 38, 3, 31100000.00),
('2025-01-11', 1, 2025, 48, 46, 2, 40500000.00),
('2025-01-12', 1, 2025, 46, 46, 0, 39900000.00),
('2025-01-13', 1, 2025, 29, 28, 1, 21200000.00),
('2025-01-14', 1, 2025, 27, 25, 2, 19700000.00),
('2025-01-15', 1, 2025, 30, 30, 0, 24100000.00),
('2025-01-16', 1, 2025, 34, 32, 2, 26800000.00),
('2025-01-17', 1, 2025, 44, 41, 3, 35500000.00),
('2025-01-18', 1, 2025, 49, 48, 1, 42300000.00),
('2025-01-19', 1, 2025, 47, 47, 0, 41000000.00),
('2025-01-20', 1, 2025, 30, 29, 1, 22500000.00),
('2025-01-21', 1, 2025, 28, 26, 2, 20100000.00),
('2025-01-22', 1, 2025, 32, 31, 1, 24900000.00),
('2025-01-23', 1, 2025, 35, 35, 0, 28800000.00),
('2025-01-24', 1, 2025, 43, 40, 3, 34900000.00),
('2025-01-25', 1, 2025, 50, 47, 3, 43100000.00),
('2025-01-26', 1, 2025, 48, 48, 0, 42000000.00),
('2025-01-27', 1, 2025, 31, 30, 1, 23700000.00),
('2025-01-28', 1, 2025, 29, 29, 0, 22800000.00),
('2025-01-29', 1, 2025, 33, 31, 2, 25500000.00),
('2025-01-30', 1, 2025, 36, 35, 1, 29400000.00),
('2025-01-31', 1, 2025, 45, 42, 3, 37800000.00),

('2025-02-01', 2, 2025, 51, 48, 3, 44200000.00),
('2025-02-02', 2, 2025, 49, 49, 0, 43100000.00),
('2025-02-03', 2, 2025, 32, 31, 1, 24500000.00),
('2025-02-04', 2, 2025, 30, 28, 2, 22900000.00),
('2025-02-05', 2, 2025, 33, 33, 0, 26700000.00),
('2025-02-06', 2, 2025, 35, 34, 1, 29800000.00),
('2025-02-07', 2, 2025, 44, 41, 3, 36400000.00),
('2025-02-08', 2, 2025, 52, 50, 2, 47500000.00),
('2025-02-09', 2, 2025, 50, 50, 0, 45800000.00),
('2025-02-10', 2, 2025, 34, 32, 2, 26100000.00),
('2025-02-11', 2, 2025, 31, 31, 0, 25500000.00),
('2025-02-12', 2, 2025, 36, 35, 1, 29900000.00),
('2025-02-13', 2, 2025, 38, 36, 2, 31200000.00),
('2025-02-14', 2, 2025, 55, 53, 2, 51200000.00),
('2025-02-15', 2, 2025, 53, 52, 1, 49700000.00),
('2025-02-16', 2, 2025, 51, 51, 0, 46800000.00),
('2025-02-17', 2, 2025, 35, 34, 1, 28400000.00),
('2025-02-18', 2, 2025, 33, 31, 2, 26900000.00),
('2025-02-19', 2, 2025, 37, 37, 0, 31100000.00),
('2025-02-20', 2, 2025, 39, 38, 1, 33400000.00),
('2025-02-21', 2, 2025, 46, 43, 3, 39800000.00),
('2025-02-22', 2, 2025, 54, 51, 3, 49900000.00),
('2025-02-23', 2, 2025, 52, 52, 0, 48100000.00),
('2025-02-24', 2, 2025, 36, 35, 1, 29700000.00),
('2025-02-25', 2, 2025, 34, 34, 0, 28600000.00),
('2025-02-26', 2, 2025, 38, 36, 2, 32100000.00),
('2025-02-27', 2, 2025, 40, 39, 1, 34500000.00),
('2025-02-28', 2, 2025, 47, 44, 3, 41200000.00),

('2025-03-01', 3, 2025, 56, 54, 2, 51500000.00),
('2025-03-02', 3, 2025, 54, 54, 0, 49800000.00),
('2025-03-03', 3, 2025, 37, 36, 1, 30100000.00),
('2025-03-04', 3, 2025, 35, 33, 2, 28700000.00),
('2025-03-05', 3, 2025, 38, 38, 0, 32400000.00),
('2025-03-06', 3, 2025, 40, 39, 1, 34500000.00),
('2025-03-07', 3, 2025, 48, 45, 3, 41800000.00),
('2025-03-08', 3, 2025, 58, 55, 3, 53200000.00),
('2025-03-09', 3, 2025, 56, 56, 0, 51000000.00),
('2025-03-10', 3, 2025, 39, 37, 2, 32100000.00),
('2025-03-11', 3, 2025, 36, 36, 0, 30500000.00),
('2025-03-12', 3, 2025, 41, 40, 1, 35500000.00),
('2025-03-13', 3, 2025, 43, 41, 2, 37200000.00),
('2025-03-14', 3, 2025, 49, 47, 2, 44200000.00),
('2025-03-15', 3, 2025, 57, 56, 1, 54700000.00),
('2025-03-16', 3, 2025, 55, 55, 0, 51800000.00),
('2025-03-17', 3, 2025, 40, 39, 1, 33400000.00),
('2025-03-18', 3, 2025, 38, 36, 2, 31900000.00),
('2025-03-19', 3, 2025, 42, 42, 0, 36100000.00),
('2025-03-20', 3, 2025, 44, 43, 1, 38400000.00),
('2025-03-21', 3, 2025, 50, 47, 3, 45800000.00),
('2025-03-22', 3, 2025, 58, 55, 3, 55900000.00),
('2025-03-23', 3, 2025, 56, 56, 0, 53100000.00),
('2025-03-24', 3, 2025, 41, 40, 1, 34700000.00),
('2025-03-25', 3, 2025, 39, 39, 0, 33600000.00),
('2025-03-26', 3, 2025, 43, 41, 2, 37100000.00),
('2025-03-27', 3, 2025, 45, 44, 1, 39500000.00),
('2025-03-28', 3, 2025, 51, 48, 3, 47200000.00),
('2025-03-29', 3, 2025, 59, 56, 3, 56900000.00),
('2025-03-30', 3, 2025, 57, 57, 0, 54500000.00),
('2025-03-31', 3, 2025, 42, 40, 2, 35800000.00),

('2025-04-01', 4, 2025, 40, 38, 2, 34500000.00),
('2025-04-02', 4, 2025, 42, 42, 0, 36800000.00),
('2025-04-03', 4, 2025, 45, 44, 1, 39100000.00),
('2025-04-04', 4, 2025, 50, 47, 3, 45400000.00),
('2025-04-05', 4, 2025, 60, 57, 3, 58200000.00),
('2025-04-06', 4, 2025, 58, 58, 0, 55900000.00),
('2025-04-07', 4, 2025, 43, 41, 2, 37100000.00),
('2025-04-08', 4, 2025, 41, 41, 0, 36500000.00),
('2025-04-09', 4, 2025, 44, 43, 1, 39500000.00),
('2025-04-10', 4, 2025, 46, 44, 2, 41200000.00),
('2025-04-11', 4, 2025, 52, 50, 2, 48200000.00),
('2025-04-12', 4, 2025, 61, 59, 2, 60700000.00),
('2025-04-13', 4, 2025, 59, 59, 0, 57800000.00),
('2025-04-14', 4, 2025, 44, 43, 1, 38400000.00),
('2025-04-15', 4, 2025, 42, 40, 2, 36900000.00),
('2025-04-16', 4, 2025, 46, 46, 0, 41100000.00),
('2025-04-17', 4, 2025, 48, 47, 1, 43400000.00),
('2025-04-18', 4, 2025, 54, 51, 3, 50800000.00),
('2025-04-19', 4, 2025, 62, 59, 3, 61900000.00),
('2025-04-20', 4, 2025, 60, 60, 0, 59100000.00),
('2025-04-21', 4, 2025, 45, 44, 1, 39700000.00),
('2025-04-22', 4, 2025, 43, 43, 0, 38600000.00),
('2025-04-23', 4, 2025, 47, 45, 2, 42100000.00),
('2025-04-24', 4, 2025, 49, 48, 1, 44500000.00),
('2025-04-25', 4, 2025, 55, 52, 3, 52200000.00),
('2025-04-26', 4, 2025, 63, 60, 3, 62900000.00),
('2025-04-27', 4, 2025, 61, 61, 0, 60500000.00),
('2025-04-28', 4, 2025, 55, 53, 2, 53800000.00),
('2025-04-29', 4, 2025, 60, 59, 1, 59700000.00),
('2025-04-30', 4, 2025, 65, 62, 3, 65100000.00),

('2025-05-01', 5, 2025, 64, 61, 3, 64200000.00),
('2025-05-02', 5, 2025, 62, 62, 0, 61800000.00),
('2025-05-03', 5, 2025, 60, 58, 2, 59900000.00),
('2025-05-04', 5, 2025, 58, 57, 1, 57100000.00),
('2025-05-05', 5, 2025, 42, 42, 0, 37800000.00),
('2025-05-06', 5, 2025, 40, 39, 1, 36400000.00),
('2025-05-07', 5, 2025, 43, 41, 2, 38800000.00),
('2025-05-08', 5, 2025, 45, 45, 0, 41500000.00),
('2025-05-09', 5, 2025, 51, 48, 3, 49200000.00),
('2025-05-10', 5, 2025, 59, 56, 3, 58700000.00),
('2025-05-11', 5, 2025, 57, 57, 0, 56400000.00),
('2025-05-12', 5, 2025, 41, 40, 1, 37200000.00),
('2025-05-13', 5, 2025, 39, 39, 0, 36100000.00),
('2025-05-14', 5, 2025, 44, 42, 2, 39900000.00),
('2025-05-15', 5, 2025, 46, 45, 1, 42700000.00),
('2025-05-16', 5, 2025, 52, 49, 3, 50100000.00),
('2025-05-17', 5, 2025, 60, 57, 3, 59900000.00),
('2025-05-18', 5, 2025, 58, 58, 0, 57900000.00),
('2025-05-19', 5, 2025, 42, 41, 1, 38100000.00),
('2025-05-20', 5, 2025, 40, 40, 0, 37500000.00),
('2025-05-21', 5, 2025, 45, 43, 2, 41000000.00),
('2025-05-22', 5, 2025, 47, 46, 1, 43800000.00),
('2025-05-23', 5, 2025, 53, 50, 3, 51500000.00),
('2025-05-24', 5, 2025, 61, 58, 3, 61200000.00),
('2025-05-25', 5, 2025, 59, 59, 0, 59300000.00),
('2025-05-26', 5, 2025, 43, 42, 1, 39600000.00),
('2025-05-27', 5, 2025, 41, 41, 0, 38700000.00),
('2025-05-28', 5, 2025, 46, 44, 2, 42800000.00),
('2025-05-29', 5, 2025, 48, 47, 1, 45100000.00),
('2025-05-30', 5, 2025, 54, 51, 3, 53200000.00),
('2025-05-31', 5, 2025, 62, 59, 3, 62300000.00),

('2025-06-01', 6, 2025, 60, 60, 0, 59800000.00),
('2025-06-02', 6, 2025, 44, 43, 1, 40100000.00),
('2025-06-03', 6, 2025, 42, 42, 0, 39500000.00),
('2025-06-04', 6, 2025, 47, 45, 2, 43200000.00),
('2025-06-05', 6, 2025, 49, 48, 1, 46100000.00),
('2025-06-06', 6, 2025, 55, 52, 3, 54000000.00),
('2025-06-07', 6, 2025, 63, 60, 3, 63500000.00),
('2025-06-08', 6, 2025, 61, 61, 0, 61100000.00),
('2025-06-09', 6, 2025, 45, 44, 1, 41600000.00),
('2025-06-10', 6, 2025, 43, 43, 0, 40700000.00),
('2025-06-11', 6, 2025, 48, 46, 2, 44800000.00),
('2025-06-12', 6, 2025, 50, 49, 1, 47900000.00),
('2025-06-13', 6, 2025, 56, 53, 3, 55900000.00),
('2025-06-14', 6, 2025, 64, 61, 3, 65200000.00),
('2025-06-15', 6, 2025, 62, 62, 0, 62900000.00),
('2025-06-16', 6, 2025, 46, 45, 1, 42900000.00),
('2025-06-17', 6, 2025, 44, 44, 0, 41800000.00),
('2025-06-18', 6, 2025, 49, 47, 2, 46100000.00),
('2025-06-19', 6, 2025, 51, 50, 1, 49200000.00),
('2025-06-20', 6, 2025, 57, 54, 3, 57300000.00),
('2025-06-21', 6, 2025, 65, 62, 3, 66800000.00),
('2025-06-22', 6, 2025, 63, 63, 0, 64100000.00),
('2025-06-23', 6, 2025, 47, 46, 1, 44200000.00),
('2025-06-24', 6, 2025, 45, 45, 0, 43100000.00),
('2025-06-25', 6, 2025, 50, 48, 2, 47900000.00),
('2025-06-26', 6, 2025, 52, 51, 1, 50500000.00),
('2025-06-27', 6, 2025, 58, 55, 3, 59100000.00),
('2025-06-28', 6, 2025, 66, 63, 3, 68300000.00),
('2025-06-29', 6, 2025, 64, 64, 0, 66000000.00),
('2025-06-30', 6, 2025, 48, 47, 1, 45900000.00),

('2025-07-01', 7, 2025, 46, 46, 0, 44200000.00),
('2025-07-02', 7, 2025, 51, 49, 2, 49100000.00),
('2025-07-03', 7, 2025, 53, 52, 1, 51500000.00),
('2025-07-04', 7, 2025, 59, 56, 3, 60200000.00),
('2025-07-05', 7, 2025, 67, 64, 3, 70100000.00),
('2025-07-06', 7, 2025, 65, 65, 0, 67500000.00),
('2025-07-07', 7, 2025, 49, 48, 1, 47100000.00),
('2025-07-08', 7, 2025, 47, 47, 0, 45800000.00),
('2025-07-09', 7, 2025, 52, 50, 2, 50500000.00),
('2025-07-10', 7, 2025, 54, 53, 1, 53200000.00),
('2025-07-11', 7, 2025, 60, 57, 3, 62100000.00),
('2025-07-12', 7, 2025, 68, 65, 3, 72300000.00),
('2025-07-13', 7, 2025, 66, 66, 0, 69800000.00),
('2025-07-14', 7, 2025, 50, 49, 1, 49000000.00),
('2025-07-15', 7, 2025, 48, 48, 0, 47300000.00),
('2025-07-16', 7, 2025, 53, 51, 2, 52100000.00),
('2025-07-17', 7, 2025, 55, 54, 1, 55000000.00),
('2025-07-18', 7, 2025, 61, 58, 3, 64000000.00),
('2025-07-19', 7, 2025, 69, 66, 3, 74500000.00),
('2025-07-20', 7, 2025, 67, 67, 0, 71500000.00),
('2025-07-21', 7, 2025, 51, 50, 1, 50500000.00),
('2025-07-22', 7, 2025, 49, 49, 0, 48900000.00),
('2025-07-23', 7, 2025, 54, 52, 2, 54000000.00),
('2025-07-24', 7, 2025, 56, 55, 1, 57100000.00),
('2025-07-25', 7, 2025, 62, 59, 3, 66200000.00),
('2025-07-26', 7, 2025, 70, 67, 3, 76900000.00),
('2025-07-27', 7, 2025, 68, 68, 0, 74100000.00),
('2025-07-28', 7, 2025, 52, 51, 1, 52300000.00),
('2025-07-29', 7, 2025, 50, 50, 0, 50800000.00),
('2025-07-30', 7, 2025, 55, 53, 2, 55900000.00),
('2025-07-31', 7, 2025, 57, 56, 1, 58900000.00),

('2025-08-01', 8, 2025, 63, 60, 3, 67800000.00),
('2025-08-02', 8, 2025, 71, 68, 3, 78800000.00),
('2025-08-03', 8, 2025, 69, 69, 0, 76200000.00),
('2025-08-04', 8, 2025, 53, 52, 1, 54100000.00),
('2025-08-05', 8, 2025, 51, 51, 0, 52700000.00),
('2025-08-06', 8, 2025, 56, 54, 2, 57800000.00),
('2025-08-07', 8, 2025, 58, 57, 1, 60900000.00),
('2025-08-08', 8, 2025, 64, 61, 3, 69900000.00),
('2025-08-09', 8, 2025, 72, 69, 3, 81100000.00),
('2025-08-10', 8, 2025, 70, 70, 0, 78500000.00),
('2025-08-11', 8, 2025, 54, 53, 1, 56000000.00),
('2025-08-12', 8, 2025, 52, 52, 0, 54500000.00),
('2025-08-13', 8, 2025, 57, 55, 2, 59900000.00),
('2025-08-14', 8, 2025, 59, 58, 1, 63000000.00),
('2025-08-15', 8, 2025, 65, 62, 3, 72300000.00),
('2025-08-16', 8, 2025, 73, 70, 3, 83500000.00),
('2025-08-17', 8, 2025, 71, 71, 0, 80800000.00),
('2025-08-18', 8, 2025, 55, 54, 1, 58000000.00),
('2025-08-19', 8, 2025, 53, 53, 0, 56400000.00),
('2025-08-20', 8, 2025, 58, 56, 2, 61900000.00),
('2025-08-21', 8, 2025, 60, 59, 1, 65100000.00),
('2025-08-22', 8, 2025, 66, 63, 3, 74600000.00),
('2025-08-23', 8, 2025, 74, 71, 3, 85900000.00),
('2025-08-24', 8, 2025, 72, 72, 0, 83100000.00),
('2025-08-25', 8, 2025, 56, 55, 1, 60000000.00),
('2025-08-26', 8, 2025, 54, 54, 0, 58300000.00),
('2025-08-27', 8, 2025, 59, 57, 2, 64000000.00),
('2025-08-28', 8, 2025, 61, 60, 1, 67200000.00),
('2025-08-29', 8, 2025, 67, 64, 3, 76900000.00),
('2025-08-30', 8, 2025, 75, 72, 3, 88200000.00),
('2025-08-31', 8, 2025, 73, 73, 0, 85500000.00),

('2025-09-01', 9, 2025, 70, 67, 3, 81500000.00),
('2025-09-02', 9, 2025, 68, 68, 0, 79200000.00),
('2025-09-03', 9, 2025, 52, 51, 1, 54800000.00),
('2025-09-04', 9, 2025, 50, 49, 1, 53100000.00),
('2025-09-05', 9, 2025, 55, 53, 2, 58900000.00),
('2025-09-06', 9, 2025, 63, 60, 3, 68500000.00),
('2025-09-07', 9, 2025, 61, 61, 0, 66100000.00),
('2025-09-08', 9, 2025, 48, 47, 1, 49500000.00),
('2025-09-09', 9, 2025, 46, 46, 0, 48200000.00),
('2025-09-10', 9, 2025, 51, 49, 2, 54100000.00),
('2025-09-11', 9, 2025, 53, 52, 1, 56900000.00),
('2025-09-12', 9, 2025, 59, 56, 3, 65500000.00),
('2025-09-13', 9, 2025, 67, 64, 3, 75800000.00),
('2025-09-14', 9, 2025, 65, 65, 0, 73100000.00),
('2025-09-15', 9, 2025, 50, 49, 1, 52800000.00),
('2025-09-16', 9, 2025, 48, 48, 0, 51100000.00),
('2025-09-17', 9, 2025, 53, 51, 2, 56800000.00),
('2025-09-18', 9, 2025, 55, 54, 1, 59800000.00),
('2025-09-19', 9, 2025, 61, 58, 3, 68900000.00),
('2025-09-20', 9, 2025, 69, 66, 3, 79200000.00),
('2025-09-21', 9, 2025, 67, 67, 0, 76500000.00),
('2025-09-22', 9, 2025, 52, 51, 1, 55900000.00),
('2025-09-23', 9, 2025, 50, 50, 0, 54300000.00),
('2025-09-24', 9, 2025, 55, 53, 2, 60100000.00),
('2025-09-25', 9, 2025, 57, 56, 1, 63200000.00),
('2025-09-26', 9, 2025, 63, 60, 3, 72500000.00),
('2025-09-27', 9, 2025, 71, 68, 3, 82800000.00),
('2025-09-28', 9, 2025, 69, 69, 0, 80100000.00),
('2025-09-29', 9, 2025, 54, 53, 1, 58800000.00),
('2025-09-30', 9, 2025, 52, 52, 0, 57100000.00),

('2025-10-01', 10, 2025, 50, 48, 2, 53800000.00),
('2025-10-02', 10, 2025, 52, 51, 1, 56100000.00),
('2025-10-03', 10, 2025, 58, 55, 3, 64200000.00),
('2025-10-04', 10, 2025, 66, 63, 3, 74800000.00),
('2025-10-05', 10, 2025, 64, 64, 0, 72100000.00),
('2025-10-06', 10, 2025, 49, 48, 1, 51700000.00),
('2025-10-07', 10, 2025, 47, 47, 0, 50100000.00),
('2025-10-08', 10, 2025, 52, 50, 2, 55800000.00),
('2025-10-09', 10, 2025, 54, 53, 1, 58800000.00),
('2025-10-10', 10, 2025, 60, 57, 3, 67900000.00),
('2025-10-11', 10, 2025, 68, 65, 3, 78200000.00),
('2025-10-12', 10, 2025, 66, 66, 0, 75500000.00),
('2025-10-13', 10, 2025, 51, 50, 1, 54900000.00),
('2025-10-14', 10, 2025, 49, 49, 0, 53300000.00),
('2025-10-15', 10, 2025, 54, 52, 2, 59100000.00),
('2025-10-16', 10, 2025, 56, 55, 1, 62200000.00),
('2025-10-17', 10, 2025, 62, 59, 3, 71500000.00),
('2025-10-18', 10, 2025, 70, 67, 3, 81800000.00),
('2025-10-19', 10, 2025, 68, 68, 0, 79100000.00),
('2025-10-20', 10, 2025, 60, 58, 2, 69100000.00),
('2025-10-21', 10, 2025, 58, 58, 0, 67300000.00),
('2025-10-22', 10, 2025, 53, 51, 2, 60100000.00),
('2025-10-23', 10, 2025, 55, 54, 1, 63200000.00),
('2025-10-24', 10, 2025, 61, 58, 3, 72500000.00),
('2025-10-25', 10, 2025, 69, 66, 3, 82800000.00),
('2025-10-26', 10, 2025, 67, 67, 0, 80100000.00),
('2025-10-27', 10, 2025, 52, 51, 1, 57900000.00),
('2025-10-28', 10, 2025, 50, 50, 0, 56300000.00),
('2025-10-29', 10, 2025, 55, 53, 2, 62100000.00),
('2025-10-30', 10, 2025, 57, 56, 1, 65200000.00),
('2025-10-31', 10, 2025, 65, 62, 3, 75500000.00);


INSERT INTO BlogCategories (name, slug, description, img_url, created_by)VALUES
  ('Ẩm thực & Nấu ăn', 'am-thuc-nau-an', 'Chia sẻ công thức, mẹo nấu ăn và văn hoá ẩm thực Việt Nam & thế giới.', 'images/categories/amthuc.jpg', 1),
  ('Văn hóa & Du lịch', 'van-hoa-du-lich', 'Khám phá văn hóa, địa danh và trải nghiệm du lịch khắp nơi.', 'images/categories/vanhoa.jpg', 1),
  ('Chia sẻ & Kinh nghiệm', 'chia-se-kinh-nghiem', 'Tổng hợp những kinh nghiệm, mẹo vặt và lời khuyên hữu ích trong cuộc sống.', 'images/categories/chiasenghiem.jpg', 1),
  ('Sự kiện & Khuyến mãi', 'su-kien-khuyen-mai', 'Thông tin các chương trình sự kiện, ưu đãi, giảm giá hấp dẫn.', 'images/categories/sukien.jpg', 1),
  ('Trải nghiệm & Giải trí', 'trai-nghiem-giai-tri', 'Nơi chia sẻ các hoạt động giải trí, phim ảnh, game và trải nghiệm thú vị.', 'images/categories/giaitri.jpg', 1);

INSERT INTO posts (title, slug, content, thumbnail, category_id, created_at, created_by) VALUES
('Cách làm Sushi chuẩn vị Nhật Bản', 'sushi', 'Hướng dẫn cách làm sushi ngon như người Nhật.', 'images/posts/sushi.jpg', 1,  NOW(), 1),
('Phở bò Hà Nội – Tinh hoa ẩm thực Việt', 'pho-bo-ha-noi', '
Phở bò là món ăn biểu tượng của ẩm thực Việt Nam, đặc biệt là ở Hà Nội – nơi mỗi sáng se lạnh, hương thơm từ nồi nước dùng lan tỏa khắp các con phố nhỏ. Để có được bát phở đậm đà chuẩn vị, người nấu cần tỉ mỉ từ khâu chọn nguyên liệu đến cách ninh xương.

Bước đầu tiên và cũng quan trọng nhất là nước dùng. Xương bò ống phải được rửa kỹ, chần qua nước sôi để loại bỏ bọt bẩn, sau đó ninh trên lửa nhỏ trong nhiều giờ cùng hành tây, gừng nướng, quế, hồi và thảo quả. Chính sự kết hợp của các loại gia vị này tạo nên mùi thơm đặc trưng mà không món ăn nào khác có được.

Phần bánh phở nên chọn loại sợi nhỏ, mềm nhưng không nát. Thịt bò phải tươi, có thể dùng tái, chín hoặc gầu tùy khẩu vị. Khi ăn, chan nước dùng nóng hổi lên bánh phở và thịt, rắc thêm hành lá, rau mùi, chút tiêu đen và vài lát ớt đỏ cho dậy mùi.

Phở bò Hà Nội không chỉ là món ăn, mà còn là nét văn hóa – là ký ức của những sáng mùa đông, nơi tiếng dao thái thịt hòa cùng mùi nước dùng nghi ngút khói, tạo nên một bản giao hưởng của ẩm thực Việt.'   , 'images/posts/pho.jpg', 1 ,NOW(), 1);

-- Thể loại 2: Văn hóa & Du lịch
INSERT INTO posts (title, slug, content, thumbnail, category_id, created_at, created_by) VALUES
('Khám phá phố cổ Hội An', 'hoi-an', '
Sài Gòn – thành phố không bao giờ ngủ, cũng là nơi mà văn hóa ẩm thực đường phố phát triển sôi động bậc nhất Việt Nam. Từ sáng sớm cho đến khuya muộn, đâu đâu cũng có thể tìm thấy những món ăn ngon, dân dã nhưng đậm đà hương vị miền Nam.

Bắt đầu buổi sáng với một ổ bánh mì nóng giòn, nhân pate béo ngậy và lớp chả lụa thơm phức. Buổi trưa, bạn có thể ghé vào quán cơm tấm bình dân, nơi những miếng sườn nướng vàng óng và nước mắm chua ngọt khiến ai cũng phải xiêu lòng.

Buổi chiều là thời điểm của những món ăn vặt như bắp xào, gỏi cuốn, bánh tráng trộn – những món ăn mang hương vị tuổi thơ của biết bao thế hệ. Và khi đêm xuống, hẻm nhỏ lại sáng rực ánh đèn từ các quán hủ tiếu, phá lấu, hoặc bún mắm đặc trưng miền Tây.

Ẩm thực Sài Gòn là sự pha trộn tuyệt vời giữa các vùng miền, vừa dân dã, vừa phóng khoáng – đúng như tính cách con người nơi đây.', 'images/posts/hoian.jpg', 2,NOW(), 1),
('Du lịch Đà Nẵng – Thành phố đáng sống', 'da-nang', '
Cà phê trứng là một trong những sáng tạo độc đáo của người Hà Nội – kết hợp giữa vị đắng đặc trưng của cà phê và vị béo ngậy, ngọt thanh của lòng đỏ trứng gà đánh bông.

Món đồ uống này được tạo ra từ những năm 1940, khi sữa khan hiếm. Người pha chế đã nghĩ ra cách dùng trứng để thay thế, và từ đó, cà phê trứng trở thành biểu tượng tinh tế của ẩm thực Hà Nội.

Một ly cà phê trứng ngon cần được pha theo tỷ lệ chuẩn: cà phê đậm đặc, lòng đỏ trứng được đánh với đường và sữa cho đến khi bông mịn, sau đó nhẹ nhàng rót lớp cà phê nóng vào. Khi uống, người ta cảm nhận được sự hòa quyện giữa hương cà phê đậm đà và lớp kem trứng mịn màng, thơm ngậy.

Ngày nay, cà phê trứng không chỉ có ở Hà Nội mà còn được yêu thích trên khắp thế giới – minh chứng cho sự sáng tạo và tinh tế của ẩm thực Việt.', 'images/posts/danang.jpg', 2, NOW(), 1);

-- Thể loại 3: Chia sẻ & Kinh nghiệm
INSERT INTO posts (title, slug, content, thumbnail, category_id,  created_at, created_by) VALUES
('Kinh nghiệm đi phượt bằng xe máy', 'phuot-xe-may', '
Sushi là món ăn biểu tượng của Nhật Bản, nổi tiếng bởi sự tinh tế, tỉ mỉ và chú trọng vào hương vị tự nhiên của nguyên liệu. Dù xuất hiện ở nhiều quốc gia, nhưng để làm được sushi đúng chuẩn Nhật, người nấu cần nắm rõ từng chi tiết nhỏ.

Bước đầu tiên là chọn gạo. Gạo làm sushi phải là loại hạt ngắn, dẻo và có độ dính cao. Sau khi nấu chín, gạo được trộn với hỗn hợp giấm, đường và muối để tạo vị chua nhẹ, giúp cân bằng với hải sản sống.

Phần nhân sushi rất đa dạng – từ cá hồi, cá ngừ, tôm, trứng cuộn cho đến rau củ như dưa leo, bơ, cà rốt. Từng miếng sushi được cuộn bằng tay hoặc bằng mành tre, cắt thành khoanh tròn đều tăm tắp.

Sushi không chỉ là món ăn, mà còn là nghệ thuật – nơi mà người đầu bếp gửi gắm tinh thần tôn trọng nguyên liệu và sự thanh tao của văn hóa Nhật Bản.', 'images/posts/phuot.jpg', 3, NOW(), 1);

-- Thể loại 4: Sự kiện & Khuyến mãi
INSERT INTO posts (title, slug, content, thumbnail, category_id,  created_at, created_by) VALUES
('Khuyến mãi mùa hè – Giảm giá 50%', 'khuyen-mai-mua-he', '
Không quá lời khi nói rằng phở bò là linh hồn của ẩm thực Việt. Mỗi vùng miền có một cách nấu riêng, nhưng phở Hà Nội vẫn mang trong mình bản sắc cổ truyền, là món ăn gắn bó với người dân thủ đô qua nhiều thế hệ.

Điều tạo nên sự khác biệt của phở Hà Nội nằm ở nước dùng trong, ngọt tự nhiên, không quá béo và có hương thơm dịu của quế hồi. Người Hà Nội ăn phở rất tinh tế – họ không chan tương ớt hay chanh quá nhiều mà muốn giữ trọn hương vị nguyên bản.

Phở không chỉ là bữa sáng quen thuộc mà còn là món ăn khiến người xa quê nhớ mãi. Dù bạn ở đâu, chỉ cần húp một thìa nước dùng nóng hổi, nghe mùi hành phi và gừng nướng, là như thấy lại những góc phố Hà Nội cũ kỹ, thân thương.', 'images/posts/sale.jpg', 4, NOW(), 1);

-- Thể loại 5: Trải nghiệm & Giải trí
INSERT INTO posts (title, slug, content, thumbnail, category_id,  created_at, created_by) VALUES
('Top 10 bộ phim hay nhất 2023', 'phim-hay-2023', '
Phố cổ Hội An là viên ngọc của miền Trung Việt Nam, được UNESCO công nhận là Di sản Văn hóa Thế giới. Dù đã trải qua hàng trăm năm, Hội An vẫn giữ được vẻ đẹp cổ kính, yên bình mà hiếm nơi nào có được.

Dạo quanh những con phố nhỏ lát gạch vàng, bạn sẽ bắt gặp những căn nhà mái ngói rêu phong, những chiếc đèn lồng đầy màu sắc treo cao, phản chiếu ánh sáng lung linh xuống dòng sông Hoài. Buổi tối, cả phố cổ trở nên huyền ảo, thơ mộng, thu hút hàng ngàn du khách.

Ẩm thực Hội An cũng rất đặc sắc với cao lầu, mì Quảng, bánh bao – bánh vạc. Mỗi món ăn đều mang trong mình hương vị đậm đà của miền Trung, vừa dân dã vừa tinh tế. Hội An không chỉ là nơi để tham quan, mà còn là chốn để tìm lại sự bình yên và hoài niệm trong tâm hồn.'
, 'images/posts/phim.jpg', 5, NOW(), 1),
('Trò chơi điện tử hot nhất hiện nay', 'game-hot', '
Đà Nẵng được mệnh danh là "thành phố đáng sống nhất Việt Nam" – nơi hội tụ vẻ đẹp thiên nhiên hùng vĩ, những bãi biển dài thơ mộng cùng nhịp sống năng động, hiện đại. Từ đèo Hải Vân huyền thoại đến bãi biển Mỹ Khê quyến rũ, từ cầu Rồng phun lửa đến Bà Nà Hills mờ sương – mỗi góc của Đà Nẵng đều mang một nét đẹp rất riêng.

Buổi sáng, bạn có thể ngắm bình minh trên biển Mỹ Khê, hòa mình vào làn nước trong xanh mát lạnh. Buổi chiều, hãy thử leo núi Ngũ Hành Sơn hoặc dạo quanh phố cổ Hội An chỉ cách trung tâm thành phố hơn 30 km. Đêm đến, Đà Nẵng lại rực rỡ ánh đèn, cầu sông Hàn xoay mình lấp lánh giữa dòng sông yên ả.

Ẩm thực Đà Nẵng cũng là điểm nhấn khó quên – từ mì Quảng, bún chả cá, bánh tráng cuốn thịt heo cho đến hải sản tươi sống. Mỗi món ăn đều giản dị nhưng đậm đà hương vị miền Trung. Dù bạn là khách du lịch trong nước hay nước ngoài, Đà Nẵng chắc chắn sẽ khiến bạn muốn quay lại lần nữa.'
, 'images/posts/game.jpg', 5, NOW(), 1);

