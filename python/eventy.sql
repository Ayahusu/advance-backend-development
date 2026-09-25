-- Create database
CREATE DATABASE IF NOT EXISTS eventy;
USE eventy;

-- ======================================================
-- 1. USER TABLE (no changes needed, but kept as is)
-- ======================================================
CREATE TABLE User (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('Attendee', 'Organiser', 'Admin') DEFAULT 'Attendee',
    profile_picture VARCHAR(255) NULL,
    bio TEXT,
    school_college VARCHAR(255),
    country VARCHAR(60),
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ======================================================
-- 2. CATEGORY TABLE (added icon/color for UI)
-- ======================================================
CREATE TABLE Category (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    icon VARCHAR(50) NULL,      -- e.g., '🎤', '💻'
    color_code VARCHAR(7) NULL   -- e.g., '#FF5733'
);

-- ======================================================
-- 3. EVENT TABLE (added soft delete & check constraints)
-- ======================================================
CREATE TABLE Event (
    id INT PRIMARY KEY AUTO_INCREMENT,
    organiser_id INT,
    category_id INT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    event_type ENUM('Online', 'Offline', 'Hybrid') NOT NULL,
    location_name VARCHAR(255),
    address TEXT,
    meeting_link VARCHAR(255),
    start_datetime DATETIME NOT NULL,
    end_datetime DATETIME NOT NULL,
    entry_fee DECIMAL(10, 2) DEFAULT 0.00 CHECK (entry_fee >= 0),
    max_capacity INT CHECK (max_capacity > 0),
    status ENUM('Draft', 'Published', 'Cancelled', 'Completed') DEFAULT 'Draft',
    deleted_at TIMESTAMP NULL,   -- soft delete: NULL = active
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (organiser_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Category(id) ON DELETE SET NULL,
    CHECK (end_datetime > start_datetime)   -- ensure valid date range
);

-- ======================================================
-- 4. REGISTRATION TABLE (fixed: unique + removed payment_status)
-- ======================================================
CREATE TABLE Registration (
    id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    user_id INT,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    attended BOOLEAN DEFAULT FALSE,
    -- payment_status removed – now in Payment table
    FOREIGN KEY (event_id) REFERENCES Event(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    UNIQUE KEY unique_registration (user_id, event_id)   -- prevents duplicate registrations
);

-- ======================================================
-- 5. PAYMENT TABLE (linked to Registration, not directly to User/Event)
-- ======================================================
CREATE TABLE Payment (
    transaction_id VARCHAR(255) PRIMARY KEY,
    registration_id INT NOT NULL,
    provider_transaction_id VARCHAR(255),
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    payment_method ENUM('Esewa', 'Khalti', 'Stripe'),
    payment_status ENUM('Unpaid', 'Paid', 'Refunded') DEFAULT 'Unpaid',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (registration_id) REFERENCES Registration(id) ON DELETE CASCADE
);

-- ======================================================
-- 6. EVENT_LIKE (unchanged, OK)
-- ======================================================
CREATE TABLE Event_Like (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    event_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_like (user_id, event_id),
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES Event(id) ON DELETE CASCADE
);

-- ======================================================
-- 7. EVENT_COMMENT (added parent_comment_id for replies)
-- ======================================================
CREATE TABLE Event_Comment (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    event_id INT,
    parent_comment_id INT NULL,   -- for nested replies
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES Event(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_comment_id) REFERENCES Event_Comment(id) ON DELETE CASCADE
);

-- ======================================================
-- 8. NOTIFICATION (added event_id and type for context)
-- ======================================================
CREATE TABLE Notification (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    event_id INT NULL,                    -- optional: related event
    type ENUM('reminder', 'new_follower', 'ticket_purchased', 'event_update', 'system') DEFAULT 'system',
    message TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES Event(id) ON DELETE SET NULL
);

-- ======================================================
-- 9. FOLLOW (unchanged, composite PK is fine)
-- ======================================================
CREATE TABLE Follow (
    follower_id INT NOT NULL,
    following_id INT NOT NULL,
    PRIMARY KEY (follower_id, following_id),
    FOREIGN KEY (follower_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (following_id) REFERENCES User(id) ON DELETE CASCADE
);

-- ======================================================
-- 10. EVENT_REVIEW (fixed AUTO_INCREMENT + rating check)
-- ======================================================
CREATE TABLE Event_Review (
    id INT PRIMARY KEY AUTO_INCREMENT,    -- AUTO_INCREMENT added
    user_id INT NOT NULL,
    event_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_review (user_id, event_id),
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES Event(id) ON DELETE CASCADE
);

-- ======================================================
-- 11. EVENT_SAVE (unchanged, OK)
-- ======================================================
CREATE TABLE Event_Save (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    event_id INT NOT NULL,
    UNIQUE KEY unique_save (user_id, event_id),
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES Event(id) ON DELETE CASCADE
);

-- ======================================================
-- 12. REPORT (added resolved_by, resolved_at, and support for user reports)
-- ======================================================
CREATE TABLE Report (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,          -- user who made the report
    event_id INT NULL,             -- NULL if reporting a user
    reported_user_id INT NULL,     -- for reporting a user (optional)
    reason TEXT,
    status ENUM('Pending', 'Reviewed', 'Dismissed') DEFAULT 'Pending',
    resolved_by INT NULL,          -- admin who handled it
    resolved_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (reported_user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES Event(id) ON DELETE CASCADE,
    FOREIGN KEY (resolved_by) REFERENCES User(id) ON DELETE SET NULL,
    CHECK (event_id IS NOT NULL OR reported_user_id IS NOT NULL)  -- at least one target
);

-- ======================================================
-- 13. EVENT_VIEW (added unique daily view to prevent spam)
-- ======================================================
CREATE TABLE Event_View (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    event_id INT NOT NULL,
    viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES Event(id) ON DELETE CASCADE,
    -- Optional: prevent duplicate views in same day (for analytics)
    -- UNIQUE KEY unique_daily_view (user_id, event_id, DATE(viewed_at))
);

-- ======================================================
-- 14. WAITLIST (new feature for sold-out events)
-- ======================================================
CREATE TABLE Waitlist (
    id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT NOT NULL,
    user_id INT NOT NULL,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notified BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (event_id) REFERENCES Event(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    UNIQUE KEY unique_waitlist (user_id, event_id)
);

-- ======================================================
-- PERFORMANCE INDEXES (critical for production)
-- ======================================================
CREATE INDEX idx_event_start_datetime ON Event(start_datetime);
CREATE INDEX idx_event_status ON Event(status);
CREATE INDEX idx_event_category ON Event(category_id);
CREATE INDEX idx_event_organiser ON Event(organiser_id);

CREATE INDEX idx_registration_user ON Registration(user_id);
CREATE INDEX idx_registration_event ON Registration(event_id);

CREATE INDEX idx_payment_registration ON Payment(registration_id);
CREATE INDEX idx_payment_status ON Payment(payment_status);

CREATE INDEX idx_notification_user_read ON Notification(user_id, is_read);
CREATE INDEX idx_notification_created ON Notification(created_at);

CREATE INDEX idx_event_view_event ON Event_View(event_id);
CREATE INDEX idx_event_view_user ON Event_View(user_id);

CREATE INDEX idx_waitlist_event ON Waitlist(event_id);
CREATE INDEX idx_waitlist_notified ON Waitlist(notified);