namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Appendix_1
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Common.Models;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore;
    using DataStore.Repositories;
    using DocumentDefiner.DocumentConfiguration;
    using DocumentDefiner.DocumentPartCreators.Appendix1;
    using Framework.Logging;
    using Integration;
    using IoC;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PaymentManagementDomain.PolicyCache.DataStore;
    using UnitTests.Common;
    using FundingStreamPeriod = DataStore.Models.FundingStreamPeriod;

    [TestClass]
    public class RegularAppendix1AebTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void RegularAppendix1_IsDocumentPartRequired_ShouldReturnFalseForAeb()
        {
            // arrange
            contractType corpContract = TestResource.FromJson<Contract>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources", "corpContractAeb.json");
            RegularAppendix1 aebAppendix1 = new RegularAppendix1(null, null, null, null);

            // act
            bool isDocumentPartRequired = aebAppendix1.IsDocumentPartRequired(corpContract);

            // assert
            Assert.IsFalse(isDocumentPartRequired);
        }


        [TestMethod, TestCategory("UnitTest")]
        public void RegularAppendix1_RequiredHeaderDocumentName_ShouldThrowApplicationException()
        {
            // Arrange
            var aebAppendix1 = new RegularAppendix1(null, null, null, null);

            // Act & Assert
            Assert.ThrowsExactly<ApplicationException>(() =>
            {
                // Accessing the property should throw
                var _ = aebAppendix1.RequiredHeaderDocumentName;
            });
        }


        [TestMethod, TestCategory("UnitTest")]
        public void RegularAppendix1_IsHeaderDocumentRequired_ShouldReturnFalse()
        {
            // arrange
            RegularAppendix1 aebAppendix1 = new RegularAppendix1(null, null, null, null);

            // act
            bool isHeaderDocumentRequired = aebAppendix1.IsHeaderDocumentRequired;

            // assert
            Assert.IsFalse(isHeaderDocumentRequired);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void RegularAppendix1_SupplyDocumentGenerationRequest_ShouldReturnExpectedDocumentGenerationRequest()
        {
            // arrange
            contractType corpContract = TestResource.FromJson<Contract>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources", "corpContractAeb.json");
            int expectedNumberRepeatingSections =
                corpContract.contractAllocations.SelectMany(ca => ca.contractDeliverables.Select(cd => cd.deliverable.deliverableName))
                .Distinct()
                .Count();
            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests;

            using (IWindsorContainer container = GetDocumentGenerationEndpointContainer())
            using (container.BeginScope())
            {
                var aebAppendix1 = new RegularAppendix1(
                    container.Resolve<ITemplateRepository>(),
                    new TestDocumentConfigurationSource(container.Resolve<IFundingStreamPeriodRepository>(), container.Resolve<IFspDeliverableRepository>()), 
                    container.Resolve<IFundingTypeFundingPeriodQueryRepository>(),
                    container.Resolve<IPaymentManagementPolicyContext>());

                // act
                documentGenerationRequests = aebAppendix1.SupplyDocumentGenerationRequest("ESFA-34928", corpContract, ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"]);
            }

            // assert
            Assert.IsNotNull(documentGenerationRequests, "Return value was null");
            Assert.AreEqual(1, documentGenerationRequests.Count, "Unexpected number of requests returned");
            Assert.IsTrue(documentGenerationRequests.ContainsKey("1000"), "Request keyed by 1000 was not returned");

            List<RowType> repeatingSectionRows = documentGenerationRequests["1000"].MergeData.RepeatingSections.First().Rows;
            Assert.AreEqual(expectedNumberRepeatingSections, repeatingSectionRows.Count, "The number of rows in the repeating section is incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void RegularAppendix1_ShouldSumChildDeliverablesForMultipleDeliveryOrganisations()
        {
            // arrange
            Mock<ITemplateRepository> templateRepositoryMock = new Mock<ITemplateRepository>();
            templateRepositoryMock.Setup(m =>
                    m.GetNameOfTemplateActiveOnDate(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<DateTime>()))
                .Returns(string.Empty);

            // child contract
            var contract = TestResource.FromJson<contractType>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests",
                "Resources.1819AebContract.json");

            // deliverables need to be flattened as they would at the handler
            contract.contractAllocations.ForEach(a =>
            {
                a.contractDeliverables = a.FlattenDeliverables(a.contractDeliverables);
            });

            using (var documentsDomainDbContext = new DocumentsDomainDbContext())
            using (var contractManagementContext = new ContractManagementDbContext())
            using (var paymentManagementContext = new PaymentManagementPolicyContext())
            {
                var docCreator = new RegularAppendix1(templateRepositoryMock.Object,
                    new DocumentConfigurationSource(
                        new FundingStreamPeriodRepository(documentsDomainDbContext),
                        new FspDeliverableRepository(documentsDomainDbContext),
                        new FundingTypeFundingPeriodRepository(documentsDomainDbContext)),
                    FundingTypeFundingPeriodQueryRepository.CreateInstance(contractManagementContext),
                    paymentManagementContext);

                // act
                var docGenReq = docCreator.SupplyDocumentGenerationRequest("ESFA-322", contract, string.Empty).Values.First(); // get the only request in the dictionary

                var mainTable = docGenReq.MergeData.RepeatingSections.First();

                // assert
                Assert.AreEqual(4, mainTable.Rows.Count, "The count of rows in the repeating section was incorrect");

                var appsCarryInRow = mainTable.Rows.First();

                Assert.AreEqual("APPS", appsCarryInRow.MergeFields.Single(mf => mf.Name == "Column2").Value,
                    "The document did not use allocation prefix instead of allocation ref");
                Assert.AreEqual("45722.00", appsCarryInRow.MergeFields.Single(mf => mf.Name == "Column3").Value,
                    "The document did not correctly sum all FY 1 values for the funding stream");
                Assert.AreEqual("16253.00", appsCarryInRow.MergeFields.Single(mf => mf.Name == "Column4").Value,
                    "The document did not correctly sum all FY 2 values for the funding stream");
                Assert.AreEqual("61975.00", appsCarryInRow.MergeFields.Single(mf => mf.Name == "Column5").Value,
                    "The document did not correctly sum all planned values for the funding stream total");

                var ofWhichRow = mainTable.Rows.Last();

                Assert.IsTrue(ofWhichRow.MergeFields.Single(mf => mf.Name == "Column1").Value.Contains("of which Community Learning"),
                    "Last row was not \"of which\" row or did not contain correct title");
                Assert.AreEqual("39412.00", ofWhichRow.MergeFields.Single(mf => mf.Name == "Column3").Value,
                    "The document did not correctly sum all FY 1 values for the funding stream for the child deliverable");
                Assert.AreEqual("19401.00", ofWhichRow.MergeFields.Single(mf => mf.Name == "Column4").Value,
                    "The document did not correctly sum all FY 2 values for the funding stream for the child deliverable");
                Assert.AreEqual("58813.00", ofWhichRow.MergeFields.Single(mf => mf.Name == "Column5").Value,
                    "The document did not correctly sum all planned values for the child deliverable total");
            }
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void RegularAppendix1_SupplyDocumentGenerationRequest_AEBC1819_ShouldReturnExpectedDocumentGenerationRequest()
        {
            // arrange
            contractType corpContract = TestResource.FromJson<Contract>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources", "corpContractAeb1819.json");

            int expectedNumberRepeatingSections =
                corpContract.contractAllocations.SelectMany(ca => ca.contractDeliverables.Select(cd => cd.deliverable.deliverableName))
                .Distinct()
                .Count();
            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests;

            using (IWindsorContainer container = GetDocumentGenerationEndpointContainer())
            using (container.BeginScope())
            {
                var aebAppendix1 = new RegularAppendix1(
                    container.Resolve<ITemplateRepository>(),
                    new TestDocumentConfigurationSource(container.Resolve<IFundingStreamPeriodRepository>(), container.Resolve<IFspDeliverableRepository>()),
                    container.Resolve<IFundingTypeFundingPeriodQueryRepository>(),
                    container.Resolve<IPaymentManagementPolicyContext>());

                // act
                documentGenerationRequests = aebAppendix1.SupplyDocumentGenerationRequest("ESFA-34928", corpContract, ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"]);
            }

            // assert
            List<RowType> repeatingSectionRows = documentGenerationRequests["1000"].MergeData.RepeatingSections.First().Rows;

            Assert.IsTrue(repeatingSectionRows[3].MergeFields[0].Value.Contains("of which Community Learning"), "'of which Community Learning' text not in the expected place");
        }

        private static IWindsorContainer GetDocumentGenerationEndpointContainer()
        {
            return WindsorInstallerForDocumentGenerator.Container;
        }

        private class TestDocumentConfigurationSource : DocumentConfigurationSource
        {
            public TestDocumentConfigurationSource(IFundingStreamPeriodRepository fundingStreamPeriodRepository, IFspDeliverableRepository fspDeliverableRepository) : base(fundingStreamPeriodRepository, fspDeliverableRepository, new FundingTypeFundingPeriodRepository(new DocumentsDomainDbContext()))
            {
            }

            protected override IDictionary<string, FundingStreamPeriod> AllocationSettingsForSummaryOfFunding
            {
                get
                {
                    using (var documentDomainDbContext = new DocumentsDomainDbContext())
                    {
                        return new FundingStreamPeriodRepository(documentDomainDbContext).GetAll().ToDictionary(fsp => fsp.FundingStreamPeriodCode);
                    }
                }
            }
        }
    }
}