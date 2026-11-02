namespace FundingAllocation.Tests.Endpoints.ReleaseGroup
{
    using System.Collections.Generic;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using DataStore.Model;
    using FundingAllocation.Infrastructure;
    using FundingAllocation.Endpoints.ReleaseGroup;
    using FundingAllocation.Endpoints.ReleaseGroup.Handlers;
    using FundingAllocation.Endpoints.ReleaseGroup.Repositories;
    using FundingAllocation.Repositories;
    using FundingAllocation.Services;
    using Microsoft.Data.SqlClient;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.Framework.Logging.Interfaces;
    using FundingAllocation.Endpoints.ReleaseGroup.Services;
    using FundingAllocation.Dto;
    using LanguageExt;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos; 

    [TestClass]
    public class CreateContractForFundingAllocationContractGroupHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CreateContractForFundingAllocationContractGroupHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<CreateContractForFundingAllocationContractGroupHandler>());

            container.BeginScope();

            // act
            container.Resolve<CreateContractForFundingAllocationContractGroupHandler>();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void CreateContractForFundingAllocationContractGroupHandler_Technical()
        {
            const int deliveryOrg = 1234;
            const string ukprn = "5678";
            const decimal plannedValueJan = 42m;
            const decimal plannedValueFeb = 52m;

            FundingAllocation fundingAllocation = new FundingAllocation(
                "", "", "AS-2021", "1619",
                ukprn, -1, -1, -1,
                1, 1)
            {
                ProviderFundingAllocations =
                {
                    new ProviderFundingAllocation("", "")
                    {
                        ProviderFunding = new ProviderFunding("", deliveryOrg, "FURTH", "01GFE")
                        {
                            FundingAllocationLines =
                            {
                                new FundingAllocationLine("", "1619-001")
                                {
                                    FundingAllocationProfilePeriods =
                                    {
                                        new FundingAllocationProfilePeriod("", "", 202101, plannedValueJan),
                                        new FundingAllocationProfilePeriod("", "", 202102, plannedValueFeb)
                                    }
                                },
                                new FundingAllocationLine("", "1619-002")
                                {
                                    FundingAllocationProfilePeriods =
                                    {
                                        new FundingAllocationProfilePeriod("", "", 202101, plannedValueJan),
                                        new FundingAllocationProfilePeriod("", "", 202102, plannedValueFeb)
                                    }
                                }
                            }
                        }
                    }
                }
            };

            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;
            ContractDeliverableEnricher enricher = new ContractDeliverableEnricher(Mock.Of<IConfigurationRoot>());
            using var context = new FundingAllocationContext(options);
            Mock<IReleaseGroupFundingAllocationRepository> allocationAllocationRepMock = new Mock<IReleaseGroupFundingAllocationRepository>();
            allocationAllocationRepMock.Setup(r => r.GetFundingAllocationForId(It.IsAny<string>()))
                .ReturnsAsync(fundingAllocation);
            CreateContractForFundingAllocationContractGroupHandler handler =
                new CreateContractForFundingAllocationContractGroupHandler(
                    Mock.Of<ILogger>(),
                    Mock.Of<IContractStorage>(),
                    new FundingAllocationsToContractTransformer(new CfsToFcsCodeMappingService(new ContractTypeRepository(context),
                        new ProviderCategoryRepository(context), new AllocationFundingStreamConfigRepository(context), new AllocationLineConfigRepository(context)), new FundingStreamPeriodRepository(context)),
                    new ReleaseGroupFundingAllocationRepository(context),
                    Mock.Of<IExtendedContractTypeTransformer>(),
                    new ContractNumberQueryRepository(context),
                    new ContractCommandRepository(context),
                    Mock.Of<IContractNumbersAndVersionIntentService>(),
                    new ContractValueAggregator(), enricher, Mock.Of<IConfigurationRoot>());

            // act
            handler.Handle(new CreateContractForFundingAllocationContractGroupCommand
            {
                FundingAllocationIds = new List<string>
                    {
                        "PSG-AY-2021-Contract-Provider-10017069-3_6"
                    }
            },
                new TestableMessageHandlerContext()).Wait();
        }
        
        [TestMethod, TestCategory("TechnicalExploration")]
        public void CreateContractForFundingAllocationContractGroupHandler_RevisedNewOldVersionPutInCrmIssue()
        {
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var context = new FundingAllocationContext(options);
            ContractDeliverableEnricher enricher = new ContractDeliverableEnricher(Mock.Of<IConfigurationRoot>());
            CreateContractForFundingAllocationContractGroupHandler handler =
                new CreateContractForFundingAllocationContractGroupHandler(
                    Mock.Of<ILogger>(),
                    Mock.Of<IContractStorage>(),
                    new FundingAllocationsToContractTransformer(new CfsToFcsCodeMappingService(new ContractTypeRepository(context),
                        new ProviderCategoryRepository(context), new AllocationFundingStreamConfigRepository(context), new AllocationLineConfigRepository(context)), new FundingStreamPeriodRepository(context)),
                    new ReleaseGroupFundingAllocationRepository(context),
                    new ExtendedContractTypeTransformer(),
                    new ContractNumberQueryRepository(context),
                    new ContractCommandRepository(context),
                    new ContractNumbersAndVersionIntentService(new ContractNumberQueryRepository(context), new FundingTypeRepository(context)),
                    new ContractValueAggregator(), enricher, Mock.Of<IConfigurationRoot>());

            Option<CrmContractInfo> contractInfoOption = new CrmContractInfo(
                "EDSK-3986", 1, 0, 10026431, "4c0e0960-7a13-46fd-8f5d-cf4e4b31e420", "ESFA-22314", "Variation",
                new List<CrmAllocationInfo>
                {
                    new CrmAllocationInfo("1619ED", null, "16ED-3591")
                }, 1);

            // act
            handler.Handle(new CreateContractForFundingAllocationContractGroupCommand
            {
                FundingAllocationIds = new List<string>
                    {
                        "NFF-AS-2021-Contract-LocalAuthority-10026431-2_1"
                    },
                ContractItemsMappings = new ContractItemsMappingResult("EDSK", "AY2021", "16-19ED2021", "Conditions of Funding (Grant) (LA)"),
                ContractIntent = ContractIntent.RevisedNew,
                ContractInfoOption = contractInfoOption
            },
                new TestableMessageHandlerContext()).Wait();
        }
    }
}
