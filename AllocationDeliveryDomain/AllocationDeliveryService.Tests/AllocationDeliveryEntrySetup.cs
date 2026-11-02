namespace AllocationDeliveryService.Tests
{
    using System.Data.SqlClient;
    using ContractManagementService.DTOs;
    using Dapper;
    using Extensions;
    using SFA.FCT.CrossDomain.Integration.Entities;

    public class AllocationDeliveryEntrySetup
    {
        public static void InsertAllocationDeliveryEntryAndBytes(AllocationDeliveryEntry entry, AllocationDeliveryPerformance performance)
        {
            const string sql = @"INSERT INTO [AllocationDelivery].[AllocationDeliveryEntry] 
                                 ([Identifier]
                                ,[AllocationDeliveryCategory]
                                ,[AllocationNumber]
                                ,[VersionNumber]
                                ,[SubVersionNumber]
                                ,[ContractNumber]
                                ,[SchemaVersion])
                                OUTPUT Inserted.Id,
                                       Inserted.[CreatedDate]
                                VALUES(
                                @Identifier, @AllocationDeliveryCategory, @AllocationNumber, @VersionNumber, @SubVersionNumber, @ContractNumber, @SchemaVersion)";

            var entryOutput = new SqlConnection(new AppConfiguration()["ConnectionStrings:AllocationDeliveryDBContext"]).QuerySingle<dynamic>(sql, entry);

            const string sqlForData = @"INSERT INTO [AllocationDelivery].[AllocationDeliveryEntryData] 
                                 ([EntryID]
                                ,[CorporateAllocationDeliveryBytes])
                                
                                VALUES(
                                @EntryId, @bytes)";

            new SqlConnection(new AppConfiguration()["ConnectionStrings:AllocationDeliveryDBContext"]).Execute(sqlForData, new
            {
                entryId = entryOutput.Id,
                bytes = ZipHelper.ToZippedBytesFromString(performance.SerializeToXml())
            });

            entry.CreatedDate = entryOutput.CreatedDate;
        }
            
        public static void ClearAllocationDeliveryEntryAndData()
        {
            var connection = new SqlConnection(new AppConfiguration()["ConnectionStrings:AllocationDeliveryDBContext"]);

            connection.Execute("DELETE FROM AllocationDelivery.AllocationDeliveryEntryData");
            connection.Execute("DELETE FROM AllocationDelivery.AllocationDeliveryEntry");
        }
    }
}
