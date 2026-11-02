namespace ContractManagementDomain.Endpoint.Tests.InitiateContractApproval.Repositories
{
    using System;
    using System.Linq;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using Castle.MicroKernel.Lifestyle;
    using Endpoint.InitiateContractApproval;
    using Endpoint.InitiateContractApproval.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;

    [TestClass]
    public class CrmContractDeliverablePeriodRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractDeliverablePeriodRepository_GetContractDeliverablePeriods_ShouldReturnACollectionOfCdps()
        {
            const string contractNumberToTest = "CN - Test";
            const int versionToTest = 1;

            // arrange
            RemoveContract(contractNumberToTest, versionToTest);
            Provider provider = GetProvider();
            FundingType fundingType = GetFundingType();
            Period period = GetPeriod();

            Guid contractId = CreateContract(contractNumberToTest, versionToTest, provider, fundingType, period);
            Guid allocationId = CreateContractAllocation(contractId);
            Guid deliverableId = CreateDeliverable(allocationId);
            Guid deliverablePeriodId = CreateDeliverablePeriod(deliverableId);

            ICrmContractDeliverablePeriodRepository crmContractDeliverablePeriodRepository = GetContainer().Resolve<ICrmContractDeliverablePeriodRepository>();

            // act
            var contractDeliverablePeriods = crmContractDeliverablePeriodRepository.GetContractDeliverablePeriods(contractNumber: contractNumberToTest, versionNumber: versionToTest);

            // assert
            Assert.AreEqual(1, contractDeliverablePeriods.Count, "Incorrect Number of Contract Deliverable Periods returned");

            var crmContractDeliverablePeriod = contractDeliverablePeriods.First();
            Assert.AreEqual(contractId, crmContractDeliverablePeriod.ContractId, "Incorrect Contract Id");
            Assert.AreEqual(allocationId, crmContractDeliverablePeriod.ContractAllocationId, "Incorrect Contract Allocation Id");
            Assert.AreEqual(deliverablePeriodId, crmContractDeliverablePeriod.Id, "Incorrect Contract Deliverable Period Id");

        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractDeliverablePeriodRepository_GetContractDeliverablePeriodsForAllocation_ShouldUpdatePeriodNameAndPeriodNumber()
        {
            const string contractNumberToTest = "CN - Test";
            const int versionToTest = 1;
            const string nonLevyFsp = "NONLEVY2019";

            // arrange
            RemoveContract(contractNumberToTest, versionToTest);
            var provider = GetProvider();
            var fundingType = GetFundingType();
            var period = GetPeriod();

            var contractId = CreateContract(contractNumberToTest, versionToTest, provider, fundingType, period);
            var allocationId = CreateContractAllocation(contractId);
            var deliverableId = CreateDeliverable(allocationId);
            var deliverablePeriodId = CreateDeliverablePeriod(deliverableId);

            var nonLevyFspAllocationId = CreateContractAllocationForFsp(contractId, nonLevyFsp);
            var nonLevyFspdeliverableId = CreateDeliverable(nonLevyFspAllocationId);
            var nonLevyFspdeliverablePeriodId = CreateDeliverablePeriod(nonLevyFspdeliverableId);

            var crmContractDeliverablePeriodRepository = GetContainer().Resolve<ICrmContractDeliverablePeriodRepository>();

            // act
            var contractDeliverablePeriods = crmContractDeliverablePeriodRepository.GetContractDeliverablePeriodsForAllocation(contractNumberToTest, versionToTest, nonLevyFsp);

            // assert
            Assert.AreEqual(1, contractDeliverablePeriods.Count, "Incorrect Number of Contract Deliverable Periods returned");

            var crmContractDeliverablePeriod = contractDeliverablePeriods.First();
            Assert.AreEqual(contractId, crmContractDeliverablePeriod.ContractId, "Incorrect Contract Id");
            Assert.AreEqual(nonLevyFspAllocationId, crmContractDeliverablePeriod.ContractAllocationId, "Incorrect Contract Allocation Id");
            Assert.AreEqual(nonLevyFspdeliverablePeriodId, crmContractDeliverablePeriod.Id, "Incorrect Contract Deliverable Period Id");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractDeliverablePeriodRepository_UpdatePeriod_ShouldUpdatePeriodNameAndPeriodNumber()
        {
            // arrange 
            const string contractNumberToTest = "CN - Test";
            const int versionToTest = 1;
            const int expectedYear = 2018;
            const int expectedMonthNumber = 1;
            const string expectedPeriodName = "Jan-18";

            RemoveContract(contractNumberToTest, versionToTest);
            Provider provider = GetProvider();
            FundingType fundingType = GetFundingType();
            Period period = GetPeriod();

            Guid contractId = CreateContract(contractNumberToTest, versionToTest, provider, fundingType, period);
            Guid allocationId = CreateContractAllocation(contractId);
            Guid deliverableId = CreateDeliverable(allocationId);
            Guid deliverablePeriodId = CreateDeliverablePeriod(deliverableId);

            ICrmContractDeliverablePeriodRepository crmContractDeliverablePeriodRepository = GetContainer().Resolve<ICrmContractDeliverablePeriodRepository>();

            // act
            crmContractDeliverablePeriodRepository.UpdatePeriod(cpdId: deliverablePeriodId, year: expectedYear, month: expectedMonthNumber);

            // assert
            sfa_contractdeliverableperiod sfaContractdeliverableperiod = GetContractDeliverablePeriod(deliverablePeriodId);

            Assert.AreEqual(expectedMonthNumber, sfaContractdeliverableperiod.sfa_Period, "Incorrect Period Number");
            Assert.AreEqual(expectedPeriodName, sfaContractdeliverableperiod.sfa_PeriodName, "Incorrect Period Name");
            Assert.AreEqual(expectedYear, sfaContractdeliverableperiod.sfa_Year, "Incorrect Year");
            Assert.AreEqual(expectedPeriodName, sfaContractdeliverableperiod.sfa_PeriodName, "Incorrect Name");
        }

        private sfa_contractdeliverableperiod GetContractDeliverablePeriod(Guid deliverablePeriodId)
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                return crmContext.sfa_contractdeliverableperiodSet.SingleOrDefault(x => x.sfa_contractdeliverableperiodId.Value == deliverablePeriodId);
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

        private Guid CreateContractAllocationForFsp(Guid contractId, string fundingstreamperiod)
        {
            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_startdate = new DateTime(year: 2017, month: 5, day: 1, hour: 0, minute: 0, second: 0),
                sfa_FundingStreamPeriodId = GetFundingStreamPeriodEntityRef(fundingstreamperiod)
            };

            return GetConnection().Create(allocation);
        }

        private EntityReference GetFundingStreamPeriodEntityRef(string fspCode)
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                return crmContext.sfa_fundingstreamperiodSet.First(fsp => fsp.sfa_fundingstreamperiodcode == fspCode).ToEntityReference();
            }
        }

        private Guid CreateDeliverable(Guid allocationId)
        {
            sfa_contractdeliverable deliverable = new sfa_contractdeliverable
            {
                sfa_ContractAllocationId = new EntityReference(sfa_contract.EntityLogicalName, allocationId),
            };

            return GetConnection().Create(deliverable);
        }

        private Guid CreateDeliverablePeriod(Guid contractDeliverableId)
        {
            sfa_contractdeliverableperiod deliverableperiod = new sfa_contractdeliverableperiod
            {
                sfa_ContractDeliverableId = new EntityReference(sfa_contract.EntityLogicalName, contractDeliverableId),
                sfa_Period = 5,
                sfa_PeriodName = "May-2017"
            };

            return GetConnection().Create(deliverableperiod);
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
                var matchingContracts = context.sfa_contractSet.Where(c => c.sfa_number == contractNumber && c.sfa_Version == verion);
                matchingContracts.ForEach(c =>
                    ActionRetrier.RetryWhenExceptionThrown<System.ServiceModel.FaultException>(() => GetConnection().Delete(sfa_contract.EntityLogicalName, c.Id)));
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
            return SFA.FCS.Worker.Common.Crm.CrmConnectionFactory.GetRetryOnErrorOrganizationService();
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

            public string Code { get; }
            public EntityReference EntityReference { get; }
        }
    }
}
