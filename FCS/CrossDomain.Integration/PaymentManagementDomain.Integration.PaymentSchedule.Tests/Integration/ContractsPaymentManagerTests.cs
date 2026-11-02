namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.PaymentSchedule;
    using CrossDomain.Integration.Entities.Xrm;
    using Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Moq;
    using MoreLinq;
    using PaymentManagementDomain.PaymentSchedule.Xrm.Integration;
    using PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories;
    using CrmConnectionFactory = FCS.Worker.Common.Crm.CrmConnectionFactory;

    [TestClass]
    public class ContractsPaymentManagerTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractsPaymentManager_CreatePaymentScheduleAllocation_ShouldStorePaymentValuesInCrm()
        {
            const string contractNumber = "MAIN-1234";
            const int contractVersion = 1;
            const int subVersion = 0;
            const string allocationNumber = "MAIN-1234-ALLOC-1234";
            const string deliverableCode = "1";
            const decimal cappedPaymentAmount = 100m;
            const decimal actualValue = 11m;
            const int actualVolume = 101;

            // arrange
            DeleteContract(contractNumber);
            CreateContract(contractNumber, contractVersion, subVersion, allocationNumber, deliverableCode);

            Allocation paymentSchedule = new Allocation
            {
                AllocationNumber = allocationNumber,
                AllocationDeliverables = new List<AllocationDeliverable>
                {
                    new AllocationDeliverable
                    {
                        DeliverableCode = int.Parse(deliverableCode),
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment
                            {
                                Period = "201712",
                                CappedPaymentAmount = cappedPaymentAmount,
                                ActualValue = actualValue,
                                ActualVolume = actualVolume
                            }
                        }
                    }
                }
            };

            ContractsPaymentManager contractsPaymentManager = new ContractsPaymentManager(Mock.Of<ILogger>(), GetOrganizationService());
            contractsPaymentManager.ContractNumber = contractNumber;
            contractsPaymentManager.ContractVersionNumber = contractVersion;
            contractsPaymentManager.AllocationNumber = allocationNumber;
            CrmAllocationRepository repository = new CrmAllocationRepository(GetOrganizationService());
            var allocationInfo = repository.GetAllocationInfoFromCrm(allocationNumber, contractVersion);
            IReadOnlyCollection<DeliverableInfo> deliverableInfos = repository.GetContractDeliverablesForAllocation(allocationInfo.AllocationId);
            CrmDeliverablePeriodRepository deliverablePeriodRepository = new CrmDeliverablePeriodRepository(GetOrganizationService());
            IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYears = deliverablePeriodRepository.GetDeliverablePeriodYears(allocationInfo.AllocationId);

            // act
            contractsPaymentManager.UpdateAllocationSchedulesInCrm(paymentSchedule, allocationInfo, deliverableInfos, deliverablePeriodYears);

            // assert
            using (var context = new XrmServiceContext(GetOrganizationService()))
            {
                var sfaContractdeliverableperiod =
                    (from cdp in context.sfa_contractdeliverableperiodSet
                     join d in context.sfa_contractdeliverableSet on cdp.sfa_ContractDeliverableId.Id equals d.sfa_contractdeliverableId.Value
                     join ca in context.sfa_contractallocationSet on d.sfa_ContractAllocationId.Id equals ca.sfa_contractallocationId.Value
                     where ca.sfa_contractallocationnumber == allocationNumber && d.sfa_DeliverableCode == deliverableCode
                     select cdp).FirstOrDefault();

                Assert.IsNotNull(sfaContractdeliverableperiod, "Could not find a record in CRM");
                Assert.AreEqual(cappedPaymentAmount, sfaContractdeliverableperiod.sfa_CappedPaymentAmount, "The capped payment amount has not been set correctly");
                Assert.AreEqual(actualValue, sfaContractdeliverableperiod.sfa_ActualValue, "The actual value has not been set correctly");
                Assert.AreEqual(actualVolume, sfaContractdeliverableperiod.sfa_ActualVolume, "The actual volume has not been set correctly");
            }
        }

        private static void CreateContract(string contractNumber, int contractVersion, int subVersion, string allocationNumber, string deliverableCode)
        {
            sfa_contract contract = new sfa_contract
            {
                sfa_number = contractNumber,
                sfa_Version = contractVersion,
                sfa_SubVersion = subVersion,
                sfa_LastApprovedVersion = true,
                sfa_ProviderName = GetFirstOrganisationInCrmEntityReference()
            };

            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_contractallocationnumber = allocationNumber,
                sfa_startdate = new DateTime(2017, 01, 01),
                sfa_enddate = new DateTime(2017, 12, 01)
            };

            sfa_contractdeliverable deliverable = new sfa_contractdeliverable
            {
                sfa_DeliverableCode = deliverableCode,
                sfa_DeliverableDescription = "1"
            };

            sfa_contractdeliverableperiod deliverablePeriod = new sfa_contractdeliverableperiod
            {
                sfa_PeriodName = "Dec-17",
                sfa_Period = 12,
                sfa_Year = 2017,
                sfa_CappedPaymentAmount = -100m
            };

            contract.RelatedEntities.Add(new Relationship("sfa_sfa_contract_sfa_contractallocation"), new EntityCollection(new Entity[] { allocation }));
            allocation.RelatedEntities.Add(new Relationship("sfa_sfa_contractallocation_sfa_contractdelive"), new EntityCollection(new Entity[] { deliverable }));
            deliverable.RelatedEntities.Add(new Relationship("sfa_contractdeliverable_deliverableperiod"), new EntityCollection(new Entity[] { deliverablePeriod }));

            GetOrganizationService().Create(contract);
        }

        private static void DeleteContract(string allocationNumber)
        {
            using (XrmServiceContext context = new XrmServiceContext(GetOrganizationService()))
            {
                context.sfa_contractSet
                    .Where(c => c.sfa_number == allocationNumber)
                    .AsEnumerable()
                    .ForEach(c => GetOrganizationService()
                    .Delete("sfa_contract", c.Id));
            }
        }

        private static IOrganizationService GetOrganizationService()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }

        private static EntityReference GetFirstOrganisationInCrmEntityReference()
        {
            using (var xrmContext = new XrmServiceContext(GetOrganizationService()))
            {
                var org = xrmContext.AccountSet.Where(a => a.sfa_UKPRN != null && a.sfa_UKPRN != string.Empty)
                    .Select(a => new {a.sfa_UKPRN, a.AccountId})
                    .First();

                return xrmContext.AccountSet.Single(a => a.Id == org.AccountId).ToEntityReference();
            }
        }
    }
}
