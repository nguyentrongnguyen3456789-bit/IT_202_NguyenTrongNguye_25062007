CREATE DATABASE SocialNetworkDB;
USE SocialNetworkDB;

-- Bảng Users
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Bảng Posts
CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Bảng Comments
CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Bảng Friends
CREATE TABLE friends (
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    status VARCHAR(20) CHECK (status IN ('pending','accepted')),
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (friend_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CHECK (user_id != friend_id)
);

-- Bảng Likes
CREATE TABLE likes (
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE
);
-- REQ‑01: Hồ sơ người dùng an toàn
CREATE VIEW vw_UserInfo AS
SELECT user_id, username, email, created_at
FROM users;
-- REQ‑02: Báo cáo tương tác bài viết
CREATE VIEW vw_PostStatistics AS
SELECT 
    p.post_id,
    p.content AS post_content,
    u.username AS author,
    COUNT(DISTINCT l.user_id) AS total_likes,
    COUNT(DISTINCT c.comment_id) AS total_comments
FROM posts p
LEFT JOIN users u ON p.user_id = u.user_id
LEFT JOIN likes l ON p.post_id = l.post_id
LEFT JOIN comments c ON p.post_id = c.post_id
GROUP BY p.post_id, p.content, u.username;
-- REQ‑03: Đăng ký người dùng mới
DELIMITER //
CREATE PROCEDURE RegisterUser(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_email VARCHAR(100),
    OUT p_message VARCHAR(100)
)
BEGIN
    IF EXISTS (SELECT 1 FROM users WHERE email = p_email) THEN
        SET p_message = 'Email đã được sử dụng';
    ELSE
        INSERT INTO users (username, password, email)
        VALUES (p_username, p_password, p_email);
        SET p_message = 'Đăng ký thành công';
    END IF;
END //
DELIMITER ;
-- REQ‑04: Đăng bài viết mới
DELIMITER //
CREATE PROCEDURE CreatePost(
    IN p_user_id INT,
    IN p_content TEXT,
    OUT p_post_id INT
)
BEGIN
    INSERT INTO posts (user_id, content)
    VALUES (p_user_id, p_content);
    SET p_post_id = LAST_INSERT_ID();
END //
DELIMITER ;

-- REQ‑05: Lấy danh sách bạn bè phân trang
DELIMITER //
CREATE PROCEDURE GetFriendsPaged(
    IN p_user_id INT,
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SELECT u.username, u.email
    FROM friends f
    JOIN users u ON f.friend_id = u.user_id
    WHERE f.user_id = p_user_id AND f.status = 'accepted'
    LIMIT p_limit OFFSET p_offset;
END //
DELIMITER ;
-- REQ‑06: Index cho Newsfeed
CREATE INDEX idx_post_created_at ON posts(created_at);

