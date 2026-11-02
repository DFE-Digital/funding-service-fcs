namespace FundingAllocation.Tests.Endpoints.ReleaseGroup
{
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using FundingAllocation.Endpoints.ReleaseGroup;
    using FundingAllocation.Endpoints.ReleaseGroup.Handlers;
    using FundingAllocation.Endpoints.ReleaseGroup.Repositories;
    using FundingAllocation.Repositories;
    using FundingAllocation.Services;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using FundingAllocation.Endpoints.ReleaseGroup.Services;
    using Newtonsoft.Json;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;
    using SFA.FCT.CrossDomain.Integration.Common;
    using System;

    [TestClass]
    public class UpdateContractWithFundingAllocationsHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void UpdateContractWithFundingAllocationsHandler_ShouldResolve()
        {
            // arrange
            var container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<UpdateContractWithFundingAllocationsHandler>());

            container.BeginScope();

            // act
            container.Resolve<UpdateContractWithFundingAllocationsHandler>();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void UpdateContractWithFundingAllocationsHandler_Technical()
        {
            var contextOptions = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"]))
                .Options;
            var dateMock = new Mock<IOverrideDateRepository>();
            dateMock.Setup(m => m.GetDate()).ReturnsAsync(DateTime.Now);

            var context = new FundingAllocationContext(contextOptions);
            var cfsToFcsCodeMappingService = new CfsToFcsCodeMappingService(
                new ContractTypeRepository(context),
                new ProviderCategoryRepository(context),
                new AllocationFundingStreamConfigRepository(context), new AllocationLineConfigRepository(context));

            var handler = new UpdateContractWithFundingAllocationsHandler(Mock.Of<ILogger>(),
                new ReleaseGroupFundingAllocationRepository(context),
                new ContractNumberQueryRepository(context),
                new FundingAllocationsToContractTransformer(
                    cfsToFcsCodeMappingService,
                    new FundingStreamPeriodRepository(context)), new ContractCommandRepository(context),
                new AmendmentTypeService(new AmendmentTypeServiceChecks(
                    new FundingTypeFundingPeriodRepository(context, dateMock.Object),
                    cfsToFcsCodeMappingService), Mock.Of<ILogger>()));
            string messageJson =
                @"{""CrmContractInfo"":{""Number"":""EDSK-21828"",""Version"":3,""SubVersion"":0,""CrmEntityId"":""d5637f21-a9a4-4996-be3b-72572865499b"",""ContractingUkprn"":10017165,""MasterContractNumber"":""ESFA-100469"",""LatestOverallVersionNumber"":3,""AmendmentType"":""Variation"",""CrmAllocationInfos"":{""$type"":""System.Collections.Generic.List`1[[FundingAllocation.Dto.CrmAllocationInfo, FundingAllocation]], System.Private.CoreLib"",""$values"":[{""FundingStreamCode"":""1619ED"",""DeliveryOrgUkprn"":""10027333"",""AllocationNumber"":""16ED-13802""},{""FundingStreamCode"":""1619ED"",""DeliveryOrgUkprn"":""10017165"",""AllocationNumber"":""16ED-13800""}]}},""ContractingUkprn"":10017165,""ContractIntent"":6,""ContractItemsMappings"":{""FundingTypeCode"":""EDSK"",""FundingPeriodCode"":""AY2122"",""FSPGroupCode"":""16-19ED2122"",""ContractType"":""Conditions of Funding (Grant) (LA)""},""FundingIds"":[""1619-AS-2122-Contract-LocalAuthority-10017165-3_2""]}";
            UpdateContractWithFundingAllocationsCommand command =
                JsonConvert.DeserializeObject<UpdateContractWithFundingAllocationsCommand>(messageJson);

            // act
            handler.Handle(command, new TestableMessageHandlerContext())
                .Wait();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void UpdateContractWithFundingAllocationsHandler_Technical_1c()
        {
            var contextOptions = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"]))
                .Options;

            var context = new FundingAllocationContext(contextOptions);
            var cfsToFcsCodeMappingService = new CfsToFcsCodeMappingService(
                new ContractTypeRepository(context),
                new ProviderCategoryRepository(context),
                new AllocationFundingStreamConfigRepository(context), new AllocationLineConfigRepository(context));
            var dateMock = new Mock<IOverrideDateRepository>();
            dateMock.Setup(m => m.GetDate()).ReturnsAsync(DateTime.Now);

            var handler = new UpdateContractWithFundingAllocationsHandler(Mock.Of<ILogger>(),
                new ReleaseGroupFundingAllocationRepository(context),
                new ContractNumberQueryRepository(context),
                new FundingAllocationsToContractTransformer(
                    cfsToFcsCodeMappingService,
                    new FundingStreamPeriodRepository(context)), new ContractCommandRepository(context),
                new AmendmentTypeService(new AmendmentTypeServiceChecks(
                    new FundingTypeFundingPeriodRepository(context, dateMock.Object), cfsToFcsCodeMappingService), Mock.Of<ILogger>()));

            // act
            handler.Handle(new UpdateContractWithFundingAllocationsCommand(new CrmContractInfo(
                            "EDSK-21110", 1, 0, 12345678, "253384ca-f736-48aa-9408-9a71b0bab404", "ESFA-98730", "Variation",
                            new List<CrmAllocationInfo>
                            {
                                new CrmAllocationInfo("1619ED", null, "16ED-12924")
                            }, 1), 10017780,
                        ContractIntent.Amendment,
                        new ContractItemsMappingResult("EDSK", "AY2122", "16-19ED2122",
                            "Contract for Services (ITP)"),
                        new List<string> { "1619-AS-2122-Contract-Provider-10017780-2_2" }),
                    new TestableMessageHandlerContext())
                .Wait();
        }
    }
}
