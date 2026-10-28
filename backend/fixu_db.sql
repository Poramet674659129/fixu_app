-- Create Database for FixU App
CREATE DATABASE IF NOT EXISTS `fixu_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `fixu_db`;

-- 1. Table Users
CREATE TABLE IF NOT EXISTS `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `full_name` VARCHAR(255) NOT NULL,
  `email_or_student_id` VARCHAR(100) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sample User Data
INSERT IGNORE INTO `users` (`full_name`, `email_or_student_id`, `password`) VALUES
('นางสาวกุลภัสส์ เปี้ยวน้อย', '65011234', '123456'),
('นายปรเมศวร์ ใจดี (ช่างเทคนิค)', 'poramet@mail.ch.com', '123456');

-- 2. Table Repairs
CREATE TABLE IF NOT EXISTS `repairs` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `ticket_id` VARCHAR(50) NOT NULL UNIQUE,
  `category` VARCHAR(100) NOT NULL,
  `location` VARCHAR(255) NOT NULL,
  `details` TEXT NOT NULL,
  `urgency` VARCHAR(20) DEFAULT 'ปกติ',
  `status` VARCHAR(50) DEFAULT 'pending',
  `reporter_name` VARCHAR(255) NOT NULL,
  `technician_name` VARCHAR(255) DEFAULT 'รอจัดสรรช่าง',
  `date_formatted` VARCHAR(50) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sample Repair Data
INSERT IGNORE INTO `repairs` (`ticket_id`, `category`, `location`, `details`, `urgency`, `status`, `reporter_name`, `technician_name`, `date_formatted`) VALUES
('#20240806001', 'เครื่องปรับอากาศ', 'อาคารเรียนรวม ห้อง 305', 'แอร์ไม่เย็น เปิดแล้วไม่ค่อยมีลม', 'ปกติ', 'inProgress', 'นางสาวกุลภัสส์ เปี้ยวน้อย', 'นายสมชาย ใจดี', '6 ส.ค. 2567'),
('#20240728003', 'ไฟฟ้า', 'อาคารเรียนรวม ชั้น 2', 'ปลั๊กไฟชำรุด ใช้งานไม่ได้', 'ปกติ', 'completed', 'นางสาวกุลภัสส์ เปี้ยวน้อย', 'นายสมชาย ใจดี', '28 ก.ค. 2567'),
('#20240715002', 'ประปา', 'อาคารเรียนรวม ชั้น 1', 'ก๊อกน้ำรั่วในห้องน้ำชาย', 'ด่วน', 'completed', 'นางสาวกุลภัสส์ เปี้ยวน้อย', 'นายสมชาย ใจดี', '15 ก.ค. 2567');

-- 3. Table News
CREATE TABLE IF NOT EXISTS `news` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `title` VARCHAR(255) NOT NULL,
  `category` VARCHAR(100) NOT NULL,
  `location` VARCHAR(255) NOT NULL,
  `date_formatted` VARCHAR(100) NOT NULL,
  `content` TEXT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sample News Data
INSERT IGNORE INTO `news` (`title`, `category`, `location`, `date_formatted`, `content`) VALUES
('แจ้งปรับปรุงระบบไฟฟ้า', 'ปรับปรุงระบบ', 'อาคารเรียนรวม ชั้น 2', '1-5 มิ.ย. 2567', 'ฝ่ายอาคารสถานที่ขอแจ้งปรับปรุงระบบไฟฟ้าทดสอบตู้ควบคุมไฟฟ้าหลัก อาคารเรียนรวม ชั้น 2 เพื่อความปลอดภัยในการใช้งาน โปรดหลีกเลี่ยงการใช้ปลั๊กไฟชั่วคราวในช่วงเวลาดังกล่าว'),
('ปิดปรับปรุงระบบประปาชั่วคราว', 'ปรับปรุงระบบ', 'อาคารหอพักนักศึกษา 1-3', '10 มิ.ย. 2567 (09:00 - 15:00 น.)', 'ทำการซ่อมบำรุงท่อน้ำประปาหลักที่จ่ายเข้าอาคารหอพักนักศึกษา ส่งผลให้น้ำประปาไหลอ่อนหรือไม่ไหลชั่วคราว กรุณาสำรองน้ำไว้ใช้งานล่วงหน้า'),
('ตรวจสอบระบบเครื่องปรับอากาศประจำปี', 'ปรับปรุงระบบ', 'อาคารเรียนรวม และ อาคารวิจัย', '15-20 มิ.ย. 2567', 'ช่างเทคนิคจะเข้าดำเนินการล้างทำความสะอาดแผ่นกรองอากาศและเช็กระบบทำความเย็นเครื่องปรับอากาศในทุกห้องเรียน'),
('เปิดใช้งานระบบแจ้งซ่อม FixU เวอร์ชันใหม่', 'ประกาศมหาวิทยาลัย', 'มหาวิทยาลัย', '1 มิ.ย. 2567', 'ยินดีต้อนรับสู่ FixU แอปพลิเคชันแจ้งซ่อมในมหาวิทยาลัยรูปแบบใหม่ นศ. และบุคลากรสามารถแจ้งปัญหา ติดตามสถานะ และแนบรูปภาพได้รวดเร็วยิ่งขึ้น');
