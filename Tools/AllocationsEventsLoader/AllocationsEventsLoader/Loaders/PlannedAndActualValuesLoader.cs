using System;
using System.Configuration;
using Microsoft.Data.OData.Query.SemanticAst;
using Microsoft.Xrm.Client;
using Microsoft.Xrm.Client.Services;
using SFA.FCT.ContractCreateDomain.Implementation;

namespace AllocationsEventsLoader.Loaders
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using AllocationsEventsLoader.Helpers;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;

    public class PlannedAndActualValuesLoader
    {
        private readonly PaymentSchedulePolicyContext _paymentSchedulePolicyContext = new PaymentSchedulePolicyContext();

        public void LoadItems()
        {
            Console.WriteLine("Run started: {0}", DateTime.Now);
            Console.WriteLine("Retrieving deliverable payments items...");
            var payments = GetDeliveryablePayments();
            int numDeliverablesToRunInParallel = payments.Count/10;
            Console.WriteLine("{0} deliverable payments items retrieved.", payments.Count);

            int beginningIndex = 0;
            IList<System.Threading.Tasks.Task> taskList = new List<System.Threading.Tasks.Task>();
            do
            {
                Console.WriteLine("Parallel processing for deliverable payments items {0} to {1}.",
                    beginningIndex, beginningIndex + numDeliverablesToRunInParallel);
                var sliceOfPayment = payments.GetRange(beginningIndex, Math.Min(numDeliverablesToRunInParallel, payments.Count - beginningIndex));
                taskList.Add(System.Threading.Tasks.Task.Run(() =>
                {
                    var processor = new DeliverablePaymentProcessor(sliceOfPayment);
                    processor.Process();
                }));
                Console.WriteLine("Completed processing items {0} to {1}.", beginningIndex, beginningIndex + numDeliverablesToRunInParallel);

                beginningIndex += sliceOfPayment.Count;
            } while (beginningIndex < payments.Count);

            System.Threading.Tasks.Task.WaitAll(taskList.ToArray());
            Console.WriteLine("Run Completed: {0}", DateTime.Now);
        }

        private List<DeliverablePaymentData> GetDeliveryablePayments()
        {
            //IList<string> allocations = new string[] {"ALLB-2347", "16AP-2886", "16AP-2776", "ASTO-2788"};

            var results = _paymentSchedulePolicyContext.DeliverablePayments.
               // Where(dp => allocations.Contains(dp.AllocationNumber)).
                Select(p => new DeliverablePaymentData
                {
                    AllocationNumber = p.AllocationNumber,
                    VersionNumber = p.VersionNumber,
                    DeliverableCode = p.DeliverableCode,
                    Period = p.Period
                }).ToList();
            return results;
        }
    }
}
