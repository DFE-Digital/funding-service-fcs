namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Framework.Logging;
    using Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories;
    using PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Services;
    using UnitTests.Common;
    using CrmConnectionFactory = FCS.Worker.Common.Crm.CrmConnectionFactory;

    [TestClass]
    public class LevyMissingDeliverablePeriodCreatorTests
    {
        private EntityReference _fundingTypeEntityReference;
        private EntityReference _providerEntityReference;

        [TestMethod, TestCategory("IntegrationTest")]
        public void LevyMissingDeliverablePeriodCreator_ShouldCreateMissingPeriodsWhenReplacedContractContainsMorePeriods()
        {
            // arrange
            const string contractNumber = "Test - CN";
            const string allocationNumber = "Test - ALLOC";
            LevyMissingDeliverablePeriodCreator levyMissingDeliverablePeriodCreator =
                new LevyMissingDeliverablePeriodCreator(new CrmAllocationRepository(GetCrmConnection()),
                    new CrmDeliverablePeriodRepository(GetCrmConnection()));

            DeleteContracts(contractNumber);
            Guid contractId = CreateContract(contractNumber, 1, sfa_contractstatus.Replaced);
            Guid allocationId = CreateAllocation(allocationNumber, contractId);
            Guid deliverableId = CreateDeliverable("1", allocationId);
            CreateContractDeliverablePeriod(2017, 1, deliverableId);
            CreateContractDeliverablePeriod(2017, 2, deliverableId);
            deliverableId = CreateDeliverable("2", allocationId);
            CreateContractDeliverablePeriod(2017, 1, deliverableId);
            CreateContractDeliverablePeriod(2017, 2, deliverableId);

            contractId = CreateContract(contractNumber, 1, sfa_contractstatus.Approved);
            allocationId = CreateAllocation(allocationNumber, contractId);
            deliverableId = CreateDeliverable("1", allocationId);
            CreateContractDeliverablePeriod(2017, 1, deliverableId);
            deliverableId = CreateDeliverable("2", allocationId);
            CreateContractDeliverablePeriod(2017, 1, deliverableId);

            // act
            levyMissingDeliverablePeriodCreator.CreateMissingDeliverablePeriodsWhenNecessary(allocationNumber);

            // assert
            IReadOnlyCollection<sfa_contractdeliverableperiod> approvedCDPs =
                GetContractDeliverablePeriodsForAllocation(allocationId);

            Assert.AreEqual(4, approvedCDPs.Count, "The number of returned CDPs is not correct");
            Assert.AreEqual(2, approvedCDPs.Count(cdp => cdp.sfa_PeriodName == "Feb-17"), "The number of returned CDPs for Feb-17 is not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void LevyMissingDeliverablePeriodCreator_ShouldCreateMissingPeriodsWhenReplacedContractContainsMorePeriodsWhenUnderTermination()
        {
            // arrange
            const string contractNumber = "Test - CN";
            const string allocationNumber = "Test - ALLOC";
            LevyMissingDeliverablePeriodCreator levyMissingDeliverablePeriodCreator =
                new LevyMissingDeliverablePeriodCreator(new CrmAllocationRepository(GetCrmConnection()),
                    new CrmDeliverablePeriodRepository(GetCrmConnection()));

            DeleteContracts(contractNumber);
            Guid contractId = CreateContract(contractNumber, 1, sfa_contractstatus.Replaced, "Under Termination");
            Guid allocationId = CreateAllocation(allocationNumber, contractId);
            Guid deliverableId = CreateDeliverable("1", allocationId);
            CreateContractDeliverablePeriod(2017, 1, deliverableId);
            CreateContractDeliverablePeriod(2017, 2, deliverableId);
            deliverableId = CreateDeliverable("2", allocationId);
            CreateContractDeliverablePeriod(2017, 1, deliverableId);
            CreateContractDeliverablePeriod(2017, 2, deliverableId);

            contractId = CreateContract(contractNumber, 1, sfa_contractstatus.Approved, "Under Termination");
            allocationId = CreateAllocation(allocationNumber, contractId);
            deliverableId = CreateDeliverable("1", allocationId);
            CreateContractDeliverablePeriod(2017, 1, deliverableId);
            deliverableId = CreateDeliverable("2", allocationId);
            CreateContractDeliverablePeriod(2017, 1, deliverableId);

            // act
            levyMissingDeliverablePeriodCreator.CreateMissingDeliverablePeriodsWhenNecessary(allocationNumber);

            // assert
            IReadOnlyCollection<sfa_contractdeliverableperiod> approvedCDPs =
                GetContractDeliverablePeriodsForAllocation(allocationId);

            Assert.AreEqual(4, approvedCDPs.Count, "The number of returned CDPs is not correct");
            Assert.AreEqual(2, approvedCDPs.Count(cdp => cdp.sfa_PeriodName == "Feb-17"), "The number of returned CDPs for Feb-17 is not correct");
        }

        private void DeleteContracts(string contractNumber)
        {
            using (var crmContext = new XrmServiceContext(GetCrmConnection()))
            {
                var matchingContracts =
                    crmContext.sfa_contractSet.Where(
                        c => c.sfa_number == contractNumber)
                        .Select(c => c.Id);

                matchingContracts.ForEach(c =>
                    ActionRetrier.RetryWhenExceptionThrown<System.ServiceModel.FaultException>(() => GetCrmConnection().Delete(sfa_contract.EntityLogicalName, c)));
            }
        }

        private IReadOnlyCollection<sfa_contractdeliverableperiod> GetContractDeliverablePeriodsForAllocation(Guid allocationId)
        {
            using (var crmContext = new XrmServiceContext(GetCrmConnection()))
            {
                return (from d in crmContext.sfa_contractdeliverableSet
                    join dp in crmContext.sfa_contractdeliverableperiodSet on d.sfa_contractdeliverableId equals
                        dp.sfa_ContractDeliverableId.Id
                        where d.sfa_ContractAllocationId.Id == allocationId
                    select dp).ToList();
            }
        }

        private static IOrganizationService GetCrmConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }

        private static Guid CreateDeliverable(string deliverableCode, Guid allocationId)
        {
            var deliverable = new sfa_contractdeliverable
            {
                sfa_DeliverableCode = deliverableCode,
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId)
            };

            return GetCrmConnection().Create(deliverable);
        }

        private static Guid CreateContractDeliverablePeriod(int year, int month, Guid deliverableId)
        {
            string lastTwoDigitsOfYear = year.ToString().Substring(2, 2);
            string periodName = $"{DateTimeFormatInfo.InvariantInfo.GetAbbreviatedMonthName(month)}-{lastTwoDigitsOfYear}";
            var deliverable = new sfa_contractdeliverableperiod
            {
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId),
                sfa_PeriodName = periodName,
                sfa_Period = month,
                sfa_Year = year,
                sfa_DisplayOrder = month,
                sfa_name = periodName
            };

            return GetCrmConnection().Create(deliverable);
        }

        private static Guid CreateAllocation(string number, Guid contractId)
        {
            var allocation = new sfa_contractallocation
            {
                sfa_contractallocationnumber = number,
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId)
            };

            return GetCrmConnection().Create(allocation);
        }

        private Guid CreateContract(string contractNumber, int version, sfa_contractstatus contractStatus, string subStatus = "Approved")
        {
            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_LastApprovedVersion = false,
                sfa_FundingType = GetFundingType(),
                sfa_ProviderName = GetOrgEntityReference()
            };

            Guid guid = GetCrmConnection().Create(contract);

            contract = new sfa_contract
            {
                Id = guid,
                sfa_ContractStatus = new OptionSetValue((int)contractStatus),
                sfa_SubStatus = new EntityReference("sfa_status", GetSubStatusEntityId(subStatus))
            };

            contract.EntityState = EntityState.Changed;
            GetCrmConnection().Update(contract);

            return guid;
        }

        private Guid GetSubStatusEntityId(string name)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(GetCrmConnection()))
            {
                return xrmContext.sfa_statusSet.Single(s => s.sfa_name == name).Id;
            }
        }

        private EntityReference GetFundingType()
        {
            if (_fundingTypeEntityReference == null)
            {
                using (var crmContext = new XrmServiceContext(GetCrmConnection()))
                {
                    _fundingTypeEntityReference = crmContext.sfa_fundingtypeSet.First().ToEntityReference();
                }
            }

            return _fundingTypeEntityReference;
        }

        private EntityReference GetOrgEntityReference()
        {
            if (_providerEntityReference == null)
            {
                using (var crmContext = new XrmServiceContext(GetCrmConnection()))
                {
                    _providerEntityReference = crmContext.AccountSet.First().ToEntityReference();
                }
            }

            return _providerEntityReference;
        }

        private IWindsorContainer GetContainer()
        {
            ILoggerFactory factory = new LoggerFactory();

            IWindsorContainer container =
                new WindsorContainer().Install(
                    new SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.IoC.WindsorInstaller(factory));
            container.BeginScope();

            return container;
        }
    }
}
