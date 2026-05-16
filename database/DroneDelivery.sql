-- Create Database
CREATE DATABASE DroneDelivery;
GO

USE DroneDelivery;
GO

-- Create Tables

CREATE TABLE Staff (
    StaffID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Role NVARCHAR(50) NOT NULL CHECK (Role IN (
        'Warehouse Manager',
        'Drone Operator',
        'Maintenance Technician',
        'Administrator'
    )),
    PhoneNumber NVARCHAR(20) UNIQUE,
    Email NVARCHAR(100) UNIQUE
);

CREATE TABLE Drone (
    DroneID INT PRIMARY KEY IDENTITY(1,1),
    DroneName NVARCHAR(50) NOT NULL UNIQUE,
    BatteryPercentage DECIMAL(5,2) NOT NULL CHECK (BatteryPercentage >= 0 AND BatteryPercentage <= 100),
    MaxWeightCapacityKG DECIMAL(5,2) NOT NULL CHECK (MaxWeightCapacityKG > 0),
    Status NVARCHAR(50) NOT NULL CHECK (Status IN (
        'Available',
        'Delivering',
        'Charging',
        'Maintenance',
        'Inactive'
    )),
    StaffID INT,
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Address NVARCHAR(200),
    City NVARCHAR(100),
    State NVARCHAR(100),
    ZipCode NVARCHAR(10),
    PhoneNumber NVARCHAR(20) UNIQUE,
    Email NVARCHAR(100) UNIQUE
);

CREATE TABLE Location (
    LocationID INT PRIMARY KEY IDENTITY(1,1),
    Address NVARCHAR(200) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    State NVARCHAR(100) NOT NULL,
    ZipCode NVARCHAR(10) NOT NULL,
    Latitude DECIMAL(9,6) NOT NULL,
    Longitude DECIMAL(9,6) NOT NULL
);

CREATE TABLE Package (
    PackageID INT PRIMARY KEY IDENTITY(1,1),
    WeightKG DECIMAL(5,2) NOT NULL CHECK (WeightKG > 0),
    DimensionsCM NVARCHAR(50), 
    Status NVARCHAR(50) NOT NULL CHECK (Status IN (
        'Pending',
        'In Transit',
        'Delivered',
        'Cancelled',
        'Held'
    )),
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Delivery (
    DeliveryID INT PRIMARY KEY IDENTITY(1,1),
    DroneID INT NOT NULL,
    PackageID INT NOT NULL UNIQUE,
    CustomerID INT NOT NULL,
    OriginLocationID INT NOT NULL,
    DestinationLocationID INT NOT NULL,
    DeliveryStatus NVARCHAR(50) NOT NULL CHECK (DeliveryStatus IN (
        'Scheduled',
        'In Progress',
        'Completed',
        'Cancelled',
        'Delayed'
    )),
    ScheduledDateTime DATETIME NOT NULL,
    ActualDeliveryDateTime DATETIME,
    FOREIGN KEY (DroneID) REFERENCES Drone(DroneID),
    FOREIGN KEY (PackageID) REFERENCES Package(PackageID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (OriginLocationID) REFERENCES Location(LocationID),
    FOREIGN KEY (DestinationLocationID) REFERENCES Location(LocationID)
);

CREATE TABLE BatteryLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    DroneID INT NOT NULL,
    Timestamp DATETIME DEFAULT GETDATE(),
    BatteryPercentage DECIMAL(5,2) NOT NULL CHECK (BatteryPercentage >= 0 AND BatteryPercentage <= 100),
    FOREIGN KEY (DroneID) REFERENCES Drone(DroneID)
);