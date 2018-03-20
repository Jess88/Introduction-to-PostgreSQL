--first setup database tables per Case Study
DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name varchar(50),
    address text,
    email varchar(80),
    password varchar(100),
    created_at TIMESTAMP
);

DROP TABLE IF EXISTS product_types CASCADE;
CREATE TABLE product_types (
    id SERIAL PRIMARY KEY,
    name varchar(100)
);

DROP TABLE IF EXISTS products CASCADE; 
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name varchar(100),
    price float,
    grams float,
    product_type_id integer REFERENCES product_types(id)
);

DROP TABLE IF EXISTS orders CASCADE;
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id integer REFERENCES users(id),
    status varchar(20),
    shipping_total float, --limit orders to be 9999.99 and under
    order_total float,
    address text,
    created_at TIMESTAMP
);

DROP TABLE IF EXISTS order_products CASCADE;
CREATE TABLE order_products (
    id SERIAL PRIMARY KEY,
    product_id integer REFERENCES products(id),
    order_id integer REFERENCES orders(id)
);

DROP TABLE IF EXISTS carts CASCADE;
CREATE TABLE carts (
     id SERIAL PRIMARY KEY,
     user_id integer REFERENCES users(id),
     last_updated TIMESTAMP
);

DROP TABLE IF EXISTS cart_products CASCADE;
CREATE TABLE cart_products (
     id SERIAL PRIMARY KEY,
     cart_id integer REFERENCES carts(id),
     product_id integer REFERENCES products(id),
     created_at TIMESTAMP
);

CREATE OR REPLACE FUNCTION random_date(months_back TEXT) 
    RETURNS TIMESTAMP AS $$
BEGIN
    RETURN (now() - $1::INTERVAL  + (floor(random()  * 7) * '1 day'::interval));
END;
$$ language 'plpgsql' STRICT;

INSERT INTO users ("name", address, email, "password", "created_at")
VALUES 
('John Nobody', '123 nowhere town 97382', 'jno@somewhere.com', md5('oneWayHash' || 'password'), random_date('20 months')), --hashed password for security
('John Somebody', '234 a place ville 36290', 'jsome@nowhere.com', md5('oneWayHash' || 'password2'), random_date('22 months')),
('John Doe', '345 doesville 32193', 'jd@somewhere.com', md5('oneWayHash' || 'password3'), random_date('22 months')),
('John Moe', '456 somewhere 36256', 'jmoe@nowhere.com', md5('oneWayHash' || 'password4'), random_date('21 months')),
('Mary Somebody', '567 one place 47352', 'marys@nowhere.com', md5('oneWayHash' || 'password5'), random_date('21 months')),
('Mary Nobody', '678 longsville 74620', 'm_no@nowhere.com', md5('oneWayHash' || 'password6'), random_date('20 months')),
('Mary Doe', '789 wheresit 36293', 'mard@nowhere.com', md5('oneWayHash' || 'password7'), random_date('20 months')),
('Mary Moe', '109 moetown 32983', 'mary_m@nowhere.com', md5('oneWayHash' || 'password8'), random_date('18 months')),
('Jack Smith', '492 myplace 96403', 'jacks@workplace.com', md5('oneWayHash' || 'password9'), random_date('16 months')),
('Angela Parker', '472 townsville 29386', 'angie@parksplace.com', md5('oneWayHash' || 'password10'), random_date('14 months')),
('Paul Baron', '4862 hillton 38352', 'pb@someplace.com', md5('oneWayHash' || 'password11'), random_date('10 months')),
('George Washington', '9462 citytown 93628', 'g_dubb@whitehouse.com', md5('oneWayHash' || 'password12'), random_date('9 months')),
('Martha Washington', '3826 Unit B atown 39264', 'mrs_dubb@whitehouse.com', md5('oneWayHash' || 'password13'), random_date('6 months')),
('Jane Smith', '502 downtown 96463', 'jane_smith275@thatplace.com', md5('oneWayHash' || 'password14'), random_date('5 months')),
('Jerry Love', '734 Apt# 362 uptown 83628', 'jlove75@aplace.com',md5('oneWayHash' || 'password15'), random_date('4 months')),
('Jake Farm', '402 lasttwon 65217', 'jake@somefarm.com',md5('oneWayHash' || 'password16'), random_date('3 months')),
('Janet Farm', '402 lasttwon 65217', 'janet@somefarm.com',md5('oneWayHash' || 'password17'), random_date('2 months'));


INSERT INTO product_types (name)
VALUES ('computer hardware'),
('computer software'),
('toys and games'),
('books'),
('men''s clothing'),
('boy''s clothing'),
('women''s clothing'),
('girl''s clothing'),
('shoes'),
('accessories'),
('home decor'),
('kitchen and dining');

INSERT INTO  products (name, price, grams, product_type_id)
VALUES
('motherboard',124.99,62.5,(select id from product_types where name = 'computer hardware')),
('hard drive',38.00,57.5,(select id from product_types where name = 'computer hardware')),
('external hard drive',44.99,82.2,(select id from product_types where name = 'computer hardware')),
('monitor',54.98,163.7,(select id from product_types where name = 'computer hardware')),
('keyboard',65.00,26.0,(select id from product_types where name = 'computer hardware')),
('mouse',26.99,72.3,(select id from product_types where name = 'computer hardware')),
('computer speakers',73.45,27.2,(select id from product_types where name = 'computer hardware')),
('antivirus',39.99,12.0,(select id from product_types where name = 'computer software')),
('text editor',19.99,13.5,(select id from product_types where name = 'computer software')),
('strategy game',59.99,11.5,(select id from product_types where name = 'computer software')),
('first person shooter computer game',59.99,14.2,(select id from product_types where name = 'computer software')),
('accounting software',44.99,17.7,(select id from product_types where name = 'computer software')),
('tax software',24.99,12.8,(select id from product_types where name = 'computer software')),
('video editing software',69.00,21.0,(select id from product_types where name = 'computer software')),
('some book',2.43,14.2,(select id from product_types where name = 'books')),
('another book',19.99,21.5,(select id from product_types where name = 'books')),
('vampire book',14.99,11.0,(select id from product_types where name = 'books')),
('fishing book',9.99,16.0,(select id from product_types where name = 'books')),
('baby book',12.95,12.4,(select id from product_types where name = 'books')),
('blue jeans', 44.95, 24.1, (select id from product_types where name = 'men''s clothing')),
('slacks', 74.99, 21.0, (select id from product_types where name = 'men''s clothing')),
('t-shirt', 19.24, 15.2, (select id from product_types where name = 'men''s clothing')),
('boxers', 15.00, 8.1, (select id from product_types where name = 'men''s clothing')),
('socks', 5.99, 4.2, (select id from product_types where name = 'boy''s clothing')),
('sweater', 45.90, null, (select id from product_types where name = 'boy''s clothing')),
('blouse', 89.99, 18.2, (select id from product_types where name = 'women''s clothing')),
('tank top', 18.00, 13.0, (select id from product_types where name = 'women''s clothing')),
('bikini swimsuit', 75.00, 9.3, (select id from product_types where name = 'women''s clothing')),
('skirt', 37.00, 25.38, (select id from product_types where name = 'women''s clothing')),
('dress', 39.00, 42.0, (select id from product_types where name = 'girl''s clothing')),
('pants', 20.00, 26.5, (select id from product_types where name = 'girl''s clothing')),
('socks', 3.99, 10.0, (select id from product_types where name = 'girl''s clothing')),
('t-shirt', 12.00, 19.7, (select id from product_types where name = 'girl''s clothing')),
('slippers', 13.99, 12.8, (select id from product_types where name = 'shoes')),
('sports shoes', 49.99, 31.2, (select id from product_types where name = 'shoes')),
('boots', 69.00, 42.7, (select id from product_types where name = 'shoes')),
('high heels', 79.00, 32.9, (select id from product_types where name = 'shoes')),
('tote bag', 29.00, 24.0, (select id from product_types where name = 'accessories')),
('scarf', 18.99, null, (select id from product_types where name = 'accessories')),
('belt', 15.00, 14.2, (select id from product_types where name = 'accessories')),
('hat', 21.99, null, (select id from product_types where name = 'accessories')),
('hair ties', 1.99, 4.7, (select id from product_types where name = 'accessories')),
('clutch purse', 35.99, 18.8, (select id from product_types where name = 'accessories')),
('cufflinks', 12.85, 13.4, (select id from product_types where name = 'accessories')),
('coaster', 15.99, 8.6, (select id from product_types where name = 'home decor')),
('clock', 22.00, 15.3, (select id from product_types where name = 'home decor')),
('wall hooks', 8.59, 6.4, (select id from product_types where name = 'home decor')),
('desk lamp', 35.00, 59.3, (select id from product_types where name = 'home decor')),
('lavender candle', 10.00, 21.6, (select id from product_types where name = 'home decor')),
('ladle', 14.99, 12.7, (select id from product_types where name = 'kitchen and dining')),
('plate set', 40.00, 48.2, (select id from product_types where name = 'kitchen and dining')),
('animal print bowl set', 30.00, 38.9, (select id from product_types where name = 'kitchen and dining')),
('stemless wine glasses', 35.00, 27.2, (select id from product_types where name = 'kitchen and dining')),
('silverware set', 19.99, 19.7, (select id from product_types where name = 'kitchen and dining')),
('napkin holders', 14.98, 8.3, (select id from product_types where name = 'kitchen and dining'));

--create a function to setup our random values based on a max
CREATE OR REPLACE FUNCTION random_to(high INT) 
    RETURNS INT AS $$
BEGIN
    RETURN floor(random()* (high) + 1);
END;
$$ language 'plpgsql' STRICT;

--ORDER STATUS: null- in the checkout stage, ‘order confirmed’, ‘shipped’, ‘complete’ 
INSERT INTO orders (user_id, status, shipping_total, order_total, address, created_at) 
VALUES
(1, 'complete', 24.75, 0.00, '745 noplace 78362', (random_date('19 months') )),
(1, 'complete', 54.58, 0.00, '456 somewhere 85436', (random_date('18 months') )),
(1, 'complete', 16.21, 00.0, '456 somewhere 85436', (random_date('17 months'))),
(1, 'complete', 21.83, 00.0, '678 nowhere 32616', (random_date('16 months'))),
(1, 'complete', 12.58, 00.0, '678 nowhere 32616', (random_date('15 months'))),
(1, 'complete', 12.94, 00.0, '678 nowhere 32616', (random_date('14 months'))),
(1, 'complete', 15.85, 00.0, '678 nowhere 32616', (random_date('13 months'))),
(1, 'complete', 20.46, 00.0, '678 nowhere 32616', (random_date('12 months'))),
(1, 'complete', 17.84, 00.0, '678 nowhere 32616', (random_date('10 months'))),
(1, 'complete', 15.29, 00.0, '678 nowhere 32616', (random_date('9 months'))),
(1, 'complete', 10.47, 00.0, '678 nowhere 32616', (random_date('8 months'))),
(1, 'complete', 14.72, 00.0, '678 nowhere 32616', (random_date('6 months'))),
(1, 'complete', 12.75, 00.0, '678 nowhere 32616', (random_date('5 months'))),
(1, 'complete', 9.50, 00.0, '678 nowhere 32616', (random_date('5 months'))),
(1, 'complete', 14.04, 00.0, '678 nowhere 32616', (random_date('4 months'))),
(1, 'complete', 11.28, 00.0, '678 nowhere 32616', (random_date('4 months'))),
(1, 'complete', 8.59, 00.0, '678 nowhere 32616', (random_date('3 months'))),
(1, 'complete', 18.26, 00.0, '678 nowhere 32616', (random_date('2 months'))),
(1, 'ready to ship', 14.51, 00.0, '678 nowhere 32616', (random_date('1 months'))),
(1, 'order confirmed', 8.62, 00.0, '678 nowhere 32616', (random_date('1 months'))),
(2, 'complete', 17.82, 0.00, '9262 new place 78352', (random_date('19 months') )),
(2, 'complete', 29.82, 0.00, '9262 new place 78352', (random_date('18 months') )),
(2, 'complete', 43.27, 00.0, '372 others road 85438', (random_date('17 months'))),
(2, 'complete', 12.93, 00.0, '9262 new place 78352', (random_date('16 months'))),
(2, 'complete', 35.82, 00.0, '9262 new place 78352', (random_date('15 months'))),
(2, 'complete', 12.93, 00.0, '9262 new place 78352', (random_date('14 months'))),
(2, 'complete', 18.52, 00.0, '9262 new place 78352', (random_date('12 months'))),
(2, 'complete', 19.17, 00.0, '372 others road 85438', (random_date('10 months'))),
(2, 'complete', 21.27, 00.0, '9262 new place 78352', (random_date('9 months'))),
(2, 'complete', 31.46, 00.0, '9262 new place 78352', (random_date('7 months'))),
(2, 'complete', 14.19, 00.0, '9262 new place 78352', (random_date('6 months'))),
(2, 'complete', 14.27, 00.0, '9262 new place 78352', (random_date('5 months'))),
(2, 'complete', 21.73, 00.0, '9262 new place 78352', (random_date('4 months'))),
(2, 'complete', 21.73, 00.0, '9262 new place 78352', (random_date('5 months'))),
(2, 'complete', 12.91, 00.0, '234 a place ville 36290', (random_date('3 months'))),
(2, 'complete', 17.39, 00.0, '234 a place ville 36290', (random_date('2 months'))),
(2, 'shipped', 19.27, 00.0, '234 a place ville 36290', (random_date('2 months'))),
(2, null, 15.82, 00.0, '234 a place ville 36290', (random_date('1 months'))),
(3, 'complete', 8.72, 0.00, '21718 biplane 38296', (random_date('19 months') )),
(3, 'complete', 11.82, 0.00, '21718 biplane 38296', (random_date('17 months') )),
(3, 'complete', 9.78, 00.0, '21718 biplane 38296', (random_date('14 months'))),
(3, 'complete', 15.82, 00.0, '21718 biplane 38296', (random_date('10 months'))),
(3, 'complete', 31.82, 00.0, '21718 biplane 38296', (random_date('8 months'))),
(3, 'complete', 13.98, 00.0, '21718 biplane 38296', (random_date('7 months'))),
(3, 'complete', 13.71, 00.0, '345 doesville 32193', (random_date('6 months'))),
(3, 'complete', 19.71, 00.0, '345 doesville 32193', (random_date('5 months'))),
(3, 'complete', 24.83, 00.0, '345 doesville 32193', (random_date('5 months'))),
(3, 'complete', 14.92, 00.0, '345 doesville 32193', (random_date('4 months'))),
(3, 'complete', 18.32, 00.0, '345 doesville 32193', (random_date('3 months'))),
(3, 'complete', 19.47, 00.0, '345 doesville 32193', (random_date('3 months'))),
(3, 'shipped', 21.82, 00.0, '345 doesville 32193', (random_date('1 months'))),
(3, null, null, 00.0, '345 doesville 32193', (random_date('1 months'))),
(4, 'complete', 19.61, 0.00, '16532 village town 37261', (random_date('19 months') )),
(4, 'complete', 21.73, 0.00, '16532 village town 37261', (random_date('18 months') )),
(4, 'complete', 23.92, 00.0, '16532 village town 37261', (random_date('17 months'))),
(4, 'complete', 15.23, 00.0, '16532 village town 37261', (random_date('16 months'))),
(4, 'complete', 21.82, 00.0, '16532 village town 37261', (random_date('15 months'))),
(4, 'complete', 19.43, 00.0, '16532 village town 37261', (random_date('14 months'))),
(4, 'complete', 13.22, 00.0, '16532 village town 37261', (random_date('12 months'))),
(4, 'complete', 17.57, 00.0, '456 somewhere 36256', (random_date('10 months'))),
(4, 'complete', 18.27, 00.0, '456 somewhere 36256', (random_date('9 months'))),
(4, 'complete', 16.52, 00.0, '456 somewhere 36256', (random_date('7 months'))),
(4, 'complete', 14.82, 00.0, '456 somewhere 36256', (random_date('6 months'))),
(4, 'complete', 13.25, 00.0, '456 somewhere 36256', (random_date('5 months'))),
(4, 'complete', 17.43, 00.0, '456 somewhere 36256', (random_date('4 months'))),
(4, 'complete', 18.27, 00.0, '456 somewhere 36256', (random_date('5 months'))),
(4, 'complete', 19.15, 00.0, '456 somewhere 36256', (random_date('3 months'))),
(4, 'complete', 14.45, 00.0, '456 somewhere 36256', (random_date('2 months'))),
(4, 'complete', 12.24, 00.0, '456 somewhere 36256', (random_date('2 months'))),
(4, 'order confirmed', 16.23, 00.0, '456 somewhere 36256', (random_date('1 months'))),
(5, 'complete', 19.61, 0.00, '567 one place 47352', (random_date('19 months') )),
(5, 'complete', 21.73, 0.00, '567 one place 47352', (random_date('17 months') )),
(5, 'complete', 23.92, 00.0, '567 one place 47352', (random_date('14 months'))),
(5, 'complete', 15.23, 00.0, '567 one place 47352', (random_date('12 months'))),
(5, 'complete', 21.82, 00.0, '567 one place 47352', (random_date('9 months'))),
(5, 'complete', 19.43, 00.0, '567 one place 47352', (random_date('5 months'))),
(5, 'shipped', 13.22, 00.0, '567 one place 47352', (random_date('2 months'))),
(5, 'order confirmed', 17.57, 00.0, '567 one place 47352', (random_date('1 months'))),
(6, 'complete', 17.61, 0.00, '678 longsville 74620', (random_date('19 months') )),
(6, 'complete', 12.62, 0.00, '678 longsville 74620', (random_date('16 months') )),
(6, 'complete', 16.92, 0.00, '678 longsville 74620', (random_date('13 months') )),
(6, 'complete', 11.81, 0.00, '678 longsville 74620', (random_date('8 months') )),
(6, 'shipped', 16.16, 0.00, '678 longsville 74620', (random_date('5 months') )),
(7, 'complete', 14.12, 0.00, '789 wheresit 36293', (random_date('16 months') )),
(7, 'complete', 7.56, 0.00, '789 wheresit 36293', (random_date('13 months') )),
(7, 'complete', 13.25, 0.00, '789 wheresit 36293', (random_date('10 months') )),
(7, 'complete', 9.39, 0.00, '789 wheresit 36293', (random_date('7 months') )),
(7, 'complete', 9.71, 0.00, '789 wheresit 36293', (random_date('5 months') )),
(7, 'complete', 10.27, 0.00,'789 wheresit 36293', (random_date('3 months') )),
(7, 'shipped', 10.82, 0.00, '789 wheresit 36293', (random_date('1 months') )),
(7, null, null, 0.00, '789 wheresit 36293', (random_date('10 days') )),
(8, 'complete', 14.72, 0.00, '109 moetown 32983', (random_date('16 months') )),
(8, 'complete', 10.26, 0.00, '109 moetown 32983', (random_date('14 months') )),
(8, 'complete', 21.82, 0.00, '109 moetown 32983', (random_date('11 months') )),
(8, 'complete', 11.42, 0.00, '109 moetown 32983', (random_date('8 months') )),
(8, 'complete', 10.63, 0.00, '109 moetown 32983', (random_date('7 months') )),
(8, 'complete', 8.92, 0.00, '109 moetown 32983', (random_date('7 months') )),
(8, 'complete', 11.28, 0.00, '109 moetown 32983', (random_date('6 months') )),
(8, 'complete', 13.37, 0.00, '109 moetown 32983', (random_date('5 months') )),
(8, 'complete', 12.51, 0.00, '109 moetown 32983', (random_date('4 months') )),
(8, 'complete', 17.9, 0.00, '109 moetown 32983', (random_date('3 months') )),
(8, 'complete', 15.31, 0.00, '109 moetown 32983', (random_date('3 months') )),
(8, 'complete', 16.38, 0.00, '109 moetown 32983', (random_date('2 months') )),
(8, 'shipped', 13.29, 0.00, '109 moetown 32983', (random_date('1 months') )),
(8, 'order confirmed', 10.27, 0.00, '109 moetown 32983', (random_date('1 months') )),
(8, null, null, 0.00, '109 moetown 32983', (random_date('7 days') )),
(9, 'complete', 21.85, 0.00, '36127 avenue road 96405', (random_date('14 months') )),
(9, 'complete', 17.53, 0.00, '36127 avenue road 96405', (random_date('13 months') )),
(9, 'complete', 13.71, 0.00, '36127 avenue road 96405', (random_date('12 months') )),
(9, 'complete', 8.37, 0.00, '36127 avenue road 96405', (random_date('12 months') )),
(9, 'complete', 13.71, 0.00, '36127 avenue road 96405', (random_date('11 months') )),
(9, 'complete', 10.49, 0.00, '36127 avenue road 96405', (random_date('9 months') )),
(9, 'complete', 7.72, 0.00, '36127 avenue road 96405', (random_date('8 months') )),
(9, 'complete', 14.73, 0.00, '492 myplace 96403', (random_date('6 months') )),
(9, 'complete', 12.49, 0.00, '492 myplace 96403', (random_date('5 months') )),
(9, 'complete', 11.02, 0.00, '492 myplace 96403', (random_date('3 months') )),
(9, 'shipped', 9.83, 0.00, '492 myplace 96403', (random_date('1 months') )),
(9, null, null, 0.00, '492 myplace 96403', (random_date('8 days') )),
(10, 'complete', 11.84, 0.00, '472 townsville 29386', (random_date('12 months') )),
(10, 'complete', 10.59, 0.00, '472 townsville 29386', (random_date('11 months') )),
(10, 'complete', 9.26, 0.00, '472 townsville 29386', (random_date('9 months') )),
(10, 'complete', 10.35, 0.00, '472 townsville 29386', (random_date('7 months') )),
(10, 'complete', 9.25, 0.00, '472 townsville 29386', (random_date('6 months') )),
(10, 'complete', 12.85, 0.00, '472 townsville 29386', (random_date('5 months') )),
(10, 'complete', 11.54, 0.00, '472 townsville 29386', (random_date('3 months') )),
(10, null, null, 0.00, '472 townsville 29386', (random_date('5 days') )),
(11, 'complete', 11.84, 0.00, '72512 simsville 38353', (random_date('9 months') )),
(11, 'complete', 13.45, 0.00, '72512 simsville 38353', (random_date('8 months') )),
(11, 'complete', 9.39, 0.00, '4862 hillton 38352', (random_date('7 months') )),
(11, 'complete', 13.83, 0.00, '4862 hillton 38352', (random_date('6 months') )),
(11, 'complete', 12.73, 0.00, '4862 hillton 38352', (random_date('4 months') )),
(11, 'complete', 10.69, 0.00, '4862 hillton 38352', (random_date('2 months') )),
(11, 'shipped', 8.92, 0.00, '4862 hillton 38352', (random_date('1 months') )),
(11, 'order confirmed', 11.92, 0.00, '4862 hillton 38352', (random_date('20 days') )),
(12, 'complete', 13.84, 0.00, '9462 citytown 93628', (random_date('7 months') )),
(12, 'complete', 16.84, 0.00, '9462 citytown 93628', (random_date('6 months') )),
(12, 'complete', 9.84, 0.00, '9462 citytown 93628', (random_date('4 months') )),
(12, 'complete', 6.84, 0.00, '9462 citytown 93628', (random_date('3 months') )),
(12, 'shipped', 4.84, 0.00, '9462 citytown 93628', (random_date('1 months') )),
(12, null, null, 0.00, '9462 citytown 93628', (random_date('9 days') )),
(13, 'complete', 12.39, 0.00, '3826 Unit B atown 39264', (random_date('5 months') )),
(13, 'complete', 8.72, 0.00, '3826 Unit B atown 39264', (random_date('5 months') )),
(13, 'complete', 9.53, 0.00, '3826 Unit B atown 39264', (random_date('4 months') )),
(13, 'complete', 7.29, 0.00, '3826 Unit B atown 39264', (random_date('4 months') )),
(13, 'complete', 10.69, 0.00, '3826 Unit B atown 39264', (random_date('3 months') )),
(13, 'complete', 16.96, 0.00, '3826 Unit B atown 39264', (random_date('3 months') )),
(13, 'complete', 11.92, 0.00, '3826 Unit B atown 39264', (random_date('2 months') )),
(13, 'complete', 9.80, 0.00, '3826 Unit B atown 39264', (random_date('2 months') )),
(13, 'complete', 10.39, 0.00, '3826 Unit B atown 39264', (random_date('1 months') )),
(13, 'order confirmed', 9.86, 0.00, '3826 Unit B atown 39264', (random_date('14 days') )),
(15, 'complete', 9.84, 0.00, '734 Apt# 362 uptown 83628', (random_date('4 months') )),
(15, 'complete', 10.29, 0.00, '734 Apt# 362 uptown 83628', (random_date('3 months') )),
(15, 'complete', 11.74, 0.00, '734 Apt# 362 uptown 83628', (random_date('3 months') )),
(15, 'complete', 12.93, 0.00, '734 Apt# 362 uptown 83628', (random_date('2 months') )),
(15, 'shipped', 14.49, 0.00, '734 Apt# 362 uptown 83628', (random_date('1 months') )),
(15, null, null, 0.00, '734 Apt# 362 uptown 83628', (random_date('12 day') )),
(16, 'complete', 9.84, 0.00, '402 lasttwon 65217', (random_date('3 months') )),
(16, 'shipped', 9.84, 0.00, '402 lasttwon 65217', (random_date('1 months') )),
(16, null, null, 0.00, '402 lasttwon 65217', (random_date('7 days') ));


INSERT INTO order_products (order_id, product_id) 
SELECT generate_series,floor(random_to((select max(id) from products))) 
FROM generate_series(1,(select max(id) from orders))
UNION
SELECT 1,floor(random_to((select max(id) from products)) ) 
FROM generate_series(1,3)
UNION
SELECT 2,floor(random_to((select max(id) from products)) )
FROM generate_series(1,3)
UNION
SELECT 3,floor(random_to((select max(id) from products)) ) 
FROM generate_series(1,3)
UNION
SELECT 4,floor(random_to((select max(id) from products)) ) 
FROM generate_series(1,3)
UNION
SELECT 5,floor(random_to((select max(id) from products)) ) 
FROM generate_series(1,3)
UNION
SELECT 6,floor(random_to((select max(id) from products)) ) 
FROM generate_series(1,3)
UNION
SELECT 7,floor(random_to((select max(id) from products)) ) 
FROM generate_series(1,3)
UNION
SELECT 8,floor(random_to((select max(id) from products)) ) 
FROM generate_series(1,3)
UNION
SELECT 9,floor(random_to((select max(id) from products)) ) 
FROM generate_series(1,3)
UNION
SELECT 10,floor(random_to((select max(id) from products)) ) 
FROM generate_series(1,3)
UNION
SELECT 11,floor(random_to((select max(id) from products)) ) 
FROM generate_series(1,3)
UNION
SELECT 12,floor(random_to((select max(id) from products)) ) 
FROM generate_series(1,3)
UNION
SELECT 13,floor(random_to((select max(id) from products)) ) 
FROM generate_series(1,3)
UNION
SELECT 14,floor(random_to((select max(id) from products)) ) 
FROM generate_series(1,3)
UNION
SELECT 15,floor(random_to((select max(id) from products)) ) 
FROM generate_series(1,3)
UNION
SELECT 16,floor(random_to((select max(id) from products)) ) 
FROM generate_series(1,3)
UNION --make a specific product ID the one sold the most last year
SELECT floor(random_to((select max(id) from products)) ), 22 
FROM generate_series(1,15)
;

--Delete all records of 1 product ID to ensure some are never ordered to make the data valuable 
DELETE FROM order_products WHERE product_id = (select id from products where name = 'another book');

--add some 'random' values to the products too
INSERT INTO order_products (order_id, product_id) 
SELECT floor(random_to((select max(id) from orders ))),floor(random_to((select max(id) from products)) )
FROM generate_series(1,50);

UPDATE orders SET order_total = total
FROM
(SELECT op.order_id, sum(p.price) as total
FROM order_products op, products p 
WHERE op.product_id = p.id
GROUP BY op.order_id) order_set 
WHERE order_set.order_id = orders.id;

--create some carts
INSERT INTO carts (user_id, last_updated)
VALUES
(1, random_date('19 months') ),
(2, random_date('19 months') ),
(3, random_date('19 months') ),
(4, random_date('18 months') ),
(5, random_date('17 months') ),
(6, random_date('16 months') ),
(7, random_date('15 months') ),
(8, random_date('14 months') ),
(9, random_date('13 months') ),
(10, random_date('12 months')),
(11, random_date('9 months') ),
(12, random_date('8 months') ),
(13, random_date('8 months') ),
(14, random_date('6 months') ),
(15, random_date('4 months') ),
(16, random_date('2 months') ),
(17, random_date('1 month') );

--Add some products to some carts
INSERT INTO cart_products (cart_id, product_id, created_at)
SELECT floor(random_to((select max(id) from carts ))),floor(random_to((select max(id) from products)) ), random_date('4 months') 
FROM generate_series(1,5)
UNION
SELECT floor(random_to((select max(id) from carts))),floor(random_to((select max(id) from products)) ), random_date('3 months')  
FROM generate_series(1,5)
UNION
SELECT floor(random_to((select max(id) from carts ))),floor(random_to((select max(id) from products)) ), random_date('2 months')
FROM generate_series(1,5)
UNION
SELECT floor(random_to((select max(id) from carts ))),floor(random_to((select max(id) from products)) ), random_date('1 months')
FROM generate_series(1,5)
UNION
SELECT floor(random_to((select max(id) from carts ))),floor(random_to((select max(id) from products)) ), random_date('14 days')
FROM generate_series(1,5)
UNION
SELECT floor(random_to((select max(id) from carts ))),floor(random_to((select max(id) from products)) ), random_date('7 months') 
FROM generate_series(1,5)
UNION
SELECT floor(random_to((select max(id) from carts ))),floor(random_to((select max(id) from products)) ), random_date('3 days') 
FROM generate_series(1,5);
