-- 0. Using The Drone Delivery Database

USE DroneDelivery;
GO

-- SQL Queries

-- 1. Show deliveries by drone
SELECT Drone.DroneName,COUNT(del.DeliveryID) AS NumberOfDeliveries
FROM Drone
LEFT JOIN Delivery del ON Drone.DroneID = del.DroneID
GROUP BY Drone.DroneName
ORDER BY NumberOfDeliveries DESC;

-- 2. Find drones with low battery (e.g., below 25%)
SELECT DroneID, DroneName, BatteryPercentage, Status
FROM Drone
WHERE BatteryPercentage < 25;

-- 3. Show heavy packages (e.g., over 3.0 kg)
SELECT p.PackageID, p.WeightKG, p.DimensionsCM, 
       p.Status AS PackageStatus, c.FirstName + ' ' + c.LastName AS CustomerName
FROM Package p
JOIN Customer c ON p.CustomerID = c.CustomerID
WHERE p.WeightKG > 3.0
ORDER BY p.WeightKG DESC;

-- 4. Count deliveries per drone
SELECT d.DroneName, COUNT(del.DeliveryID) AS TotalDeliveries
FROM Drone d
LEFT JOIN Delivery del ON d.DroneID = del.DroneID
GROUP BY d.DroneName
ORDER BY TotalDeliveries DESC;

-- 5. Display customer delivery history
SELECT c.FirstName + ' ' + c.LastName AS CustomerName,
       del.DeliveryID, p.PackageID, p.WeightKG, 
       del.DeliveryStatus, del.ScheduledDateTime, del.ActualDeliveryDateTime,
       d.DroneName,ol.Address AS OriginAddress,dl.Address AS DestinationAddress
FROM Customer c
JOIN Delivery del ON c.CustomerID = del.CustomerID
JOIN Package p ON del.PackageID = p.PackageID
JOIN Drone d ON del.DroneID = d.DroneID
JOIN Location ol ON del.OriginLocationID = ol.LocationID
JOIN Location dl ON del.DestinationLocationID = dl.LocationID
ORDER BY c.LastName, c.FirstName, del.ScheduledDateTime DESC;

-- 6. Show pending deliveries
SELECT del.DeliveryID, d.DroneName,p.PackageID,p.WeightKG,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    ol.Address AS OriginAddress, dl.Address AS DestinationAddress,
    del.ScheduledDateTime
FROM Delivery del
JOIN Drone d ON del.DroneID = d.DroneID
JOIN Package p ON del.PackageID = p.PackageID
JOIN Customer c ON del.CustomerID = c.CustomerID
JOIN Location ol ON del.OriginLocationID = ol.LocationID
JOIN Location dl ON del.DestinationLocationID = dl.LocationID
WHERE del.DeliveryStatus = 'Scheduled' OR del.DeliveryStatus = 'In Progress'
ORDER BY del.ScheduledDateTime ASC;

-- 7. Get average battery percentage of all drones
SELECT AVG(BatteryPercentage) AS AverageBatteryPercentage 
FROM Drone;

-- 8. Get total weight of packages currently in transit
SELECT SUM(p.WeightKG) AS TotalWeightInTransit
FROM Package p
JOIN Delivery d ON p.PackageID = d.PackageID
WHERE d.DeliveryStatus = 'In Progress';

-- 9. Find staff members who are drone operators
SELECT StaffID, FirstName, LastName, Email
FROM Staff
WHERE Role = 'Drone Operator';

-- 10. Get the most recent battery log entry for each drone
SELECT bl.DroneID, d.DroneName, bl.Timestamp, bl.BatteryPercentage
FROM BatteryLog bl
JOIN (
    SELECT DroneID, MAX(Timestamp) AS MaxTimestamp
    FROM BatteryLog
    GROUP BY DroneID
) AS latest_logs
ON bl.DroneID = latest_logs.DroneID AND bl.Timestamp = latest_logs.MaxTimestamp
JOIN Drone d ON bl.DroneID = d.DroneID
ORDER BY bl.DroneID;