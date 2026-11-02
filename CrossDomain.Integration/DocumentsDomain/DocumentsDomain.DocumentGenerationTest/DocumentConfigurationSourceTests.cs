namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using System.Collections.Generic;
    using System.IO;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore;
    using DataStore.Repositories;
    using DocumentDefiner.DocumentConfiguration;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Newtonsoft.Json;
    using UnitTests.Common;
    using FundingStreamPeriod = DataStore.Models.FundingStreamPeriod;

    [TestClass]
    public class DocumentConfigurationSourceTests
    {
        private IDocumentConfigurationSource _configSource;

        [TestInitialize]
        public void Initialize()
        {
            _configSource = GetDocumentConfigurationSourceWithMockRepositories();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestDeliverableConfigurationForDisplayVolumeFlag()
        {
            using (var context = new DocumentsDomainDbContext())
            {
                IDocumentConfigurationSource configSource =
                    new DocumentConfigurationSource(new FundingStreamPeriodRepository(context),
                        new FspDeliverableRepository(context), new FundingTypeFundingPeriodRepository(context));

                var deliverableConfiguration =
                    configSource.GetDeliverableConfigurationForFundingAgreement(
                        CreateAllocation("ESF", periodTypeCodeType.ESF, "1420", "ESF1420"), 4);

                Assert.IsTrue(deliverableConfiguration.ShouldDisplayVolume,
                    "ShouldDisplayVolume should have been true but was false");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestDeliverableConfigurationForSofGetDeliverableName()
        {
            using (var context = new DocumentsDomainDbContext())
            {
                IDocumentConfigurationSource configSource = new DocumentConfigurationSource(
                    new FundingStreamPeriodRepository(context),
                    new FspDeliverableRepository(context),
                    new FundingTypeFundingPeriodRepository(context));

                string deliverableName =
                    configSource.GetDeliverableNameForSummaryOfFunding(
                        CreateAllocation("16-18 APPS", periodTypeCodeType.AY, "1516", "16-18APPS1516"), 3);

                deliverableName.Should().Be("of which 16-18 Traineeships");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverableConfigurationSource_ShouldGetDeliverableNameForSummaryOfFunding_WhenCalledWithFspAndDeliverableCode()
        {
            using (var context = new DocumentsDomainDbContext())
            {
                // arrange
                var configSource = new DocumentConfigurationSource(
                    new FundingStreamPeriodRepository(context),
                    new FspDeliverableRepository(context),
                    new FundingTypeFundingPeriodRepository(context));

                // act
                string deliverableName =
                    configSource.GetDeliverableNameForSummaryOfFunding("16-18APPS1516", 3);

                // assert
                deliverableName.Should().Be("of which 16-18 Traineeships");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestDeliverableConfigurationForSofShouldDisplayDeliverable()
        {
            using (var context = new DocumentsDomainDbContext())
            {
                IDocumentConfigurationSource configSource =
                    new DocumentConfigurationSource(new FundingStreamPeriodRepository(context),
                        new FspDeliverableRepository(context),
                        new FundingTypeFundingPeriodRepository(context));

                contractDeliverablesTypeContractDeliverable deliverable =
                    new contractDeliverablesTypeContractDeliverable
                    {
                        deliverable = new deliverableType {deliverableCode = 3}
                    };
                bool shouldDipslay = configSource.ShouldDisplayDeliverableOnSummaryOfFunding(
                    CreateAllocation("16-18 APPS", periodTypeCodeType.AY, "1516", "16-18APPS1516"), deliverable);
                shouldDipslay.Should().Be(true);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverableConfigurationSource_ShouldGetDisplayDeliverableOnSummaryOfFunding_WhenCalledWithFspAndDeliverableCode()
        {
            using (var context = new DocumentsDomainDbContext())
            {
                // arrange
                var documentConfigurationSource = new DocumentConfigurationSource(
                    new FundingStreamPeriodRepository(context),
                    new FspDeliverableRepository(context),
                    new FundingTypeFundingPeriodRepository(context));

                // act
                bool shouldDisplay = documentConfigurationSource.ShouldDisplayDeliverableOnSummaryOfFunding("16-18APPS1516", 3);

                // assert
                shouldDisplay.Should().Be(true);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestDeliverableConfigurationForSofShouldNotDisplayDeliverable()
        {
            using (var context = new DocumentsDomainDbContext())
            {
                IDocumentConfigurationSource configSource =
                    new DocumentConfigurationSource(new FundingStreamPeriodRepository(context),
                        new FspDeliverableRepository(context),
                        new FundingTypeFundingPeriodRepository(context));

                contractDeliverablesTypeContractDeliverable deliverable =
                    new contractDeliverablesTypeContractDeliverable
                    {
                        deliverable = new deliverableType {deliverableCode = 5}
                    };
                bool shouldDipslay = configSource.ShouldDisplayDeliverableOnSummaryOfFunding(
                    CreateAllocation("16-18 APPS", periodTypeCodeType.AY, "1516", "16-18APPS1516"), deliverable);
                shouldDipslay.Should().Be(false);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestFundingAgreementDocumentGetTitle()
        {
            contractAllocationsContractAllocation allocation = new contractAllocationsContractAllocation
            {
                fundingStreamPeriodCode = "16-18APPS1516"
            };

            using (var context = new DocumentsDomainDbContext())
            {
                IDocumentConfigurationSource configSource =
                    new DocumentConfigurationSource(new FundingStreamPeriodRepository(context),
                        new FspDeliverableRepository(context),
                        new FundingTypeFundingPeriodRepository(context));

                string title = configSource.GetFundingAgreementTitleFromAllocation(allocation);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestGetFundingStreamPeriodDisplayOrderMainCl2()
        {
            using (var context = new DocumentsDomainDbContext())
            {
                IDocumentConfigurationSource configSource =
                    new DocumentConfigurationSource(new FundingStreamPeriodRepository(context),
                        new FspDeliverableRepository(context),
                        new FundingTypeFundingPeriodRepository(context));

                Assert.AreEqual(4,
                    configSource.GetFundingStreamPeriodDisplayOrder(CreateAllocation("CL", periodTypeCodeType.AY, "1516",
                        "CL1516")));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestGetFundingStreamPeriodDisplayOrderNullEntry()
        {
            using (var context = new DocumentsDomainDbContext())
            {
                IDocumentConfigurationSource configSource =
                    new DocumentConfigurationSource(new FundingStreamPeriodRepository(context),
                        new FspDeliverableRepository(context),
                        new FundingTypeFundingPeriodRepository(context));

                Assert.AreEqual(-1,
                    configSource.GetFundingStreamPeriodDisplayOrder(CreateAllocation("DUMMY", periodTypeCodeType.CY,
                        "1516", "DUMMY1516")));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestGetFundingStreamPeriodDisplayOrderNotFound()
        {
            using (var context = new DocumentsDomainDbContext())
            {
                IDocumentConfigurationSource configSource =
                    new DocumentConfigurationSource(new FundingStreamPeriodRepository(context),
                        new FspDeliverableRepository(context),
                        new FundingTypeFundingPeriodRepository(context));

                Assert.AreEqual(-1,
                    configSource.GetFundingStreamPeriodDisplayOrder(CreateAllocation("OTHER", periodTypeCodeType.AY,
                        "1516", "OTHER1516")));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestShouldDisplayDeliverableOnSummaryOfFundingAsto1617()
        {
            var contractDeliverables =
                new contractDeliverablesTypeContractDeliverable()
                {
                    deliverable = new deliverableType()
                    {
                        deliverableCode = 3

                    }
                };

            using (var context = new DocumentsDomainDbContext())
            {
                var configSource = new DocumentConfigurationSource(
                    new FundingStreamPeriodRepository(context),
                    new FspDeliverableRepository(context),
                    new FundingTypeFundingPeriodRepository(context));
                Assert.IsFalse(configSource.ShouldDisplayDeliverableOnSummaryOfFunding(
                    CreateAllocation("ASTO", periodTypeCodeType.AY, "1516", "ASTO1516"), contractDeliverables));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestGetAllocationNameForAdultSkills()
        {
            var allocation = new contractAllocationsContractAllocation()
            {
                description = "Adult Skills"
            };

            using (var context = new DocumentsDomainDbContext())
            {
                IDocumentConfigurationSource configSource =
                    new DocumentConfigurationSource(new FundingStreamPeriodRepository(context),
                        new FspDeliverableRepository(context),
                        new FundingTypeFundingPeriodRepository(context));

                Assert.AreEqual(configSource.GetAllocationName(allocation), "Adult Skills");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestGetFundingStreamPeriodDisplayOrder()
        {
            using (var context = new DocumentsDomainDbContext())
            {
                IDocumentConfigurationSource configSource =
                    new DocumentConfigurationSource(new FundingStreamPeriodRepository(context),
                        new FspDeliverableRepository(context),
                        new FundingTypeFundingPeriodRepository(context));

                Assert.AreEqual(4,
                    configSource.GetFundingStreamPeriodDisplayOrder(CreateAllocation("CL", periodTypeCodeType.AY, "1516",
                        "CL1516")));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentConfigurationSource_ShouldGetDisplayOrderFromFspRepository()
        {
            const int displayOrder = 2;

            IDocumentConfigurationSource source = new DocumentConfigurationSource(
                new FundingStreamPeriodRepository(new DocumentsDomainDbContext()), Mock.Of<IFspDeliverableRepository>(),
                Mock.Of<IFundingTypeFundingPeriodRepository>());
            int displayOrderReturned = source.GetFundingStreamPeriodDisplayOrder(CreateAllocation("AAPP", periodTypeCodeType.CM, "1718", "AAPP1718"));

            Assert.AreEqual(displayOrder, displayOrderReturned);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestGetDisplayNameFromFSC()
        {
            using (var context = new DocumentsDomainDbContext())
            {
                IDocumentConfigurationSource configSource =
                    new DocumentConfigurationSource(new FundingStreamPeriodRepository(context),
                        new FspDeliverableRepository(context),
                        new FundingTypeFundingPeriodRepository(context));

                Assert.AreEqual("^tof which 16-18 Traineeships Programme Funding",
                    configSource.GetDeliverableConfigurationForFundingAgreement(
                            CreateAllocation("16-18 APPS", periodTypeCodeType.AY, "1516", "16-18APPS1516"), 4)
                        .DisplayName);
            }
        }
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentConfigurationSource_ShouldGetDisplayNameFromFspRepository()
        {
            const string displayName = "Adult Apprenticeships";

            IDocumentConfigurationSource source = new DocumentConfigurationSource(
                new FundingStreamPeriodRepository(new DocumentsDomainDbContext()), Mock.Of<IFspDeliverableRepository>(),
                Mock.Of<IFundingTypeFundingPeriodRepository>());
            string displayNameReturned = source.GetAllocationName(CreateAllocation("AAPP", periodTypeCodeType.CM, "1718", "AAPP1718"));

            Assert.AreEqual(displayName, displayNameReturned);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentConfigurationSource_ShouldGetDisplayNameFromAllocationWhenDisplayNameIsEmptyString()
        {
            const string displayName = "";
            Mock<IFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fspRepositoryMock.Setup(r => r.GetByKey(It.IsAny<string>())).Returns(new FundingStreamPeriod(fundingStreamPeriodCode: "OLASS1617", summaryOfFundingDisplayName: displayName, displayOrder: 1, shouldGenerateFundingAgreement: true, shouldUseContractAllocationDescription: true, template: string.Empty, extraPagesTemplate: string.Empty, fspGroupCode:string.Empty, fundingAgreementDisplayName: string.Empty));

            IDocumentConfigurationSource source = new DocumentConfigurationSource(
                fspRepositoryMock.Object, Mock.Of<IFspDeliverableRepository>(), Mock.Of<IFundingTypeFundingPeriodRepository>());
            var allocation = CreateAllocation("OLASS", periodTypeCodeType.CM, "1617", "OLASS1617");
            allocation.description = "SOME NAME";
            string displayNameReturned = source.GetAllocationName(allocation);

            Assert.AreEqual(allocation.description, displayNameReturned);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestLoadFromFileWithAggregates()
        {
            using (var context = new DocumentsDomainDbContext())
            {
                IDocumentConfigurationSource configSource =
                    new DocumentConfigurationSource(new FundingStreamPeriodRepository(context),
                        new FspDeliverableRepository(context),
                        new FundingTypeFundingPeriodRepository(context));

                DeliverableConfiguration delConfig =
                    configSource.GetDeliverableConfigurationForFundingAgreement(
                        CreateAllocation("16-18TRN1718", periodTypeCodeType.AY, "1718", "16-18TRN1718"), 0);

                Assert.AreEqual(2, delConfig.DisplayValueIsAggregate.Length,
                    "Aggregate array is not of the correct length");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestGetFundingAgreementTitleFromAllocationUsingAllocationDescription()
        {
            const string allocationDescription = "OLASS - UOP NAME";

            using (var context = new DocumentsDomainDbContext())
            {
                IDocumentConfigurationSource configSource =
                    new DocumentConfigurationSource(new FundingStreamPeriodRepository(context),
                        new FspDeliverableRepository(context),
                        new FundingTypeFundingPeriodRepository(context));

                contractAllocationsContractAllocation allocation =
                    CreateAllocation("OLASS", periodTypeCodeType.AY, "1516", "OLASS1516");
                allocation.description = allocationDescription;

                Assert.AreEqual(allocationDescription, configSource.GetFundingAgreementTitleFromAllocation(allocation));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestGetFundingAgreementTitleFromAllocationUsingFSCLookup()
        {
            const string allocationDescription = "Don't Use This Title";
            using (var context = new DocumentsDomainDbContext())
            {
                IDocumentConfigurationSource configSource =
                    new DocumentConfigurationSource(new FundingStreamPeriodRepository(context),
                        new FspDeliverableRepository(context),
                        new FundingTypeFundingPeriodRepository(context));

                contractAllocationsContractAllocation allocation =
                    CreateAllocation("16-18 APPS", periodTypeCodeType.AY, "1516", "16-18APPS1516");
                allocation.description = allocationDescription;

                Assert.AreNotEqual(allocationDescription, configSource.GetFundingAgreementTitleFromAllocation(allocation));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TestGetFundingAgreementTitleFromAllocationForUnknownAllocation()
        {
            const string allocationDescription = "OLASS - UOP NAME";

            using (var context = new DocumentsDomainDbContext())
            {
                IDocumentConfigurationSource configSource =
                    new DocumentConfigurationSource(new FundingStreamPeriodRepository(context),
                        new FspDeliverableRepository(context),
                        new FundingTypeFundingPeriodRepository(context));

                contractAllocationsContractAllocation allocation =
                    CreateAllocation("UNKNOWN", periodTypeCodeType.AY, "1516", "UNKNOWN");
                allocation.description = allocationDescription;

                Assert.AreEqual(allocationDescription, configSource.GetFundingAgreementTitleFromAllocation(allocation));
            }
        }

        private contractAllocationsContractAllocation CreateAllocation(string fundingStreamCode, periodTypeCodeType codeType, string period, string fundingStreamPeriodCode)
        {
            return new contractAllocationsContractAllocation()
            {
                period = new period()
                {
                    periodType = new periodTypeType()
                    {
                        periodTypeCode = codeType
                    },
                    period1 = period
                },
                fundingStream = new fundingStream()
                {
                    fundingStreamCode = fundingStreamCode
                },
                fundingStreamPeriodCode = fundingStreamPeriodCode                
            };
        }

        internal static DocumentConfigurationSource GetDocumentConfigurationSourceWithMockRepositories()
        {
            List<FundingStreamPeriod> fsps = GetFundingStreamPeriodsFromFile();

            Mock<IFundingStreamPeriodRepository> fundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepositoryMock.Setup(r => r.GetAll())
                .Returns(fsps);

            return new DocumentConfigurationSource(fundingStreamPeriodRepositoryMock.Object,
                Mock.Of<IFspDeliverableRepository>(),
                Mock.Of<IFundingTypeFundingPeriodRepository>());
        }

        private static List<FundingStreamPeriod> GetFundingStreamPeriodsFromFile()
        {
            using (
                TestResource resource = new TestResource("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests",
                    @"Resources.DocumentsDomain_FSP.json"))
            {
                using (StreamReader sr = new StreamReader(resource.Stream))
                {
                    return JsonConvert.DeserializeObject<List<FundingStreamPeriod>>(sr.ReadToEnd());
                }
            }
        }


        public static IFundingTypeFundingPeriodQueryRepository GetMockFpQueryRepository(IReadOnlyCollection<MockQueryRepositorySetup> setups)
        {
            var repository = new Mock<IFundingTypeFundingPeriodQueryRepository>();

            foreach (var setup in setups)
            {
                var ret = new FundingTypeFundingPeriod
                {
                    FundingTypeCode = setup.FundingTypeCode,
                    FundingPeriodName = setup.FundingPeriodName,
                    TemplateName = setup.OutputTemplateName
                };

                repository.Setup(r => r.Get(setup.FundingTypeCode, setup.FundingPeriodName)).Returns(ret);
            }

            return repository.Object;
        }
    }

    public class MockQueryRepositorySetup
    {
        public MockQueryRepositorySetup(string fundingTypeCode, string fundingPeriodName, string outputTemplateName)
        {
            FundingTypeCode = fundingTypeCode;
            FundingPeriodName = fundingPeriodName;
            OutputTemplateName = outputTemplateName;
        }

        public string FundingTypeCode { get; }

        public string FundingPeriodName { get; }

        public string OutputTemplateName { get; }
    }
}
    
    


