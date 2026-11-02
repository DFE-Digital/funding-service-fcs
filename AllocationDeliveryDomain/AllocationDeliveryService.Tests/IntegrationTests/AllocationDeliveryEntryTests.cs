namespace AllocationDeliveryService.Tests.IntegrationTests
{
    using System;
    using System.Data.Entity.Validation;
    using System.Data.SqlClient;
    using System.Globalization;
    using ContractManagementService.DTOs;
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities;

    [TestClass]
    public class AllocationDeliveryEntryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationDeliveryEntry_ShouldAddEntrySuccessfully()
        {
            // arrange
            var contractNumber = Guid.NewGuid().ToString("N").Substring(0, 20);
            var corporateAllocationDelivery = new AllocationDeliveryPerformance
            {
                Contract = new contractReferenceTYPE
                {
                    contractNumber = contractNumber,
                },
                contractAllocationNumber = "X"
            };

            var entryIdentifier = Guid.NewGuid();

            var allocationDelivertEntry = Create(corporateAllocationDelivery,
                AllocationDeliveryEntryCategory.AmendedContractAllocationApproved);
            allocationDelivertEntry.Identifier = entryIdentifier;

            try
            {
                AllocationDeliveryEntrySetup.ClearAllocationDeliveryEntryAndData();

                // act
                AllocationDeliveryEntrySetup.InsertAllocationDeliveryEntryAndBytes(allocationDelivertEntry, corporateAllocationDelivery);

                // assert
                var entry = GetAllocationDeliveryEntry(entryIdentifier);

                Assert.AreEqual(contractNumber, entry.ContractNumber);
                
            }
            catch (DbEntityValidationException ex)
            {
                Assert.Fail(ex.InnerException.Message);
            }
        }

        public static AllocationDeliveryEntry Create(AllocationDeliveryPerformance allocationDeliveryPerformance, AllocationDeliveryEntryCategory category)
        {
            AllocationDeliveryEntry allocationDeliveryEntry = new AllocationDeliveryEntry();
            allocationDeliveryEntry.Identifier = Guid.NewGuid();
            allocationDeliveryEntry.AllocationNumber = allocationDeliveryPerformance.contractAllocationNumber;
            allocationDeliveryEntry.VersionNumber = allocationDeliveryPerformance.Contract.contractVersionNumber;
            allocationDeliveryEntry.SubVersionNumber = allocationDeliveryPerformance.Contract.contractSubVersionNumber;
            allocationDeliveryEntry.ContractNumber = allocationDeliveryPerformance.Contract.contractNumber;
            allocationDeliveryEntry.SchemaVersion = allocationDeliveryPerformance.schemaVersion.ToString(CultureInfo.InvariantCulture);
            allocationDeliveryEntry.AllocationDeliveryCategory = category;

            return allocationDeliveryEntry;
        }

        private AllocationDeliveryEntry GetAllocationDeliveryEntry(Guid identifier)
        {
            const string sql = @"select 
                                 [ID]
                                ,[Identifier]
                                ,[AllocationDeliveryCategory]
                                ,[AllocationNumber]
                                ,[VersionNumber]
                                ,[SubVersionNumber]
                                ,[ContractNumber]
                                ,[SchemaVersion]
                                FROM [AllocationDelivery].[AllocationDeliveryEntry] 
                                where identifier = @identifier";

            return new SqlConnection(new AppConfiguration()["ConnectionStrings:AllocationDeliveryDBContext"]).QuerySingle<AllocationDeliveryEntry>(sql, new {identifier});
        }
    }
}
