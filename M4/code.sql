CREATE DATABASE IF NOT EXISTS hrms_db;
USE hrms_db;

CREATE TABLE IF NOT EXISTS RoomType (
    type_id   INT           NOT NULL AUTO_INCREMENT,
    type_name VARCHAR(50)   NOT NULL,

    CONSTRAINT pk_roomtype  PRIMARY KEY (type_id),
    CONSTRAINT uq_type_name UNIQUE      (type_name),
    CONSTRAINT chk_type_name CHECK      (type_name IN ('Single','Double','Shared'))
);

CREATE TABLE IF NOT EXISTS Floor (
    floor_id     INT  NOT NULL AUTO_INCREMENT,
    floor_number INT  NOT NULL,
    capacity     INT  NOT NULL,

    CONSTRAINT pk_floor          PRIMARY KEY (floor_id),
    CONSTRAINT uq_floor_number   UNIQUE      (floor_number),
    CONSTRAINT chk_floor_number  CHECK       (floor_number > 0),
    CONSTRAINT chk_capacity      CHECK       (capacity > 0)
);

CREATE TABLE IF NOT EXISTS Admin (
    admin_id INT           NOT NULL AUTO_INCREMENT,
    name     VARCHAR(100)  NOT NULL,
    role     VARCHAR(50)   NOT NULL,
    email    VARCHAR(100)  NOT NULL,
    contact  VARCHAR(20)   NOT NULL,

    CONSTRAINT pk_admin      PRIMARY KEY (admin_id),
    CONSTRAINT uq_admin_email UNIQUE     (email),
    CONSTRAINT chk_admin_role CHECK      (role IN ('SuperAdmin','Manager','Coordinator'))
);

CREATE INDEX idx_admin_email ON Admin(email);

-- ============================================================
CREATE TABLE IF NOT EXISTS Warden (
    warden_id        INT           NOT NULL AUTO_INCREMENT,
    name             VARCHAR(100)  NOT NULL,
    email            VARCHAR(100)  NOT NULL,
    contact          VARCHAR(20)   NOT NULL,
    assigned_floor_id INT          NOT NULL,

    CONSTRAINT pk_warden          PRIMARY KEY  (warden_id),
    CONSTRAINT uq_warden_email    UNIQUE        (email),
    CONSTRAINT fk_warden_floor    FOREIGN KEY  (assigned_floor_id)
                                  REFERENCES   Floor(floor_id)
                                  ON UPDATE CASCADE
                                  ON DELETE RESTRICT
);

CREATE INDEX idx_warden_floor ON Warden(assigned_floor_id);

CREATE TABLE IF NOT EXISTS Room (
    room_id INT NOT NULL AUTO_INCREMENT,
    room_number VARCHAR(20) NOT NULL,
    type_id INT NOT NULL,
    floor_id INT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Available',
    CONSTRAINT pk_room PRIMARY KEY (room_id),
    CONSTRAINT uq_room_number UNIQUE (room_number),
    CONSTRAINT fk_room_type FOREIGN KEY (type_id)
        REFERENCES RoomType (type_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_room_floor FOREIGN KEY (floor_id)
        REFERENCES Floor (floor_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_room_status CHECK (status IN ('Available' , 'Occupied'))
);
CREATE INDEX idx_room_type   ON Room(type_id);
CREATE INDEX idx_room_floor  ON Room(floor_id);
CREATE INDEX idx_room_status ON Room(status);

CREATE TABLE IF NOT EXISTS Student (
    student_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    date_of_birth DATE NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    CONSTRAINT pk_student PRIMARY KEY (student_id),
    CONSTRAINT uq_student_email UNIQUE (email),
    CONSTRAINT uq_student_phone UNIQUE (phone_number),
    CONSTRAINT chk_gender CHECK (gender IN ('Male' , 'Female', 'Other'))
);

CREATE INDEX idx_student_email  ON Student(email);
CREATE INDEX idx_student_gender ON Student(gender);

CREATE TABLE IF NOT EXISTS Allocation (
    allocation_id   INT  NOT NULL AUTO_INCREMENT,
    student_id      INT  NOT NULL,
    room_id         INT  NOT NULL,
    admin_id        INT  NOT NULL,
    allocation_date DATE NOT NULL,
    end_date        DATE NOT NULL,

    CONSTRAINT pk_allocation        PRIMARY KEY (allocation_id),
    CONSTRAINT fk_alloc_student     FOREIGN KEY (student_id)
                                    REFERENCES  Student(student_id)
                                    ON UPDATE CASCADE
                                    ON DELETE RESTRICT,
    CONSTRAINT fk_alloc_room        FOREIGN KEY (room_id)
                                    REFERENCES  Room(room_id)
                                    ON UPDATE CASCADE
                                    ON DELETE RESTRICT,
    CONSTRAINT fk_alloc_admin       FOREIGN KEY (admin_id)
                                    REFERENCES  Admin(admin_id)
                                    ON UPDATE CASCADE
                                    ON DELETE RESTRICT,
    CONSTRAINT chk_dates            CHECK (end_date > allocation_date)
);

CREATE INDEX idx_alloc_student ON Allocation(student_id);
CREATE INDEX idx_alloc_room    ON Allocation(room_id);
CREATE INDEX idx_alloc_admin   ON Allocation(admin_id);
CREATE INDEX idx_alloc_date    ON Allocation(allocation_date);




