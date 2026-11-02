namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Events;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories;
    using PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Services;
    using UnitTests.Common;
    using CrmConnectionFactory = FCS.Worker.Common.Crm.CrmConnectionFactory;

    [TestClass]
    public class ContractDeliverablePeriodPresenceCheckerTests
    {
        private static EntityReference _providerEntityReference;
        private ContractDeliverablePeriodPresenceChecker _contractDeliverablePeriodPresenceChecker;
        private CrmDeliverablePeriodRepository _deliverablePeriodRepository;

        [TestInitialize]
        public void TestInitialize()
        {
            _contractDeliverablePeriodPresenceChecker = new ContractDeliverablePeriodPresenceChecker();

            _deliverablePeriodRepository = new CrmDeliverablePeriodRepository(GetOrgService());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractDeliverablePeriodPresenceChecker_AreAllDeliverablePeriodsWithinBoundsOfAllocationPresent_WhenAllCdpsWithinTheBoundsofAllocationArePresent_ShouldReturnTrue()
        {
            // arrange
            const string testContractNumber = "Test-ContractACEW";
            DeleteContracts(testContractNumber);
            string[] periodsForDeliverables = GetPeriodsFromAndToForGivenYear(0, 4, "18");
            DateTime startDateAllocation = new DateTime(2018, 1, 1);
            DateTime endDateAllocation = new DateTime(2018, 4, 1);
            PaymentScheduleEvent paymentScheduleEvent = GetPaymentScheduleFromFile();

            Guid contractGuid = CreateTestContract(testContractNumber);
            Guid contractAllocationGuid = CreateContractAllocation(contractGuid, startDateAllocation, endDateAllocation);
            Guid deliverable1 = CreateDeliverable(contractAllocationGuid, "1");
            Guid deliverable2 = CreateDeliverable(contractAllocationGuid, "2");
            Guid deliverable3 = CreateDeliverable(contractAllocationGuid, "3");
            Guid deliverable4 = CreateDeliverable(contractAllocationGuid, "4");

            CreateDeliverablePeriods(deliverable1, periodsForDeliverables);
            CreateDeliverablePeriods(deliverable2, periodsForDeliverables);
            CreateDeliverablePeriods(deliverable3, periodsForDeliverables);
            CreateDeliverablePeriods(deliverable4, periodsForDeliverables);

            IReadOnlyCollection<DeliverablePeriodYear> existingContractDeliverablePeriods = _deliverablePeriodRepository.GetDeliverablePeriodYears(contractAllocationGuid);

            // act
            bool areAllDeliverablePeriodsWithinBoundsOfAllocationPresent =
                _contractDeliverablePeriodPresenceChecker.AreAllDeliverablePeriodsWithinBoundsOfAllocationPresent(startDateAllocation, endDateAllocation, existingContractDeliverablePeriods, paymentScheduleEvent.PaymentScheduleAllocation);

            // assert
            Assert.IsTrue(areAllDeliverablePeriodsWithinBoundsOfAllocationPresent);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractDeliverablePeriodPresenceChecker_AreAllDeliverablePeriodsWithinBoundsOfAllocationPresent_WhenAllCdpsWithinTheBoundsofAllocationAreNotPresent_ShouldReturnFalse()
        {
            // arrange
            const string testContractNumber = "Test-ContractACEW";
            DeleteContracts(testContractNumber);
            string[] periodsForDeliverables1 = GetPeriodsFromAndToForGivenYear(0, 4, "18");
            string[] periodsForDeliverables2 = GetPeriodsFromAndToForGivenYear(0, 3, "18");
            PaymentScheduleEvent paymentScheduleEvent = GetPaymentScheduleFromFile();

            DateTime startDateAllocation = new DateTime(2018, 1, 1);
            DateTime endDateAllocation = new DateTime(2018, 4, 1);

            Guid contractGuid = CreateTestContract(testContractNumber);
            Guid contractAllocationGuid = CreateContractAllocation(contractGuid, startDateAllocation, endDateAllocation);
            Guid deliverable1 = CreateDeliverable(contractAllocationGuid, "1");
            Guid deliverable2 = CreateDeliverable(contractAllocationGuid, "2");
           
            CreateDeliverablePeriods(deliverable1, periodsForDeliverables1);
            CreateDeliverablePeriods(deliverable2, periodsForDeliverables2);

            IReadOnlyCollection<DeliverablePeriodYear> existingContractDeliverablePeriods = _deliverablePeriodRepository.GetDeliverablePeriodYears(contractAllocationGuid);

            // act
            bool areAllDeliverablePeriodsWithinBoundsOfAllocationPresent =
                _contractDeliverablePeriodPresenceChecker.AreAllDeliverablePeriodsWithinBoundsOfAllocationPresent(startDateAllocation, endDateAllocation, existingContractDeliverablePeriods, paymentScheduleEvent.PaymentScheduleAllocation);

            // assert
            Assert.IsFalse(areAllDeliverablePeriodsWithinBoundsOfAllocationPresent);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractDeliverablePeriodPresenceChecker_AreAllDeliverablePeriodsWithinBoundsOfAllocationPresent_WhenCrmDoesNotContainAFullSetOfPeriodsForEachDeliverableCodeOnThePaySchedule_ShouldReturnFalse()
        {
            // arrange
            PaymentScheduleEvent paymentScheduleEvent = GetPaymentScheduleFromFile();
            Assert.IsNotNull(paymentScheduleEvent);

            ContractDeliverablePeriodPresenceChecker checker = new ContractDeliverablePeriodPresenceChecker();

            DateTime allocationStart = new DateTime(2017, 8, 1);
            DateTime allocationEnd = new DateTime(2017, 12, 31);

            IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYearsFromCrm = new List<DeliverablePeriodYear>
            {
                new DeliverablePeriodYear(8, "Aug-17", 2017, "1", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(9, "Sep-17", 2017, "1", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(10, "Oct-17", 2017, "1", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(11, "Nov-17", 2017, "1", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(12, "Dec-17", 2017, "1", new sfa_contractdeliverableperiod())
            };

            bool areAllDeliverablesPresent = checker.AreAllDeliverablePeriodsWithinBoundsOfAllocationPresent(allocationStart, allocationEnd, deliverablePeriodYearsFromCrm,
                paymentScheduleEvent.PaymentScheduleAllocation);

            Assert.AreEqual(false, areAllDeliverablesPresent);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractDeliverablePeriodPresenceChecker_AreAllDeliverablePeriodsWithinBoundsOfAllocationPresent_WhenCrmContainsAFullSetOfPeriodsForEachDeliverableCodeOnThePaySchedule_ShouldReturnTrue()
        {
            // arrange
            PaymentScheduleEvent paymentScheduleEvent = GetPaymentScheduleFromFile();
            Assert.IsNotNull(paymentScheduleEvent);

            ContractDeliverablePeriodPresenceChecker checker = new ContractDeliverablePeriodPresenceChecker();

            DateTime allocationStart = new DateTime(2017, 8, 1);
            DateTime allocationEnd = new DateTime(2017, 12, 31);

            IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYearsCrm = new List<DeliverablePeriodYear>
            {
                new DeliverablePeriodYear(8, "Aug-17", 2017, "1", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(9, "Sep-17", 2017, "1", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(10, "Oct-17", 2017, "1", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(11, "Nov-17", 2017, "1", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(12, "Dec-17", 2017, "1", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(8, "Aug-17", 2017, "2", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(9, "Sep-17", 2017, "2", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(10, "Oct-17", 2017, "2", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(11, "Nov-17", 2017, "2", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(12, "Dec-17", 2017, "2", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(8, "Aug-17", 2017, "3", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(9, "Sep-17", 2017, "3", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(10, "Oct-17", 2017, "3", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(11, "Nov-17", 2017, "3", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(12, "Dec-17", 2017, "3", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(8, "Aug-17", 2017, "4", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(9, "Sep-17", 2017, "4", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(10, "Oct-17", 2017, "4", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(11, "Nov-17", 2017, "4", new sfa_contractdeliverableperiod()),
                new DeliverablePeriodYear(12, "Dec-17", 2017, "4", new sfa_contractdeliverableperiod()),
            };

            bool areAllDeliverablesPresent = checker.AreAllDeliverablePeriodsWithinBoundsOfAllocationPresent(allocationStart, allocationEnd, deliverablePeriodYearsCrm,
                paymentScheduleEvent.PaymentScheduleAllocation);

            Assert.AreEqual(true, areAllDeliverablesPresent);
        }

        private static string[] GetPeriodsFromAndToForGivenYear(int fromIndex, int toIndex, string year)
        {
            List<string> abbreviatedMonthNames =
                System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat.AbbreviatedMonthNames.ToList();
            return abbreviatedMonthNames.GetRange(fromIndex, toIndex - fromIndex).Select(m => $"{m}-{year}").ToArray();
        }

        private static Guid CreateTestContract(string contractNumber)
        {
            var organizationService = GetOrgService();

            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_ProviderName = GetOrgEntityReference(),
            };
            return organizationService.Create(contract);
        }

        private Guid CreateContractAllocation(Guid contractId, DateTime startDate, DateTime endDate)
        {
            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_startdate = startDate,
                sfa_enddate = endDate
            };

            return GetOrgService().Create(allocation);
        }

        private Guid CreateDeliverable(Guid allocationId, string deliverableCode)
        {
            sfa_contractdeliverable deliverable = new sfa_contractdeliverable
            {
                sfa_ContractAllocationId = new EntityReference(sfa_contract.EntityLogicalName, allocationId),
                sfa_DeliverableCode = deliverableCode.ToString()
            };

            return GetOrgService().Create(deliverable);
        }

        private void CreateDeliverablePeriods(Guid contractDeliverableId, params string[] deliverablePeriods)
        {
            deliverablePeriods.ForEach(dp =>
            {
                CreateDeliverablePeriod(contractDeliverableId, dp);
            });
        }

        private void CreateDeliverablePeriod(Guid contractDeliverableId, string periodName)
        {
            sfa_contractdeliverableperiod deliverableperiod = new sfa_contractdeliverableperiod
            {
                sfa_ContractDeliverableId = new EntityReference(sfa_contract.EntityLogicalName, contractDeliverableId),
                sfa_PeriodName = periodName
            };

            GetOrgService().Create(deliverableperiod);
        }

        private static IOrganizationService GetOrgService()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }

        private static EntityReference GetOrgEntityReference()
        {
            if (_providerEntityReference != null) return _providerEntityReference;
            using (XrmServiceContext crmContext = new XrmServiceContext(GetOrgService()))
            {
                _providerEntityReference = crmContext.AccountSet.First().ToEntityReference();
            }

            return _providerEntityReference;
        }

        private static void DeleteContracts(string contractNumber)
        {
            IOrganizationService organizationService = GetOrgService();

            using (var crmContext = new XrmServiceContext(organizationService))
            {
                var matchingContracts =
                    crmContext.sfa_contractSet.Where(
                            c => c.sfa_number == contractNumber)
                        .Select(c => c.Id);

                matchingContracts.ForEach(c => organizationService.Delete(sfa_contract.EntityLogicalName, c));
            }
        }

        private PaymentScheduleEvent GetPaymentScheduleFromFile()
        {
            return TestResource.FromJson<PaymentScheduleEvent>(
                "SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests",
                "Resources.PaymentScheduleEvent_ANL-2124.json");
        }
    }
}
