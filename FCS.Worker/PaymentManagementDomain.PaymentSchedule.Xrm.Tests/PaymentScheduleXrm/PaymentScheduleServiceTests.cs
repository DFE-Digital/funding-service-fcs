namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests.PaymentScheduleXrm
{
    extern alias Entity;
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Newtonsoft.Json;
    using PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.Repositories;
    using PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.Services;
    using PaymentSchedule.PaymentScheduleXrm.Extensions;
    using SFA.FCS.Worker.Common.Crm;
    using Entity::SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories;

    [TestClass]
    public class PaymentScheduleServiceTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentScheduleService_ShouldCreateMissingDeliverables()
        {
            // arrange
            const string contractNumber = "cn 2";
            const string existingFsp = "ANLAP2018";
            const string allocationNumber = "ANLP-497";
            
            DateTime contractStartDate = new DateTime(2018, 1, 1,0,0,0,DateTimeKind.Utc);
            var periodDates = Enumerable.Range(0, 15).ToList().Select(i => contractStartDate.AddMonths(i)).ToList();

            DeleteContract(contractNumber);
            Guid contractId = CreateContract(contractNumber);
            Guid allocationId = CreateAllocation(contractId);
            var missingDeliverableCodes = GetDeliverableCodesForFsp(existingFsp).Where(d => d != 1).ToList();
            var connection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            Guid deliverable1Id = CreateDeliverable(1, allocationId);
            periodDates.ForEach(d => CreateDeliverableDeliverablePeriod(deliverable1Id, d));
            
            PaymentScheduleService service = new PaymentScheduleService(
                new CrmFspDeliverableRepository(connection),
                new CrmDeliverableRepository(connection),
                new CrmPeriodTypeRepository(connection),
                new CrmTransactionRequestRepository(connection));

            CrmDeliverablePeriodRepository crmDeliverablePeriodRepository = new CrmDeliverablePeriodRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYearsInCrm = crmDeliverablePeriodRepository.GetDeliverablePeriodYears(allocationId);

            var message = FromJson<PaymentScheduleEvent>("PaymentManagementDomain.PaymentSchedule.Xrm.Tests",
                "Resources.PaymentSchedule_ANLP_497.json");

            IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYearsOnPaymentSchedule = message.PaymentScheduleAllocation.ToDeliverablePeriodYears();

            var deliverablePeriodYearsMissingFromCrm = deliverablePeriodYearsOnPaymentSchedule.Where(dpOnPaymentSchedule =>
                    !deliverablePeriodYearsInCrm.Contains(dpOnPaymentSchedule))
                .ToList();

            // act
            service.CreateMissingDeliverablesAndTheirPeriods( 
                GetDeliverablesForAllocation(allocationId),
                new AllocationInfo(allocationId,
                    DateTime.MinValue,
                    DateTime.MaxValue,
                    1,
                    contractId,
                    allocationNumber),
                existingFsp,
                deliverablePeriodYearsMissingFromCrm);

            // assert
            IReadOnlyCollection<int> deliverableCodesOnAllocation = GetDeliverableCodesOnAllocation(allocationId);
            Assert.IsTrue(missingDeliverableCodes.All(dc => deliverableCodesOnAllocation.Contains(dc)), "All the deliverables are not present");
            deliverablePeriodYearsInCrm = crmDeliverablePeriodRepository.GetDeliverablePeriodYears(allocationId);

            Assert.AreEqual(deliverablePeriodYearsOnPaymentSchedule.Count, deliverablePeriodYearsInCrm.Count, "All the deliverable periods are not present");
            List<DeliverablePeriodYear> dps2018_Jan = deliverablePeriodYearsInCrm
                .Where(dp => dp.DeliverableCode == "2" && dp.Period == 1 && dp.Year == 2018).ToList();
            Assert.AreEqual(11, dps2018_Jan.Single().CrmDeliverablePeriod.sfa_ProfilePaymentAmount, "The profile payment is not correct");
            Assert.AreEqual(12, dps2018_Jan.Single().CrmDeliverablePeriod.sfa_CappedPaymentAmount, "The sfa_CappedPaymentAmount is not correct");
            Assert.AreEqual(13, dps2018_Jan.Single().CrmDeliverablePeriod.sfa_BalancingPaymentAmount, "The sfa_BalancingPaymentAmount is not correct");
            Assert.AreEqual(14, dps2018_Jan.Single().CrmDeliverablePeriod.sfa_ReconciliationPaymentAmount, "The sfa_ReconciliationPaymentAmount is not correct");
            Assert.AreEqual(15, dps2018_Jan.Single().CrmDeliverablePeriod.sfa_NetPaymentAmount, "The sfa_NetPaymentAmount is not correct");
            Assert.AreEqual(16, dps2018_Jan.Single().CrmDeliverablePeriod.sfa_ActualVolume, "The sfa_ActualVolume is not correct");
            Assert.AreEqual(17, dps2018_Jan.Single().CrmDeliverablePeriod.sfa_ActualValue, "The sfa_ActualValue is not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentScheduleService_UpdateExistingDeliverablesAndTheirPeriods_ShouldCreateNewPeriodsOnExistingDeliverables()
        {
            // arrange
            const string contractNumber = "cn 2";
            const string existingFsp = "ANLAP2018";
            const string allocationNumber = "ANLP-497";

            DateTime contractStartDate = new DateTime(2018, 1, 1, 0, 0, 0, DateTimeKind.Utc);
            var periodDates = Enumerable.Range(0, 14).ToList().Select(i => contractStartDate.AddMonths(i)).ToList();

            DeleteContract(contractNumber);
            Guid contractId = CreateContract(contractNumber);
            Guid allocationId = CreateAllocation(contractId);
            var missingDeliverableCodes = GetDeliverableCodesForFsp(existingFsp).Where(d => d != 1).ToList();
            var connection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            Guid deliverable1Id = CreateDeliverable(1, allocationId);
            Guid deliverable2Id = CreateDeliverable(2, allocationId);
            Guid deliverable3Id = CreateDeliverable(3, allocationId);
            Guid deliverable4Id = CreateDeliverable(4, allocationId);
            Guid deliverable5Id = CreateDeliverable(5, allocationId);

            periodDates.ForEach(d => CreateDeliverableDeliverablePeriod(deliverable1Id, d));
            periodDates.ForEach(d => CreateDeliverableDeliverablePeriod(deliverable2Id, d));
            periodDates.ForEach(d => CreateDeliverableDeliverablePeriod(deliverable3Id, d));
            periodDates.ForEach(d => CreateDeliverableDeliverablePeriod(deliverable4Id, d));
            periodDates.ForEach(d => CreateDeliverableDeliverablePeriod(deliverable5Id, d));

            PaymentScheduleService service = new PaymentScheduleService(
                new CrmFspDeliverableRepository(connection),
                new CrmDeliverableRepository(connection),
                new CrmPeriodTypeRepository(connection),
                new CrmTransactionRequestRepository(connection));

            CrmDeliverablePeriodRepository crmDeliverablePeriodRepository = new CrmDeliverablePeriodRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYearsInCrm = crmDeliverablePeriodRepository.GetDeliverablePeriodYears(allocationId);

            var message = FromJson<PaymentScheduleEvent>("PaymentManagementDomain.PaymentSchedule.Xrm.Tests",
                "Resources.PaymentSchedule_ANLP_497.json");

            IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYearsOnPaymentSchedule = message.PaymentScheduleAllocation.ToDeliverablePeriodYears();

            var deliverablePeriodYearsMissingFromCrm = deliverablePeriodYearsOnPaymentSchedule.Where(dpOnPaymentSchedule =>
                    !deliverablePeriodYearsInCrm.Contains(dpOnPaymentSchedule))
                .ToList();

            // act
            service.UpdateExistingDeliverablesAndTheirPeriods(
                GetDeliverablesForAllocation(allocationId),
                new AllocationInfo(allocationId,
                    DateTime.MinValue,
                    DateTime.MaxValue,
                    1,
                    contractId,
                    allocationNumber),
                existingFsp,
                deliverablePeriodYearsInCrm,
                deliverablePeriodYearsOnPaymentSchedule);

            // assert
            IReadOnlyCollection<int> deliverableCodesOnAllocation = GetDeliverableCodesOnAllocation(allocationId);
            Assert.IsTrue(missingDeliverableCodes.All(dc => deliverableCodesOnAllocation.Contains(dc)), "All the deliverables are not present");
            deliverablePeriodYearsInCrm = crmDeliverablePeriodRepository.GetDeliverablePeriodYears(allocationId);

            Assert.AreEqual(deliverablePeriodYearsOnPaymentSchedule.Count, deliverablePeriodYearsInCrm.Count, "All the deliverable periods are not present");
            List<DeliverablePeriodYear> dps2019_Mar = deliverablePeriodYearsInCrm
                .Where(dp => dp.DeliverableCode == "2" && dp.Period == 3 && dp.Year == 2019).ToList();
            Assert.AreEqual(20, dps2019_Mar.Single().CrmDeliverablePeriod.sfa_ProfilePaymentAmount, "The profile payment is not correct");
            Assert.AreEqual(21, dps2019_Mar.Single().CrmDeliverablePeriod.sfa_CappedPaymentAmount, "The sfa_CappedPaymentAmount is not correct");
            Assert.AreEqual(22, dps2019_Mar.Single().CrmDeliverablePeriod.sfa_BalancingPaymentAmount, "The sfa_BalancingPaymentAmount is not correct");
            Assert.AreEqual(23, dps2019_Mar.Single().CrmDeliverablePeriod.sfa_ReconciliationPaymentAmount, "The sfa_ReconciliationPaymentAmount is not correct");
            Assert.AreEqual(24, dps2019_Mar.Single().CrmDeliverablePeriod.sfa_NetPaymentAmount, "The sfa_NetPaymentAmount is not correct");
            Assert.AreEqual(25, dps2019_Mar.Single().CrmDeliverablePeriod.sfa_ActualVolume, "The sfa_ActualVolume is not correct");
            Assert.AreEqual(26, dps2019_Mar.Single().CrmDeliverablePeriod.sfa_ActualValue, "The sfa_ActualValue is not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentScheduleService_UpdateExistingDeliverablesAndTheirPeriods_ShouldUpdateExistingPeriods()
        {
            // arrange
            const string contractNumber = "cn 2";
            const string existingFsp = "ANLAP2018";
            const string allocationNumber = "ANLP-497";

            DateTime contractStartDate = new DateTime(2018, 1, 1, 0, 0, 0, DateTimeKind.Utc);
            var periodDates = Enumerable.Range(0, 15).ToList().Select(i => contractStartDate.AddMonths(i)).ToList();

            DeleteContract(contractNumber);
            Guid contractId = CreateContract(contractNumber);
            Guid allocationId = CreateAllocation(contractId);
            var missingDeliverableCodes = GetDeliverableCodesForFsp(existingFsp).Where(d => d != 1).ToList();
            var connection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            Guid deliverable1Id = CreateDeliverable(1, allocationId);
            Guid deliverable2Id = CreateDeliverable(2, allocationId);
            Guid deliverable3Id = CreateDeliverable(3, allocationId);
            Guid deliverable4Id = CreateDeliverable(4, allocationId);
            Guid deliverable5Id = CreateDeliverable(5, allocationId);

            periodDates.ForEach(d => CreateDeliverableDeliverablePeriod(deliverable1Id, d));
            periodDates.ForEach(d => CreateDeliverableDeliverablePeriod(deliverable2Id, d));
            periodDates.ForEach(d => CreateDeliverableDeliverablePeriod(deliverable3Id, d));
            periodDates.ForEach(d => CreateDeliverableDeliverablePeriod(deliverable4Id, d));
            periodDates.ForEach(d => CreateDeliverableDeliverablePeriod(deliverable5Id, d));

            PaymentScheduleService service = new PaymentScheduleService(
                new CrmFspDeliverableRepository(connection),
                new CrmDeliverableRepository(connection),
                new CrmPeriodTypeRepository(connection),
                new CrmTransactionRequestRepository(connection));

            CrmDeliverablePeriodRepository crmDeliverablePeriodRepository = new CrmDeliverablePeriodRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYearsInCrm = crmDeliverablePeriodRepository.GetDeliverablePeriodYears(allocationId);

            var message = FromJson<PaymentScheduleEvent>("PaymentManagementDomain.PaymentSchedule.Xrm.Tests",
                "Resources.PaymentSchedule_ANLP_497.json");

            IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYearsOnPaymentSchedule = message.PaymentScheduleAllocation.ToDeliverablePeriodYears();

            var deliverablePeriodYearsMissingFromCrm = deliverablePeriodYearsOnPaymentSchedule.Where(dpOnPaymentSchedule =>
                    !deliverablePeriodYearsInCrm.Contains(dpOnPaymentSchedule))
                .ToList();

            // act
            service.UpdateExistingDeliverablesAndTheirPeriods(
                GetDeliverablesForAllocation(allocationId),
                new AllocationInfo(allocationId,
                    DateTime.MinValue,
                    DateTime.MaxValue,
                    1,
                    contractId,
                    allocationNumber),
                existingFsp,
                deliverablePeriodYearsInCrm,
                deliverablePeriodYearsOnPaymentSchedule);

            // assert
            IReadOnlyCollection<int> deliverableCodesOnAllocation = GetDeliverableCodesOnAllocation(allocationId);
            Assert.IsTrue(missingDeliverableCodes.All(dc => deliverableCodesOnAllocation.Contains(dc)), "All the deliverables are not present");
            deliverablePeriodYearsInCrm = crmDeliverablePeriodRepository.GetDeliverablePeriodYears(allocationId);

            Assert.AreEqual(deliverablePeriodYearsOnPaymentSchedule.Count, deliverablePeriodYearsInCrm.Count, "All the deliverable periods are not present");
            List<DeliverablePeriodYear> dps2018_June = deliverablePeriodYearsInCrm
                .Where(dp => dp.DeliverableCode == "3" && dp.Period == 6 && dp.Year == 2018).ToList();
            Assert.AreEqual(31, dps2018_June.Single().CrmDeliverablePeriod.sfa_ProfilePaymentAmount, "The profile payment is not correct");
            Assert.AreEqual(32, dps2018_June.Single().CrmDeliverablePeriod.sfa_CappedPaymentAmount, "The sfa_CappedPaymentAmount is not correct");
            Assert.AreEqual(33, dps2018_June.Single().CrmDeliverablePeriod.sfa_BalancingPaymentAmount, "The sfa_BalancingPaymentAmount is not correct");
            Assert.AreEqual(34, dps2018_June.Single().CrmDeliverablePeriod.sfa_ReconciliationPaymentAmount, "The sfa_ReconciliationPaymentAmount is not correct");
            Assert.AreEqual(35, dps2018_June.Single().CrmDeliverablePeriod.sfa_NetPaymentAmount, "The sfa_NetPaymentAmount is not correct");
            Assert.AreEqual(36, dps2018_June.Single().CrmDeliverablePeriod.sfa_ActualVolume, "The sfa_ActualVolume is not correct");
            Assert.AreEqual(37, dps2018_June.Single().CrmDeliverablePeriod.sfa_ActualValue, "The sfa_ActualValue is not correct");
        }

        private Guid CreateAllocation(Guid contractId)
        {
            var connection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId)
            };

            return connection.Create(allocation);
        }

        private void DeleteContract(string contractNumber)
        {
            var connection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            XrmServiceContext context = new XrmServiceContext(connection);

            context.sfa_contractSet.Where(c => c.sfa_number == contractNumber)
                .Select(c => c.sfa_contractId.Value)
                .ToList()
                .ForEach(cid => connection.Delete(sfa_contract.EntityLogicalName, cid));
        }

        private static Guid CreateContract(string contractNumber)
        {
            sfa_contract contract = new sfa_contract
            {
                sfa_number = contractNumber,
                sfa_ProviderName = GetFirstProvider()
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(contract);
        }

        private static Guid CreateDeliverable(int deliverableCode, Guid allocationId)
        {
            sfa_contractdeliverable contractDeliverable = new sfa_contractdeliverable
            {
               sfa_DeliverableCode = deliverableCode.ToString(),
               sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId)
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(contractDeliverable);
        }

        private static EntityReference GetFirstProvider()
        {
            XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            Guid orgId = context.AccountSet.Where(a => a.sfa_UKPRN != null).Select(a => a.Id).First();
            return new EntityReference(Account.EntityLogicalName, orgId);
        }

        private static IReadOnlyCollection<int> GetDeliverableCodesForFsp(string fsp)
        {
            var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            return (from fspDel in xrmContext.sfa_fundingstreamperioddeliverableSet
                    join fspCode in xrmContext.sfa_fundingstreamperiodSet
                        on fspDel.sfa_FundingStreamPeriodId.Id equals fspCode.sfa_fundingstreamperiodId
                    where fspCode.sfa_fundingstreamperiodcode == fsp
                    select fspDel.sfa_DeliverableCode.Value).ToList();
        }

        private static IReadOnlyCollection<int> GetDeliverableCodesOnAllocation(Guid allocationId)
        {
            var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            return xrmContext.sfa_contractdeliverableSet.Where(cd => cd.sfa_ContractAllocationId.Id == allocationId)
                .Select(cd => int.Parse(cd.sfa_DeliverableCode))
                .ToList();
        }

        private static IReadOnlyCollection<DeliverableInfo> GetDeliverablesForAllocation(Guid allocationId)
        {
            var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            return xrmContext.sfa_contractdeliverableSet.Where(cd => cd.sfa_ContractAllocationId.Id == allocationId)
                
                .AsEnumerable()
                .Select(cd => new DeliverableInfo(cd.Id, cd.sfa_ParentDeliverableId, cd.sfa_DeliverableCode, cd.ModifiedBy))
                .ToList();
        }

        private static Guid CreateDeliverableDeliverablePeriod(Guid deliverableId, DateTime date)
        {
            string periodName = date.ToString("MMM-yy");

            sfa_contractdeliverableperiod contractDeliverablePeriod = new sfa_contractdeliverableperiod
            {
               sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId),
               sfa_name = periodName,
               sfa_PeriodName = periodName,
               sfa_Year = date.Year,
               sfa_Period = date.Month
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(contractDeliverablePeriod);
        }

        private static T FromJson<T>(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<T>(streamReader.ReadToEnd());
            }
        }
    }
}
