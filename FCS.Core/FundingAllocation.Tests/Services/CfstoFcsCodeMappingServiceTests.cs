namespace FundingAllocation.Tests.Services
{
    using System;
    using System.Data.SqlClient;
    using DataStore;
    using DataStore.Model;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using FluentAssertions;
    using FundingAllocation.Dto;
    using FundingAllocation.Services;
    using System.Linq;
    using Dapper;
    using FundingAllocation.Repositories;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    [TestClass]
    public class CfstoFcsCodeMappingServiceTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CfstoFcsCodeMappingService_GetFspCodeDeliverable_ShouldReturnFspCodeDeliverableCodeWhenThereIsAMappedConfigRecord()
        {
            // arrange 
            const string providerType = "TEST-PROVIDER-TYPE";
            const string providerSubType = "TEST_PROVIDER-SUBTYPE";
            const string providerCategory = "TEST-PROVIDER-CATEGORY";

            const string allocationFundingStreamCode = "TEST-FUNDING-STREAM-CODE";
            const string allocationFundingPeriodId = "TEST-FUNDING-PERIOD";
            const string fundingLineCode = "TEST-FUNDING-LINE-CODE";

            const string fspCode = "TEST-FSP-CODE";
            const int deliverableCode = 15;
            const string deliverableName = "test d";
            const int deliverableDisplayOrder = 4;
            const string fsCode = "some fs";
            const string allocationPrefix = "a prefix";
            
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var context = new FundingAllocationContext(options);

            var providerFundingInfo = new ProviderFundingInfo(providerType, providerSubType, allocationFundingStreamCode, allocationFundingPeriodId, fundingLineCode, null);

            var fspCodeDeliverableCode = new FspCodeDeliverable(fspCode, deliverableCode, deliverableName, deliverableDisplayOrder, fsCode, allocationPrefix);
            var service = new CfsToFcsCodeMappingService(
                new ContractTypeRepository(context),
                new ProviderCategoryRepository(context),
                new AllocationFundingStreamConfigRepository(context),
                new AllocationLineConfigRepository(context));
            AllocationFundingStreamConfig config = new AllocationFundingStreamConfig(allocationFundingStreamCode, allocationFundingPeriodId, "DADA", "AY2021", "DADA2021");
            ClearDownTableRows(context, providerFundingInfo, providerCategory, fspCode, config);
            CreateTableRows(context, providerFundingInfo, fspCodeDeliverableCode, providerCategory, config);

            // act
            var assertFspCodeAndDeliverable = service.GetFspCodeDeliverable(providerFundingInfo).Result;

            // assert
            assertFspCodeAndDeliverable.Should().BeEquivalentTo(fspCodeDeliverableCode, "Incorrect FspCodeDeliverable returned");
            ClearDownTableRows(context, providerFundingInfo, providerCategory, fspCode, config);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CfstoFcsCodeMappingService_GetFspCodeDeliverable_ShouldUseProviderCategoryExceptionWhenSet()
        {
            // arrange 
            const string providerType = "TEST-PROVIDER-TYPE";
            const string providerSubType = "TEST_PROVIDER-SUBTYPE";
            const string providerCategory = "TEST-PROVIDER-CATEGORY";

            const string allocationFundingStreamCode = "DADA";
            const string allocationFundingPeriodId = "AS-2021";
            const string fundingLineCode = "TEST-FUNDING-LINE-CODE";

            const string fspCode = "TEST-FSP-CODE";
            const int deliverableCode = 15;
            const string deliverableName = "test d";
            const int deliverableDisplayOrder = 4;
            const string fsCode = "some fs";
            const string allocationPrefix = "a prefix";
            const string contractingUkprn = "12345678";
            FundingAllocationLevelInfo fundingAllocationLevelInfo = new FundingAllocationLevelInfo("12345678", "AS-2021", "DADA");
            ProviderCategoryException providerCategoryException = new ProviderCategoryException("EDSK", "AY2021", contractingUkprn, "OverrideCategory");
            AllocationFundingStreamConfig config = new AllocationFundingStreamConfig(allocationFundingStreamCode, allocationFundingPeriodId, "DADA", "AY2021", "DADA2021");
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var context = new FundingAllocationContext(options);

            var providerFundingInfo = new ProviderFundingInfo(providerType, providerSubType, allocationFundingStreamCode, allocationFundingPeriodId, fundingLineCode, contractingUkprn);

            var fspCodeDeliverableCode = new FspCodeDeliverable(fspCode, deliverableCode, deliverableName, deliverableDisplayOrder, fsCode, allocationPrefix);
            var service = new CfsToFcsCodeMappingService(
                new ContractTypeRepository(context),
                new ProviderCategoryRepository(context),
                new AllocationFundingStreamConfigRepository(context),
                new AllocationLineConfigRepository(context));

            ClearDownTableRows(context, providerFundingInfo, providerCategory, fspCode, config);
            CreateTableRows(context, providerFundingInfo, fspCodeDeliverableCode, providerCategory:providerCategoryException.Category, config);
            ClearAllocationFundingStreamRowAndProviderCategoryExceptionTables(context, providerCategoryException);
            CreateAllocationFundingStreamRowAndProviderCategoryException(context, fundingAllocationLevelInfo, providerCategoryException);

            // act
            var assertFspCodeAndDeliverable = service.GetFspCodeDeliverable(providerFundingInfo).Result;

            // assert
            assertFspCodeAndDeliverable.Should().BeEquivalentTo(fspCodeDeliverableCode, "Incorrect FspCodeDeliverable returned");
            ClearDownTableRows(context, providerFundingInfo, providerCategory, fspCode, config);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CfstoFcsCodeMappingService_GetFspCodeDeliverable_ShouldReturnDefaultFspCodeDeliverableCodeWhenProviderCategoryIsNotMapped()
        {
            // arrange 
            const string providerType = "TEST-PROVIDER-TYPE";
            const string providerSubType = "TEST_PROVIDER-SUBTYPE";

            const string allocationFundingStreamCode = "DADA";
            const string allocationFundingPeriodId = "AS-2021";
            const string fundingLineCode = "TEST-FUNDING-LINE-CODE";
            const string providerCategoryDefault = "DEFAULT";

            const string fspCode = "TEST-FSP-CODE";
            const int deliverableCode = 22;
            const string deliverableName = "test name";
            const int deliverableDisplayOrder = 4;
            const string fsCode = "some fs";
            const string allocationPrefix = "a prefix";

            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var context = new FundingAllocationContext(options);

            var providerFundingInfo = new ProviderFundingInfo(providerType, providerSubType, allocationFundingStreamCode, allocationFundingPeriodId, fundingLineCode, null);
            var fspCodeDeliverableCode = new FspCodeDeliverable(fspCode, deliverableCode, deliverableName, deliverableDisplayOrder, fsCode, allocationPrefix);
            AllocationFundingStreamConfig config = new AllocationFundingStreamConfig(allocationFundingStreamCode, allocationFundingPeriodId, "DADA", "AY2021", "DADA2021");
            ClearDownTableRows(context, providerFundingInfo, providerCategoryDefault, fspCode, config);
            CreateTableRows(context, providerFundingInfo, fspCodeDeliverableCode, providerCategoryDefault, config);

            var service = new CfsToFcsCodeMappingService(
                new ContractTypeRepository(context),
                new ProviderCategoryRepository(context),
                new AllocationFundingStreamConfigRepository(context),
                new AllocationLineConfigRepository(context));

            // act
            var assertFspCodeAndDeliverable = service.GetFspCodeDeliverable(providerFundingInfo).Result;

            // assert
            assertFspCodeAndDeliverable.Should().BeEquivalentTo(fspCodeDeliverableCode, "Incorrect FspCodeDeliverable returned");
            ClearDownTableRows(context, providerFundingInfo, providerCategoryDefault, fspCode, config);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CfsToFcsCodeMappingService_GetFspCodeDeliverable_ShouldThrowInvalidOperationExceptionWhenCannotFindMatchingProviderCategory()
        {
            // arrange
            const string missingProviderType = "PROVIDER-TYPE-TEST";
            const string allocationFundingStreamCode = "DADA";
            const string allocationFundingPeriodId = "AS-2021";

            const string fspCode = "TEST-FSP-CODE";
            const int deliverableCode = 22;
            const string deliverableName = "test name";
            const int deliverableDisplayOrder = 4;
            const string fsCode = "some fs";
            const string allocationPrefix = "a prefix";

            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var arrangeContext = new FundingAllocationContext(options);
            
            var providerFundingInfo = new ProviderFundingInfo(
                missingProviderType, "TEST-PROVIDER-SUBTYPE", allocationFundingStreamCode, allocationFundingPeriodId, "TEST-FUNDING-LINE-CODE", null);

            AllocationFundingStreamConfig config = new AllocationFundingStreamConfig(allocationFundingStreamCode, allocationFundingPeriodId, "DADA", "AY2021", "DADA2021");
            ClearDownTableRows(arrangeContext, providerFundingInfo, "", fspCode, config);
            var fspCodeDeliverableCode = new FspCodeDeliverable(fspCode, deliverableCode, deliverableName, deliverableDisplayOrder, fsCode, allocationPrefix);
            CreateTableRows(arrangeContext, providerFundingInfo, fspCodeDeliverableCode, "", config);

            arrangeContext.Database.GetDbConnection().Execute(
                "DELETE FROM FundingAllocation.ProviderTypeConfig WHERE Type = @missingProviderType",
                new { missingProviderType });

            using var context = new FundingAllocationContext(options);

            var cfsToFcsCodeMappingService = new CfsToFcsCodeMappingService(
                new ContractTypeRepository(context),
                new ProviderCategoryRepository(context),
                new AllocationFundingStreamConfigRepository(context),
                new AllocationLineConfigRepository(context));

            // act
            Action act = () => cfsToFcsCodeMappingService.GetFspCodeDeliverable(providerFundingInfo).Wait();

            // assert
            act.Should()
                .Throw<ArgumentException>()
                .WithMessage("Provider Category not found providerType*");
            ClearDownTableRows(arrangeContext, providerFundingInfo, "", fspCode, config);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CfsToFcsCodeMappingService_GetFspCodeDeliverable_ShouldThrowInvalidOperationExceptionWhenCannotFindMatchingAllocationLineConfig()
        {
            const string providerType = "TEST-PROVIDER-TYPE";
            const string providerSubType = "TEST_PROVIDER-SUBTYPE";
            const string providerCategory = "TEST-PROVIDER-CATEGORY";

            const string allocationFundingStreamCode = "TEST-FUNDING-STREAM-CODE";
            const string allocationFundingPeriodId = "TEST-FUNDING-PERIOD";
            const string fundingLineCode = "TEST-FUNDING-LINE-CODE";

            const string fspCode = "TEST-FSP-CODE";
            const int deliverableCode = 15;
            const string deliverableName = "test d";
            const int deliverableDisplayOrder = 4;
            const string fsCode = "some fs";
            const string allocationPrefix = "a prefix";

            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var context = new FundingAllocationContext(options);

            var providerFundingInfo = new ProviderFundingInfo(providerType, providerSubType, allocationFundingStreamCode, allocationFundingPeriodId, fundingLineCode, null);

            var fspCodeDeliverableCode = new FspCodeDeliverable(fspCode, deliverableCode, deliverableName, deliverableDisplayOrder, fsCode, allocationPrefix);
            var service = new CfsToFcsCodeMappingService(
                new ContractTypeRepository(context),
                new ProviderCategoryRepository(context),
                new AllocationFundingStreamConfigRepository(context),
                new AllocationLineConfigRepository(context));
            AllocationFundingStreamConfig config = new AllocationFundingStreamConfig(allocationFundingStreamCode, allocationFundingPeriodId, "DADA", "AY2021", "DADA2021");
            ClearDownTableRows(context, providerFundingInfo, providerCategory, fspCode, config);
            CreateTableRows(context, providerFundingInfo, fspCodeDeliverableCode, providerCategory, config);
            context.Database.GetDbConnection().Execute(
                    "DELETE FROM FundingAllocation.AllocationLineConfig WHERE FspCode = @fspCode",
                    new { fspCode });

            // act
            Action act = () => service.GetFspCodeDeliverable(providerFundingInfo).Wait();

            //// assert
            act.Should()
                .Throw<InvalidOperationException>()
                .WithMessage("Failed to find matching Allocation Line Config *");
            ClearDownTableRows(context, providerFundingInfo, providerCategory, fspCode, config);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CfstoFcsCodeMappingService_GetContractItemsMappingResult_ShouldGetResult()
        {
            // arrange
            const string providerType = "t1";
            const string providerSubType = "st1";
            const string category = "c1";
            const string allocationFundingStreamCode = "afsc";
            const string allocationPeriodId = "ap1";
            const string fundingTypeCode = "ft1";
            const string fundingPeriodCode = "fp1";
            const string fspGroupCode = "fspG1";
            const string contractType = "ct1";

            ClearDownProviderTypeConfig(providerType, providerSubType);
            InsertProviderType(providerType, providerSubType, category);
            ClearDownAllocationFundingStreamConfig(allocationFundingStreamCode, allocationPeriodId);
            InsertAllocationFundingStreamConfig(allocationFundingStreamCode, allocationPeriodId, fundingTypeCode,
                fundingPeriodCode, fspGroupCode);
            ClearDownCfsMappingConfig(fundingTypeCode, fundingPeriodCode, category);
            InsertCfsMappingConfig(fundingTypeCode, fundingPeriodCode, category, contractType);

            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var context = new FundingAllocationContext(options);

            var service = new CfsToFcsCodeMappingService(
                new ContractTypeRepository(context),
                new ProviderCategoryRepository(context),
                new AllocationFundingStreamConfigRepository(context),
                new AllocationLineConfigRepository(context));

            // act 
            var result = service
                .GetContractItemsMappingResult(new ContractItemsMappingInput(allocationFundingStreamCode,
                    allocationPeriodId, providerType, providerSubType, "12345678")).Result;

            // assert
            Assert.AreEqual(fundingTypeCode, result.FundingTypeCode, "The funding type code is not correct");
            Assert.AreEqual(fundingPeriodCode, result.FundingPeriodCode, "The FundingPeriodCode is not correct");
            Assert.AreEqual(fspGroupCode, result.FSPGroupCode, "The FSPGroupCode is not correct");
            Assert.AreEqual(contractType, result.ContractType, "The ContractType is not correct");
        }

        private static void ClearDownTableRows(FundingAllocationContext context,
            ProviderFundingInfo providerFundingInfo, string providerCategory, string fspCode,
            AllocationFundingStreamConfig config)
        {
            context.Database.ExecuteSqlRaw(@$"DELETE FROM [FundingAllocation].[ProviderTypeConfig] WHERE [Type] = '{providerFundingInfo.ProviderType}' 
                                              AND [Subtype] = '{providerFundingInfo.ProviderSubType}'");

            context.Database.ExecuteSqlRaw(@$"DELETE FROM [FundingAllocation].[AllocationLineConfig] WHERE [FundingStreamCode] = '{providerFundingInfo.FundingStreamCode}' 
                                              AND [PeriodId] = '{providerFundingInfo.FundingPeriodId}' AND [FundingLineCode] ='{providerFundingInfo.FundingLineCode}'
                                              AND [ProviderCategory] = '{providerCategory}'");
            context.Database.ExecuteSqlRaw(@$"DELETE FROM [FundingAllocation].[FundingStreamPeriodConfig] WHERE [FundingStreamPeriodCode] = '{fspCode}'");
            context.Database.ExecuteSqlRaw(
                $"delete from [FundingAllocation].[FspDeliverableConfig] where fspCode = '{fspCode}'");
            context.Database.ExecuteSqlRaw(
                $"delete from [FundingAllocation].[AllocationFundingStreamConfig] where [AllocationFundingStreamCode] = '{config.AllocationFundingStreamCode}' and [AllocationPeriodId] = '{config.AllocationPeriodId}'");
        }

        private static void CreateTableRows(FundingAllocationContext context, ProviderFundingInfo providerFundingInfo,
            FspCodeDeliverable fspCodeDeliverable, string providerCategory, AllocationFundingStreamConfig config)
        {
            context.ProviderTypeConfigRows.Add(new ProviderTypeConfig(providerFundingInfo.ProviderType, providerFundingInfo.ProviderSubType, providerCategory));

            context.AllocationLineConfigRows.Add(new AllocationLineConfig(providerFundingInfo.FundingStreamCode,
                providerFundingInfo.FundingPeriodId, providerFundingInfo.FundingLineCode,
                providerCategory, fspCodeDeliverable.FspCode, fspCodeDeliverable.DeliverableCode));

            context.FspDeliverableConfigRows.Add(new FspDeliverableConfig(fspCodeDeliverable.FspCode,
                 fspCodeDeliverable.DeliverableCode, fspCodeDeliverable.DeliverableName, fspCodeDeliverable.DisplayOrder));

            context.FundingStreamPeriodConfigRows.Add(new FundingStreamPeriodConfig(fspCodeDeliverable.FspCode,
                fspCodeDeliverable.FundingStreamCode, fspCodeDeliverable.AllocationReferencePrefix, DateTime.Now, DateTime.Now));
            context.AllocationFundingStreamConfigRows.Add(config);

            context.SaveChanges();
        }

        public static void CreateAllocationFundingStreamRowAndProviderCategoryException(FundingAllocationContext context,
            FundingAllocationLevelInfo fundingAllocationLevelInfo, ProviderCategoryException providerCategoryException)
        {
            context.AllocationFundingStreamConfigRows.Add(new AllocationFundingStreamConfig(
                fundingAllocationLevelInfo.AllocationFundingStreamCode,
                fundingAllocationLevelInfo.AllocationPeriod,
                fundingTypeCode: providerCategoryException.FundingTypeCode,
                fundingPeriodCode: providerCategoryException.FundingPeriodCode,
                "some fsp"));

            context.SaveChanges();

            const string sql =
                @"Insert into [FundingAllocation].[ProviderCategoryException]
                  ([FundingTypeCode],
                   [FundingPeriodCode],
                   [UKPRN],
                   [Category])
                  Values (@fundingTypeCode, @fundingPeriodCode, @ukprn, @category)";

            context.Database.GetDbConnection().Execute(sql, providerCategoryException);
        }

        private static void ClearAllocationFundingStreamRowAndProviderCategoryExceptionTables(FundingAllocationContext context, ProviderCategoryException providerCategoryException)
        {
            context.AllocationFundingStreamConfigRows.RemoveRange(context.AllocationFundingStreamConfigRows);
            
            context.SaveChanges();
            const string sql =
                @"Delete from [FundingAllocation].[ProviderCategoryException]
                  Where
                  [FundingTypeCode] = @fundingTypeCode
                  and [FundingPeriodCode] = @fundingPeriodCode
                  and [UKPRN] = @UKPRN";

            context.Database.GetDbConnection().Execute(sql, providerCategoryException);
        }

        private static void InsertCfsMappingConfig(string fundingTypeCode, string fundingPeriodCode, string category, string contractType)
        {
            using var context = new FundingAllocationContext(GetDbContextOptions());
            context.CfsCodesToContractTypeConfigRows.Add(
                new CfsCodesToContractTypeConfig(fundingTypeCode, fundingPeriodCode, category, contractType));
            context.SaveChanges();
        }

        private static void ClearDownCfsMappingConfig(string fundingTypeCode, string fundingPeriodCode, string category)
        {
            using var context = new FundingAllocationContext(GetDbContextOptions());
            context.CfsCodesToContractTypeConfigRows.Where(r => r.FundingTypeCode == fundingTypeCode && r.FundingPeriodCode == fundingPeriodCode &&
                                                                r.ProviderCategory == category)
                .ToList()
                .ForEach(r => context.CfsCodesToContractTypeConfigRows.Remove(r));

            context.SaveChanges();
        }

        private static void InsertAllocationFundingStreamConfig(string allocationFundingStreamCode, string allocationPeriodId, string fundingTypeCode, string fundingPeriodCode, string fspGroupCode)
        {
            using var context = new FundingAllocationContext(GetDbContextOptions());
            context.AllocationFundingStreamConfigRows.Add(new AllocationFundingStreamConfig(allocationFundingStreamCode,
                allocationPeriodId, fundingTypeCode, fundingPeriodCode, fspGroupCode));
            context.SaveChanges();
        }

        private static void ClearDownAllocationFundingStreamConfig(string allocationFundingStreamCode, string allocationPeriodId)
        {
            using var context = new FundingAllocationContext(GetDbContextOptions());
            context.AllocationFundingStreamConfigRows.Where(r => r.AllocationFundingStreamCode == allocationFundingStreamCode && r.AllocationPeriodId == allocationPeriodId)
                .ToList()
                .ForEach(
                r => context.AllocationFundingStreamConfigRows.Remove(r));

            context.SaveChanges();
        }

        private static void InsertProviderType(string providerType, string providerSubType, string category)
        {
            using var context = new FundingAllocationContext(GetDbContextOptions());
            context.ProviderTypeConfigRows.Add(new ProviderTypeConfig(providerType, providerSubType, category));
            context.SaveChanges();
        }

        private void ClearDownProviderTypeConfig(string providerType, string providerSubType)
        {
            using var context = new FundingAllocationContext(GetDbContextOptions());

            context.ProviderTypeConfigRows.Where(p => p.Type == providerType && p.Subtype == providerSubType).ToList().ForEach(
                p => context.ProviderTypeConfigRows.Remove(p));

            context.SaveChanges();
        }


        private static DbContextOptions<FundingAllocationContext> GetDbContextOptions()
        {
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];

            return new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;
        }


    }
}