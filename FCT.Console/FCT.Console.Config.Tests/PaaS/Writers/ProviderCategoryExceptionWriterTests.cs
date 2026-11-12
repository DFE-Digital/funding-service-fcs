namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using ExcelTypes;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class ProviderCategoryExceptionWriterTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ProviderCategoryExceptionWriter_ShouldInsertData()
        {
            // Arrange
            var expectedCategoryException1 = new ProviderCategoryException
            {
                FundingTypeCode = "FundingCode1",
                FundingPeriodCode = "FundingPeriodCode1",
                UKPRN = "Ukprn1",
                Category = "ProviderCategory1",
                PolicyStatus = PolicyStatus.Approved
            };

            var expectedCategoryException2 = new ProviderCategoryException
            {
                FundingTypeCode = "FundingCode2",
                FundingPeriodCode = "FundingPeriodCode2",
                UKPRN = "Ukprn2",
                Category = "ProviderCategory2",
                PolicyStatus = PolicyStatus.Approved
            };

            var categoryExceptions = new[] {expectedCategoryException1, expectedCategoryException2};

            RemoveAll();

            // Act
            ProviderCategoryExceptionWriter.WriteToPaas(categoryExceptions, WriterBehaviour.AddOrUpdate).Wait();

            // Assert
            var allItems = GetAll();
            
            foreach (var updatedException in categoryExceptions)
            {
                allItems.Should().Contain(item =>
                    item.Equals(updatedException) && item.Category == updatedException.Category);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ProviderCategoryExceptionWriter_ShouldDeleteData()
        {
            // Arrange
            var expectedCategoryException1 = new ProviderCategoryException
            {
                FundingTypeCode = "FundingCode1",
                FundingPeriodCode = "FundingPeriodCode1",
                UKPRN = "Ukprn1",
                Category = "ProviderCategory1",
                PolicyStatus = PolicyStatus.Removed
            };

            var expectedCategoryException2 = new ProviderCategoryException
            {
                FundingTypeCode = "FundingCode2",
                FundingPeriodCode = "FundingPeriodCode2",
                UKPRN = "Ukprn2",
                Category = "ProviderCategory2",
                PolicyStatus = PolicyStatus.Removed
            };

            var categoryExceptions = new[] {expectedCategoryException1, expectedCategoryException2};

            RemoveAll();
            InsertAll(categoryExceptions);

            // Act
            ProviderCategoryExceptionWriter.WriteToPaas(categoryExceptions, WriterBehaviour.Delete).Wait();

            // Assert
            var allItems = GetAll();
            allItems.Should().BeEmpty();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ProviderCategoryExceptionWriter_ShouldUpdateData()
        {
            // Arrange
            var categoryException1 = new ProviderCategoryException
            {
                FundingTypeCode = "FundingCode1",
                FundingPeriodCode = "FundingPeriodCode1",
                UKPRN = "Ukprn1",
                Category = "ProviderCategory1"
            };

            var categoryException2 = new ProviderCategoryException
            {
                FundingTypeCode = "FundingCode2",
                FundingPeriodCode = "FundingPeriodCode2",
                UKPRN = "Ukprn2",
                Category = "ProviderCategory2"
            };

            var updateCategoryException1 = new ProviderCategoryException
            {
                FundingTypeCode = "FundingCode1",
                FundingPeriodCode = "FundingPeriodCode1",
                UKPRN = "Ukprn1",
                Category = "NewProviderCategory1",
                PolicyStatus = PolicyStatus.Approved
            };

            var updateCategoryException2 = new ProviderCategoryException
            {
                FundingTypeCode = "FundingCode2",
                FundingPeriodCode = "FundingPeriodCode2",
                UKPRN = "Ukprn2",
                Category = "NewProviderCategory2",
                PolicyStatus = PolicyStatus.Approved
            };

            var categoryExceptions = new[] {categoryException1, categoryException2};
            var updateCategoryExceptions = new[] {updateCategoryException1, updateCategoryException2};

            RemoveAll();
            InsertAll(categoryExceptions);

            // Act
            ProviderCategoryExceptionWriter.WriteToPaas(updateCategoryExceptions, WriterBehaviour.AddOrUpdate).Wait();

            // Assert
            var allItems = GetAll();

            foreach (var updatedException in updateCategoryExceptions)
            {
                allItems.Should().Contain(item =>
                    item.Equals(updatedException) && item.Category == updatedException.Category);
            }

            foreach (var updatedException in categoryExceptions)
            {
                allItems.Should().NotContain(item =>
                    item.Equals(updatedException) && item.Category == updatedException.Category);
            }
        }

        private void RemoveAll()
        {
            var connectionString =
                ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Execute(@"delete from [FundingAllocation].[ProviderCategoryException]");
            }
        }

        private void InsertAll(params ProviderCategoryException[] providerCategoryExceptions)
        {
            var connectionString =
                ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Execute(
                    @"insert into [FundingAllocation].[ProviderCategoryException] 
                            (FundingTypeCode, FundingPeriodCode, UKPRN, Category)
                          values (@FundingTypeCode, @FundingPeriodCode, @UKPRN, @Category)",
                    providerCategoryExceptions);
            }
        }

        private IReadOnlyCollection<ProviderCategoryException> GetAll()
        {
            var connectionString =
                ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                const string sql = @"select * from [FundingAllocation].[ProviderCategoryException]";

                return connection.Query<ProviderCategoryException>(sql).ToList();
            }
        }
    }
}
