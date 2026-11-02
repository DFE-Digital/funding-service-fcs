
namespace AllocationsEventsLoader.Loaders
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;

    public class AllocationsValuesLoader
    {
        private readonly PaymentSchedulePolicyContext _paymentSchedulePolicyContext = new PaymentSchedulePolicyContext();

        public void LoadItems()
        {
            Console.WriteLine("Run started: {0}", DateTime.Now);
            Console.WriteLine("Retrieving Allocations from the database...");
            var allocations = GetAllocations();
            int numAllocationToRunInParallel = allocations.Count/10;
            Console.WriteLine("{0} Allocation items retrieved.", allocations.Count);

            int beginningIndex = 0;
            IList<System.Threading.Tasks.Task> taskList = new List<System.Threading.Tasks.Task>();
            do
            {
                Console.WriteLine("Parallel processing for Allocation items {0} to {1}.",
                    beginningIndex, beginningIndex + numAllocationToRunInParallel);
                var sliceOfAllocations = allocations.GetRange(beginningIndex, Math.Min(numAllocationToRunInParallel, allocations.Count - beginningIndex));
                taskList.Add(System.Threading.Tasks.Task.Run(() =>
                {
                    var processor = new AllocationsProcessor(sliceOfAllocations);
                    processor.Process();
                }));
                Console.WriteLine("Completed processing items {0} to {1}.", beginningIndex, beginningIndex + numAllocationToRunInParallel);

                beginningIndex += numAllocationToRunInParallel;
            } while (beginningIndex < allocations.Count);

            System.Threading.Tasks.Task.WaitAll(taskList.ToArray());
            Console.WriteLine("Run Completed: {0}", DateTime.Now);
        }

        private List<Allocation> GetAllocations()
        {
            return _paymentSchedulePolicyContext.Allocations.ToList();
        }

   


    }
}
