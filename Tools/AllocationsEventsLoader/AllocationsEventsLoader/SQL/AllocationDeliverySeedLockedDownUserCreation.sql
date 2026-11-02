-- creates a locked down user account for use with the AllocationsEventsLoader
-- with write access only to the new atom feed storage schemas

USE [master]
GO

CREATE LOGIN [AllocationDeliverySeed] WITH PASSWORD = ''
GO

USE [fct-database-release-22Oct2015-1230]
GO

CREATE USER [AllocationDeliverySeed] FOR LOGIN AllocationDeliverySeed WITH DEFAULT_SCHEMA=[AllocationDelivery]
GO

ALTER ROLE [db_datareader] ADD MEMBER [AllocationDeliverySeed]
GO

GRANT INSERT ON SCHEMA::[AllocationDelivery] TO [AllocationDeliverySeed]
GO

GRANT INSERT, SELECT, UPDATE ON SCHEMA::[AllocationDeliveryMonitoring] TO [AllocationDeliverySeed]
GO
