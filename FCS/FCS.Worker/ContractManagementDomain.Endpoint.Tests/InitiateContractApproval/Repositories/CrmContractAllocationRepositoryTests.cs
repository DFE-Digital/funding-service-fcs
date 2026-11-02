namespace ContractManagementDomain.Endpoint.Tests.InitiateContractApproval.Repositories
{
    using System;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using Endpoint.InitiateContractApproval;
    using Endpoint.InitiateContractApproval.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class CrmContractAllocationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractAllocationRepository_UpdateStartDate_ShouldUpdateStartDate()
        {
            // arrange 
            const string contractNumberToTest = "CN - Test";
            const int versionToTest = 1;
            DateTime updateStartDate = new DateTime(2018, 1, 1);

            RemoveContract(contractNumberToTest, versionToTest);
            Provider provider = GetProvider();
            FundingType fundingType = GetFundingType();
            Period period = GetPeriod();

            Guid contractId = CreateContract(contractNumberToTest, versionToTest, provider, fundingType, period);
            Guid allocationId = CreateContractAllocation(contractId);
            Guid deliverableId = CreateDeliverable(allocationId);
            CreateDeliverablePeriod(deliverableId);

            ICrmContractAllocationRepository crmContractAllocationRepository = GetContainer().Resolve<ICrmContractAllocationRepository>();

            // act
            crmContractAllocationRepository.UpdateStartDate(allocationId, updateStartDate);

            // assert
            sfa_contractallocation sfaContractallocation = GetContractAllocation(allocationId);

            Assert.AreEqual(updateStartDate, sfaContractallocation.sfa_startdate, "Incorrect Contract Allocation Start Date");
        }

        private sfa_contractallocation GetContractAllocation(Guid allocationId)
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                return crmContext.sfa_contractallocationSet.SingleOrDefault(x => x.sfa_contractallocationId.Value == allocationId);
            }
        }

        private FundingType GetFundingType()
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                var fundingType = crmContext.sfa_fundingtypeSet.First();

                return new FundingType(fundingType.sfa_fundingtypecode, fundingType.ToEntityReference());
            }
        }

        private Period GetPeriod()
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                var period = crmContext.sfa_periodSet.First();

                return new Period(period.sfa_Period, period.ToEntityReference());
            }
        }

        private Guid CreateContract(string contractNumberToTest, int version, Provider provider, FundingType fundingType, Period period)
        {
            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = provider.Ukprn,
                sfa_number = contractNumberToTest,
                sfa_Version = version,
                sfa_LastApprovedVersion = false,
                sfa_ProviderName = provider.EntityReference,
                sfa_FundingType = fundingType.EntityReference,
                sfa_PeriodId = period.EntityReference,
            };

            return GetConnection().Create(contract);
        }

        private Guid CreateContractAllocation(Guid contractId)
        {
            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_startdate = new DateTime(year: 2017, month: 5, day: 1, hour: 0, minute: 0, second: 0)
            };

            return GetConnection().Create(allocation);
        }

        private Guid CreateDeliverable(Guid allocationId)
        {
            sfa_contractdeliverable deliverable = new sfa_contractdeliverable
            {
                sfa_ContractAllocationId = new EntityReference(sfa_contract.EntityLogicalName, allocationId),
            };

            return GetConnection().Create(deliverable);
        }

        private void CreateDeliverablePeriod(Guid contractDeliverableId)
        {
            sfa_contractdeliverableperiod deliverableperiod = new sfa_contractdeliverableperiod
            {
                sfa_ContractDeliverableId = new EntityReference(sfa_contract.EntityLogicalName, contractDeliverableId),
                sfa_Period = 5,
                sfa_PeriodName = "May-2017"
            };

            GetConnection().Create(deliverableperiod);
        }

        private Provider GetProvider()
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                var org = crmContext.AccountSet.First(a => a.sfa_UKPRN != null);

                return new Provider(org.sfa_UKPRN, org.ToEntityReference());
            }
        }

        private void RemoveContract(string contractNumber, int verion)
        {
            using (var context = new XrmServiceContext(GetConnection()))
            {
                context.sfa_contractSet.Where(c => c.sfa_number == contractNumber && c.sfa_Version == verion)
                    .ForEach(c => GetConnection().Delete(sfa_contract.EntityLogicalName, c.Id));
            }
        }

        private static IWindsorContainer GetContainer()
        {
            ILoggerFactory loggerFactory = new LoggerFactory();
            var container = new WindsorContainer().Install(new WindsorInstaller(loggerFactory));
            container.BeginScope();

            return container;
        }

        public IOrganizationService GetConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }

        private class Provider
        {
            public Provider(string ukprn, EntityReference entityReference)
            {
                Ukprn = ukprn;
                EntityReference = entityReference;
            }

            public string Ukprn { get; }
            public EntityReference EntityReference { get; }
        }

        private class FundingType
        {
            public FundingType(string code, EntityReference entityReference)
            {
                Code = code;
                EntityReference = entityReference;
            }

            public string Code { get; }

            public EntityReference EntityReference { get; }
        }

        private class Period
        {
            public Period(string code, EntityReference entityReference)
            {
                Code = code;
                EntityReference = entityReference;
            }

            private string Code { get; }

            public EntityReference EntityReference { get; }
        }
    }
}
