namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.DocumentsDomain.DataStore;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;
    using UnitTests.Common;

    [TestClass]
    public class DocumentsDomainContractReferenceConfigWriterTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentsDomainContractReferenceConfigWriter_ShouldWriteRowToTable()
        {
            // arrange
            const int ukprn = 12345;
            const string fspCode = "fspCode";
            const decimal financialEnvelope1Funding = 1.1m;
            const decimal financialEnvelope2Funding = 2.21m;

            TearDown(ukprn, fspCode);

            var sheet = new ContractReferenceDataSheet
            {
                PolicyStatus = PolicyStatus.Approved,
                Ukprn = ukprn,
                FundingStreamPeriodCode = fspCode,
                FinancialEnvelope1Funding = financialEnvelope1Funding,
                FinancialEnvelope2Funding = financialEnvelope2Funding
            };

            // act
            DocumentsDomainContractReferenceConfigWriter.WriteToPaaSDatabase(new []{sheet}, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new DocumentsDomainDbContext())
            {
                var storedEntity = context.ContractReferenceConfigs.SingleOrDefault(crc =>
                    crc.Ukprn == ukprn && crc.FundingStreamPeriodCode == fspCode);

                Assert.IsNotNull(storedEntity, "Entity not stored");
                Assert.AreEqual(financialEnvelope1Funding, storedEntity.FinancialEnvelope1Funding, "financialEnvelope1Funding incorrect");
                Assert.AreEqual(financialEnvelope2Funding, storedEntity.FinancialEnvelope2Funding, "financialEnvelope2Funding incorrect");
            }

            TearDown(ukprn, fspCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentsDomainContractReferenceConfigWriter_ShouldUpdateRowInTable()
        {
            // arrange
            const int ukprn = 12345;
            const string fspCode = "fspCode";
            const decimal financialEnvelope1Funding = 1.1m;
            const decimal financialEnvelope2Funding = 2.21m;

            TearDown(ukprn, fspCode);
            using (var context = new DocumentsDomainDbContext())
            {
                context.ContractReferenceConfigs.Add(new ContractReferenceConfig(ukprn, fspCode, -1000m, -2000m));
                context.SaveChanges();
            }

            var sheet = new ContractReferenceDataSheet
            {
                PolicyStatus = PolicyStatus.Approved,
                Ukprn = ukprn,
                FundingStreamPeriodCode = fspCode,
                FinancialEnvelope1Funding = financialEnvelope1Funding,
                FinancialEnvelope2Funding = financialEnvelope2Funding
            };

            // act
            DocumentsDomainContractReferenceConfigWriter.WriteToPaaSDatabase(new[] { sheet }, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new DocumentsDomainDbContext())
            {
                var storedEntity = context.ContractReferenceConfigs.SingleOrDefault(crc =>
                    crc.Ukprn == ukprn && crc.FundingStreamPeriodCode == fspCode);

                Assert.IsNotNull(storedEntity, "Entity not stored");
                Assert.AreEqual(financialEnvelope1Funding, storedEntity.FinancialEnvelope1Funding, "financialEnvelope1Funding incorrect");
                Assert.AreEqual(financialEnvelope2Funding, storedEntity.FinancialEnvelope2Funding, "financialEnvelope2Funding incorrect");
            }

            TearDown(ukprn, fspCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentsDomainContractReferenceConfigWriter_ShouldDeleteRowFromTable()
        {
            // arrange
            const int ukprn = 12345;
            const string fspCode = "fspCode";
            const decimal financialEnvelope1Funding = 1.1m;
            const decimal financialEnvelope2Funding = 2.21m;

            TearDown(ukprn, fspCode);
            using (var context = new DocumentsDomainDbContext())
            {
                context.ContractReferenceConfigs.Add(new ContractReferenceConfig(ukprn, fspCode, financialEnvelope1Funding, financialEnvelope2Funding));
                context.SaveChanges();
            }

            var sheet = new ContractReferenceDataSheet
            {
                PolicyStatus = PolicyStatus.Removed,
                Ukprn = ukprn,
                FundingStreamPeriodCode = fspCode,
                FinancialEnvelope1Funding = financialEnvelope1Funding,
                FinancialEnvelope2Funding = financialEnvelope2Funding
            };

            // act
            DocumentsDomainContractReferenceConfigWriter.WriteToPaaSDatabase(new[] { sheet }, WriterBehaviour.Delete);

            // assert
            using (var context = new DocumentsDomainDbContext())
            {
                var storedEntity = context.ContractReferenceConfigs.SingleOrDefault(crc =>
                    crc.Ukprn == ukprn && crc.FundingStreamPeriodCode == fspCode);

                Assert.IsNull(storedEntity, "Entity still present in table");
            }
        }

        public void TearDown(int ukprn, string fspCode)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.ContractReferenceConfigs.RemoveWhere(crc =>
                    crc.Ukprn == ukprn && crc.FundingStreamPeriodCode == fspCode);
                context.SaveChanges();
            }
        }
    }
}