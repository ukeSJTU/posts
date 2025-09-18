**约束说明：** PK=主键, UK=唯一, NN=非空, AI=自增, DEFAULT=默认值

## 用户表 (users)

### 表格

| 字段名     | 数据类型  | 长度 | 约束                                | 说明           |
| ---------- | --------- | ---- | ----------------------------------- | -------------- |
| id         | INT       |      | PK, AI                              | 主键，自增     |
| email      | VARCHAR   | 100  | UK, NN                              | 邮箱地址，唯一 |
| password   | VARCHAR   | 255  | NN                                  | 密码哈希值     |
| balance    | DECIMAL   | 10,2 | NN, DEFAULT 0.00                    | 账户余额       |
| created_at | TIMESTAMP |      | NN, DEFAULT CURRENT_TIMESTAMP       | 创建时间       |
| updated_at | TIMESTAMP |      | DEFAULT CURRENT_TIMESTAMP ON UPDATE | 更新时间       |

### SQL DDL

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    balance DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
```

### 说明

- 密码需要在应用层进行哈希加密后存储
- 余额字段使用 DECIMAL 类型确保金额计算精确性
- Optional: 需要考虑邮箱格式验证

## 乘车人表 (passengers)

### 表格

| 字段名     | 数据类型  | 长度 | 约束                                | 说明         |
| ---------- | --------- | ---- | ----------------------------------- | ------------ |
| id         | INT       |      | PK, AI                              | 主键，自增   |
| user_id    | INT       |      | FK, NN                              | 关联用户ID   |
| name       | VARCHAR   | 50   | NN                                  | 乘车人姓名   |
| id_card    | VARCHAR   | 18   | NN                                  | 身份证号     |
| phone      | VARCHAR   | 20   |                                     | 手机号，可选 |
| email      | VARCHAR   | 100  |                                     | 邮箱，可选   |
| created_at | TIMESTAMP |      | NN, DEFAULT CURRENT_TIMESTAMP       | 创建时间     |
| updated_at | TIMESTAMP |      | DEFAULT CURRENT_TIMESTAMP ON UPDATE | 更新时间     |

### SQL DDL

```sql
CREATE TABLE passengers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    id_card VARCHAR(18) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_passengers_user_id ON passengers(user_id);
CREATE INDEX idx_passengers_id_card ON passengers(id_card);
```

### 说明

- 身份证号需要在应用层进行格式验证
- 一个用户可以添加多个乘车人，多个用户也可以添加同一个乘车人（家庭成员之间），支持一对多关系
- Optional: 考虑添加乘车人类型字段（成人、儿童、学生等）
- Optional: 手机号和邮箱格式验证
- Optional: 身份证号脱敏存储或加密
- Optional: 添加乘车人状态字段（有效、无效）
- Optional: 将 `ON DELETE CASCADE` 修改为 `ON DELETE RESTRICT`，并采用逻辑删除策略来管理用户注销。
- Optional: 建立用户和乘车人的多对多关系，减少数据冗余

## 火车时刻表 (train_schedules)

### 表格

| 字段名             | 数据类型  | 长度 | 约束                                | 说明             |
| ------------------ | --------- | ---- | ----------------------------------- | ---------------- |
| id                 | INT       |      | PK, AI                              | 主键，自增       |
| train_number       | VARCHAR   | 10   | NN                                  | 车次编号，如G357 |
| departure_city     | VARCHAR   | 50   | NN                                  | 出发城市         |
| arrival_city       | VARCHAR   | 50   | NN                                  | 到达城市         |
| departure_datetime | DATETIME  |      | NN                                  | 出发日期时间     |
| arrival_datetime   | DATETIME  |      | NN                                  | 到达日期时间     |
| duration_minutes   | INT       |      | NN                                  | 耗时（分钟）     |
| price              | DECIMAL   | 10,2 | NN                                  | 票价             |
| seat_count         | INT       |      | NN                                  | 座位总数         |
| train_status       | ENUM      |      | DEFAULT 'normal'                    | 列车状态         |
| created_at         | TIMESTAMP |      | NN, DEFAULT CURRENT_TIMESTAMP       | 创建时间         |
| updated_at         | TIMESTAMP |      | DEFAULT CURRENT_TIMESTAMP ON UPDATE | 更新时间         |

### SQL DDL

```sql
CREATE TABLE train_schedules (
    id INT PRIMARY KEY AUTO_INCREMENT,
    train_number VARCHAR(10) NOT NULL,
    departure_city VARCHAR(50) NOT NULL,
    arrival_city VARCHAR(50) NOT NULL,
    departure_datetime DATETIME NOT NULL,
    arrival_datetime DATETIME NOT NULL,
    duration_minutes INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    seat_count INT NOT NULL,
    train_status ENUM('normal', 'delayed', 'cancelled', 'suspended') DEFAULT 'normal',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- 一个车次每天只发一次车
    UNIQUE KEY uk_train_departure (train_number, departure_datetime)

    -- 约束：确保到达时间晚于出发时间
    CONSTRAINT chk_arrival_after_departure CHECK (arrival_datetime > departure_datetime),
    -- 约束：确保耗时与实际时间差一致（允许5分钟误差）
    CONSTRAINT chk_duration_consistency CHECK (
        ABS(TIMESTAMPDIFF(MINUTE, departure_datetime, arrival_datetime) - duration_minutes) <= 5
    )
);

-- 索引
CREATE INDEX idx_train_schedules_train_number ON train_schedules(train_number);
CREATE INDEX idx_train_schedules_route ON train_schedules(departure_city, arrival_city);
CREATE INDEX idx_train_schedules_departure_time ON train_schedules(departure_datetime);
CREATE INDEX idx_train_schedules_arrival_time ON train_schedules(arrival_datetime);
CREATE INDEX idx_train_schedules_status ON train_schedules(train_status);

-- 复合索引：用于按路线和时间查询
CREATE INDEX idx_train_schedules_route_time ON train_schedules(departure_city, arrival_city, departure_datetime);
```

### 说明

- arrival_day_offset 表示到达日期相对出发日期的偏移（0=当天，1=次日，2=第三天）
- 需要在应用层验证出发时间、到达时间、日期偏移、耗时四者的一致性
- 价格使用 DECIMAL 类型确保金额计算精确性
- 座位数量为总座位数，不区分座位类型
- Optional: 添加座位类型分类（一等座、二等座等）
- Optional: 添加列车状态字段（正常、停运、延误等）

## 订单表 (orders)

### 表格

| 字段名            | 数据类型  | 长度 | 约束                                | 说明               |
| ----------------- | --------- | ---- | ----------------------------------- | ------------------ |
| id                | INT       |      | PK, AI                              | 主键，自增         |
| order_number      | VARCHAR   | 20   | UK, NN                              | 订单编号，人类可读 |
| train_schedule_id | INT       |      | NN, FK                              | 关联火车时刻表     |
| buyer_id          | INT       |      | NN, FK                              | 购票人ID           |
| passenger_id      | INT       |      | NN, FK                              | 乘车人ID           |
| price             | DECIMAL   | 10,2 | NN                                  | 票价               |
| status            | ENUM      |      | NN                                  | 订单状态           |
| travel_date       | DATE      |      | NN                                  | 乘车日期           |
| created_at        | TIMESTAMP |      | NN, DEFAULT CURRENT_TIMESTAMP       | 创建时间           |
| updated_at        | TIMESTAMP |      | DEFAULT CURRENT_TIMESTAMP ON UPDATE | 更新时间           |

### SQL DDL

```sql
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_number VARCHAR(20) UNIQUE NOT NULL,
    train_schedule_id INT NOT NULL,
    buyer_id INT NOT NULL,
    passenger_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    status ENUM('PENDING_PAYMENT', 'CANCELLED', 'PAID', 'REFUNDED') NOT NULL DEFAULT 'PENDING_PAYMENT',
    travel_date DATE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (train_schedule_id) REFERENCES train_schedules(id),
    FOREIGN KEY (buyer_id) REFERENCES users(id),
    FOREIGN KEY (passenger_id) REFERENCES passengers(id),
);

CREATE INDEX idx_orders_buyer ON orders(buyer_id);
CREATE INDEX idx_orders_passenger ON orders(passenger_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_travel_date ON orders(travel_date);
```

### 说明

- **订单设计原则**: 一个乘车人一张票对应一个订单记录，一个购票人给多个乘车人买票会产生多个订单
- **订单编号**: 建议格式如 `TK2024091812345678`（TK+年月日+流水号）
- **状态枚举**: PENDING_PAYMENT(待付款), CANCELLED(已取消), PAID(已付款), REFUNDED(已退款)
- **乘车日期**: 独立字段，便于查询和管理
- **外键关系**: buyer_id和passenger_id分别关联users表和passengers表，支持购票人和乘车人为不同用户
- **价格字段:** 这里我之所以也记录price字段是因为我认为可能存在优惠，导致订单的实际支付价格和车票原本价格有差异
- Optional: 添加支付时间、退款时间等时间戳字段
- Optional: 添加订单备注字段
- Optional: 座位号，和购票时支持选座的功能一起添加
- Optional: 考虑添加订单分组字段，关联同一购票人的多个订单
