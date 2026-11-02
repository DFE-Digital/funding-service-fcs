namespace AllocationsEventsLoader.Loaders
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Entities;
    using Helpers;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Repositories;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;

    public class LocalStoreToCrmChecker
    {
        private LookupManager _lookupManager;
        public void CheckValues(bool deleteDuplicates = false)
        {
            Console.WriteLine("Run started: {0}", DateTime.Now);
            Console.WriteLine("Retrieving deliverable payments items...");
            CreateLookupManager();
            IList<System.Threading.Tasks.Task> taskList = new List<System.Threading.Tasks.Task>();
            IDictionary<string, IList<DeliverablePeriodsValueData>> crmPayments = null;
            List<DeliverablePaymentData> sqlPayments = null;
            ConcurrentDictionary<string, IList<DeliverablePeriodsValueData>> crmDeliverablePeriodDictionary = new ConcurrentDictionary<string, IList<DeliverablePeriodsValueData>>();

            sqlPayments = GetDeliveryablePayments();

            var distinctAllocations = sqlPayments.Select(p => new {p.AllocationNumber, p.VersionNumber}).Distinct().ToList();

            Console.WriteLine("Number of distinct Allocations {0}.", distinctAllocations.Count);

            foreach (var distinctAllocation in distinctAllocations)
            {
                _lookupManager.PopulateDeliverablePaymentsDictionary(crmDeliverablePeriodDictionary, distinctAllocation.AllocationNumber, distinctAllocation.VersionNumber);
            }

            Console.WriteLine("Populated the dictionary {0}.", DateTime.Now);

            BlockingCollection<PaymentValueDifferenceItem> paymentValueDifferenceItems = new BlockingCollection<PaymentValueDifferenceItem>();
            var processor = new DeliverablePaymentGroupToCrmChecker(sqlPayments, crmDeliverablePeriodDictionary);
            processor.Process(paymentValueDifferenceItems, deleteDuplicates);
            CsvWriter<PaymentValueDifferenceItem> csvWriter = new CsvWriter<PaymentValueDifferenceItem>($"payment_differences{DateTime.Now.Ticks}.csv");
            csvWriter.SaveItems(paymentValueDifferenceItems);
            Console.WriteLine("Run Completed: {0}", DateTime.Now);
        }

        private List<DeliverablePaymentData> GetDeliveryablePayments()
        {
            //IList<string> allocations = new string[] {"ALLB-2347", "16AP-2886", "16AP-2776", "ASTO-2788"};
            using (var paymentSchedulePolicyContext = new PaymentSchedulePolicyContext())
            {
                return paymentSchedulePolicyContext.Database.SqlQuery<DeliverablePaymentData>(@"SELECT dp.[AllocationNumber]
      ,dp.[VersionNumber]
      ,dp.[DeliverableCode]
      ,dp.[Period]
      ,dp.[PlannedVolumne]
      ,ISNULL(dp.[PlannedValue], 0) as 'PlannedValue'
      ,ISNULL(dp.[ProfilePaymentAmount], 0) as 'ProfilePaymentValue'
      ,ISNULL(dp.[CappedPaymentAmount], 0) as 'CappingPaymentValue'
      ,ISNULL(dp.[BalancingPaymentAmount], 0) as 'BalancingPaymentValue'
      ,ISNULL(dp.[ReconciliationPaymentAmount], 0) as 'ReconciliationPaymentValue'
      ,ISNULL(dp.[NetPaymentAmount], 0) as 'NetPaymentValue'
      ,ISNULL(dp.[ActualValue], 0) as 'ActualValue'
  FROM [MonitoringDeliverables].[AllocationDeliverablePeriod] adp, [PaymentSchedule].[DeliverablePayment] dp
  where adp.[ContractAllocationNumber] = dp.[AllocationNumber]
  and adp.[ContractVersionNumber] = dp.[VersionNumber]
  and adp.[DeliverableCode] = dp.[DeliverableCode]
  and adp.[Period] = dp.[Period]").ToList();
                   
            }
        }

        private void CreateLookupManager()
        {
            _lookupManager = new LookupManager
            {
                EnduringCacheManager = new EnduringCacheManager(),
                BatchCacheManager = new BatchCacheManager()
            };
            CrmConnection xrmConnection =
               CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);
            _lookupManager.OrganizationService = new OrganizationService(xrmConnection);
        }
    }
}
