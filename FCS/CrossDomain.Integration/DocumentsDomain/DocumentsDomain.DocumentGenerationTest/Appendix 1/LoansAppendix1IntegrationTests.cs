namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Appendix_1
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using Common.Models;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore;
    using DataStore.Repositories;
    using DocumentDefiner.DocumentConfiguration;
    using DocumentDefiner.DocumentPartCreators.Appendix1;
    using Integration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Newtonsoft.Json;
    using PaymentManagementDomain.PolicyCache.DataStore;
    using UnitTests.Common;

    [TestClass]
    public class LoansAppendix1IntegrationTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void LoansAppendix1_ShouldGetCorrectTotalRow()
        {
            // arrange
            Mock<ITemplateRepository> templateRepository = new Mock<ITemplateRepository>();
            IDictionary<string, DocumentGenerationRequest> requests;
            contract contract = GetCorporateContract("DocGenCommand_ALLF1819.json");

            using (var paymentManagementPolicyContext = new PaymentManagementPolicyContext())
            using (var documentDomainDbContext = new DocumentsDomainDbContext())
            using (var contractManagementDbContext = new ContractManagementDbContext())
            {
                LoansAppendix1 apendix1 = new LoansAppendix1(
                templateRepository.Object,
                new DocumentConfigurationSource(new FundingStreamPeriodRepository(documentDomainDbContext), new FspDeliverableRepository(documentDomainDbContext), new FundingTypeFundingPeriodRepository(documentDomainDbContext)),
                FundingTypeFundingPeriodQueryRepository.CreateInstance(contractManagementDbContext),
                paymentManagementPolicyContext);

                // act
                requests = apendix1.SupplyDocumentGenerationRequest("", contract, "");
            }

            // assert
            const string columnToCheck = "ContractTotal";
            MergeFieldType mergeFieldTypeT1 = requests.Values.First()
                .MergeData.MergeFields.Single(mf => mf.Name == columnToCheck);
            decimal total = 36230.0m + 32589.0m;
            Assert.AreEqual(total, decimal.Parse(mergeFieldTypeT1.Value), $"The column value for {columnToCheck} is incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void LoansAppendix1_ShouldGetCorrectRowInCorrectOrder()
        {
            // arrange
            Mock<ITemplateRepository> templateRepository = new Mock<ITemplateRepository>();
            IDictionary<string, DocumentGenerationRequest> requests;
            contract contract = GetCorporateContract("LoansDocGenCommand.json");

            using (var paymentManagementPolicyContext = new PaymentManagementPolicyContext())
            using (var documentDomainDbContext = new DocumentsDomainDbContext())
            using (var contractManagementDbContext = new ContractManagementDbContext())
            {
                LoansAppendix1 apendix1 = new LoansAppendix1(
                templateRepository.Object,
                new DocumentConfigurationSource(new FundingStreamPeriodRepository(documentDomainDbContext), new FspDeliverableRepository(documentDomainDbContext), new FundingTypeFundingPeriodRepository(documentDomainDbContext)),
                FundingTypeFundingPeriodQueryRepository.CreateInstance(contractManagementDbContext),
                paymentManagementPolicyContext);

                // act
                requests = apendix1.SupplyDocumentGenerationRequest("", contract, "");
            }

            // assert
            const string columnToCheck = "ContractTotal";
            MergeFieldType mergeFieldTypeT1 = requests.Values.First()
                .MergeData.MergeFields.Single(mf => mf.Name == columnToCheck);
            var allocationNameList = requests.Values.First().MergeData.RepeatingSections.First().Rows.Select(r => r.MergeFields.First().Value).ToList();

            Assert.AreEqual("Advanced Learner Loans Facility", allocationNameList[0], "The first allocation is wrong");
            Assert.AreEqual("Career Learning Pilots", allocationNameList[1], "The second allocation is wrong");
            Assert.AreEqual("Advanced Learner Loans Bursary", allocationNameList[2], "The third allocation is wrong");
        }

        private contract GetCorporateContract(string fileName)
        {
            using (var resource = new TestResource("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests", $@"Resources.{fileName}"))
            {
                return
                    (contract)
                        new JsonSerializer().Deserialize(new StreamReader(resource.Stream), typeof(contract));
            }
        }
    }
}
