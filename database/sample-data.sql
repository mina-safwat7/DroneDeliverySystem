-- Using DroneDelivery Database

USE DroneDelivery;
GO

-- Insert Sample Data

-- Staff
INSERT INTO Staff (FirstName, LastName, Role, PhoneNumber, Email) VALUES
('Alice', 'Smith', 'Warehouse Manager', '555-1001', 'alice.smith@example.com'),
('Bob', 'Johnson', 'Drone Operator', '555-1002', 'bob.j@example.com'),
('Charlie', 'Brown', 'Drone Operator', '555-1003', 'charlie.b@example.com'),
('Diana', 'Prince', 'Maintenance Technician', '555-1004', 'diana.p@example.com'),
('Eve', 'Adams', 'Administrator', '555-1005', 'eve.a@example.com'),
('Frank', 'White', 'Drone Operator', '555-1006', 'frank.w@example.com'),
('Grace', 'Taylor', 'Drone Operator', '555-1007', 'grace.t@example.com'),
('Henry', 'Moore', 'Maintenance Technician', '555-1008', 'henry.m@example.com'),
('Ivy', 'Clark', 'Warehouse Manager', '555-1009', 'ivy.c@example.com'),
('Jack', 'Hall', 'Drone Operator', '555-1010', 'jack.h@example.com');

-- Drone
INSERT INTO Drone (DroneName, BatteryPercentage, MaxWeightCapacityKG, Status, StaffID) VALUES
('Drone-Alpha', 95.50, 5.00, 'Available', 2),
('Drone-Beta', 80.00, 3.50, 'Delivering', 3),
('Drone-Gamma', 20.00, 6.00, 'Charging', 2),
('Drone-Delta', 60.00, 4.00, 'Maintenance', 4),
('Drone-Epsilon', 75.00, 5.50, 'Available', 6),
('Drone-Zeta', 45.00, 3.00, 'Delivering', 7),
('Drone-Eta', 10.00, 7.00, 'Charging', 6),
('Drone-Theta', 90.00, 4.50, 'Available', 7),
('Drone-Iota', 55.00, 3.80, 'Delivering', 10),
('Drone-Kappa', 70.00, 6.20, 'Available', 10);

-- Customer
INSERT INTO Customer (FirstName, LastName, Address, City, State, ZipCode, PhoneNumber, Email) VALUES
('John', 'Doe', '123 Main St', 'Anytown', 'CA', '90210', '555-2001', 'john.doe@example.com'),
('Jane', 'Smith', '456 Oak Ave', 'Anytown', 'CA', '90210', '555-2002', 'jane.smith@example.com'),
('Peter', 'Jones', '789 Pine Ln', 'Otherville', 'NY', '10001', '555-2003', 'peter.j@example.com'),
('Mary', 'Brown', '101 Elm Rd', 'Otherville', 'NY', '10001', '555-2004', 'mary.b@example.com'),
('Robert', 'Davis', '222 Birch Blvd', 'Anytown', 'CA', '90210', '555-2005', 'robert.d@example.com'),
('Linda', 'Miller', '333 Cedar Ct', 'Otherville', 'NY', '10001', '555-2006', 'linda.m@example.com'),
('William', 'Wilson', '444 Maple Dr', 'Anytown', 'CA', '90210', '555-2007', 'william.w@example.com'),
('Patricia', 'Moore', '555 Spruce St', 'Otherville', 'NY', '10001', '555-2008', 'patricia.m@example.com'),
('James', 'Taylor', '666 Willow Way', 'Anytown', 'CA', '90210', '555-2009', 'james.t@example.com'),
('Jennifer', 'Anderson', '777 Poplar Pl', 'Otherville', 'NY', '10001', '555-2010', 'jennifer.a@example.com');

-- Location
INSERT INTO Location (Address, City, State, ZipCode, Latitude, Longitude) VALUES
('Warehouse A, 100 Industrial Rd', 'Anytown', 'CA', '90200', 34.0522, -118.2437),
('123 Main St', 'Anytown', 'CA', '90210', 34.0500, -118.2500),
('456 Oak Ave', 'Anytown', 'CA', '90210', 34.0550, -118.2450),
('Warehouse B, 200 Business Park', 'Otherville', 'NY', '10000', 40.7128, -74.0060),
('789 Pine Ln', 'Otherville', 'NY', '10001', 40.7150, -74.0050),
('101 Elm Rd', 'Otherville', 'NY', '10001', 40.7100, -74.0070),
('222 Birch Blvd', 'Anytown', 'CA', '90210', 34.0480, -118.2520),
('333 Cedar Ct', 'Otherville', 'NY', '10001', 40.7130, -74.0040),
('444 Maple Dr', 'Anytown', 'CA', '90210', 34.0530, -118.2480),
('555 Spruce St', 'Otherville', 'NY', '10001', 40.7110, -74.0080);

-- Package
INSERT INTO Package (WeightKG, DimensionsCM, Status, CustomerID) VALUES
(2.50, '20x15x10', 'In Transit', 1),
(3.80, '25x20x12', 'Delivered', 2),
(1.20, '15x10x5', 'Pending', 3),
(4.50, '30x25x15', 'In Transit', 4),
(0.75, '10x10x10', 'Delivered', 5),
(5.00, '35x30x20', 'Pending', 6),
(2.10, '22x18x9', 'In Transit', 7),
(3.10, '28x22x11', 'Delivered', 8),
(1.90, '18x12x7', 'Pending', 9),
(4.00, '32x28x18', 'In Transit', 10);

-- Delivery
INSERT INTO Delivery (DroneID, PackageID, CustomerID, OriginLocationID, DestinationLocationID, DeliveryStatus, ScheduledDateTime, ActualDeliveryDateTime) VALUES
(2, 1, 1, 1, 2, 'In Progress', '2026-05-15 10:00:00', NULL),
(3, 2, 2, 1, 3, 'Completed', '2026-05-14 14:30:00', '2026-05-14 16:00:00'),
(6, 4, 4, 4, 6, 'In Progress', '2026-05-15 11:00:00', NULL),
(7, 5, 5, 1, 7, 'Completed', '2026-05-14 09:00:00', '2026-05-14 10:30:00'),
(9, 8, 8, 4, 10, 'Completed', '2026-05-14 13:00:00', '2026-05-14 14:45:00'),
(2, 7, 7, 1, 9, 'In Progress', '2026-05-15 12:00:00', NULL),
(3, 10, 10, 4, 5, 'In Progress', '2026-05-15 13:00:00', NULL),
(6, 3, 3, 1, 5, 'Scheduled', '2026-05-16 09:00:00', NULL),
(7, 6, 6, 4, 8, 'Scheduled', '2026-05-16 10:00:00', NULL),
(9, 9, 9, 1, 1, 'Scheduled', '2026-05-16 11:00:00', NULL);

-- BatteryLog
INSERT INTO BatteryLog (DroneID, Timestamp, BatteryPercentage) VALUES
-- Drone-Alpha
(1, '2026-05-15 08:00:00', 100.00),
(1, '2026-05-15 09:00:00', 98.00),
(1, '2026-05-15 10:00:00', 95.50),
(1, '2026-05-15 11:00:00', 90.00),
(1, '2026-05-15 12:00:00', 84.00),

-- Drone-Beta
(2, '2026-05-15 08:30:00', 90.00),
(2, '2026-05-15 09:30:00', 85.00),
(2, '2026-05-15 10:30:00', 80.00),
(2, '2026-05-15 11:30:00', 72.00),
(2, '2026-05-15 12:30:00', 65.00),

-- Drone-Gamma
(3, '2026-05-15 08:15:00', 35.00),
(3, '2026-05-15 09:15:00', 28.00),
(3, '2026-05-15 10:15:00', 20.00),
(3, '2026-05-15 11:15:00', 15.00),

-- Drone-Delta
(4, '2026-05-15 07:45:00', 70.00),
(4, '2026-05-15 08:45:00', 66.00),
(4, '2026-05-15 09:45:00', 60.00),

-- Drone-Epsilon
(5, '2026-05-15 08:00:00', 95.00),
(5, '2026-05-15 09:00:00', 90.00),
(5, '2026-05-15 10:00:00', 82.00),

-- Drone-Zeta
(6, '2026-05-15 08:20:00', 55.00),
(6, '2026-05-15 09:20:00', 50.00),
(6, '2026-05-15 10:20:00', 45.00),

-- Drone-Eta
(7, '2026-05-15 08:10:00', 25.00),
(7, '2026-05-15 09:10:00', 18.00),
(7, '2026-05-15 10:10:00', 10.00),
(7, '2026-05-15 11:10:00', 5.00),

-- Drone-Theta
(8, '2026-05-15 08:40:00', 98.00),
(8, '2026-05-15 09:40:00', 95.00),
(8, '2026-05-15 10:40:00', 91.00),

-- Drone-Iota
(9, '2026-05-15 08:25:00', 40.00),
(9, '2026-05-15 09:25:00', 30.00),
(9, '2026-05-15 10:25:00', 22.00),

-- Drone-Kappa
(10, '2026-05-15 08:50:00', 78.00),
(10, '2026-05-15 09:50:00', 72.00),
(10, '2026-05-15 10:50:00', 65.00);
