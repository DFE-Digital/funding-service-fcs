
namespace AllocationsEventsLoader
{
    using System;
    using Loaders;  
    using System.Collections.Generic;
    using MoreLinq;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;

    class Program
    {        
        private static readonly IDictionary<string, Action> Options = new Dictionary<string, Action>();
        private static readonly IMonitoringDeliverablesDbContext MonitoringDeliverablesDbContext = new MonitoringDeliverablesDbContext();

        static void Main(string[] args)
        {
            string uppercaseOption = string.Empty;

            if (args.Length > 0)
            {
                uppercaseOption = GetOption(args[0]).ToUpper();
            }


            ExecuteOption(uppercaseOption);
            
            Console.WriteLine("DONE.. press any key to exit");
            Console.ReadKey();
        }

        static Program()
        {
            Options.Add("CONTRACTALLOCATIONSACTUALS_RECEIVED", LoadContractAllocationsActualsReceivedItems);
            Options.Add("CONTRACTALLOCATIONSACTUALS_PAYMENT_POSTED", LoadContractAllocationsPaymentPostedItems);
            Options.Add("NEW_AND_AMENDED_CONTRACT_ALLOCATION_APPROVED", LoadNewAndAmendedContractAllocationsApprovedItems);
            Options.Add("PLANNED_AND_ACTUAL_VALUES", LoadPlannedAndActualValues);
            Options.Add("ALLOCATION_START_AND_END_DATES", LoadAllocationStartAndEndDates);
            Options.Add("LOCAL_STORE_TO_CRM_CHECK", LocalStoreToCrmCheck);
            Options.Add("LOCAL_STORE_TO_CRM_SUBNOMINAL_AGGREGATION_CHECK", LocalStoreToCrmSubnominalAggregationCheck);
            Options.Add("LOCAL_STORE_TO_CRM_CHECK_WITH_DELETE_CRM_DUPLICATES", LocalStoreToCrmCheckWithDeleteCrmDuplicates);
        }

        private static string GetOption(string arg)
        {
            if (arg.StartsWith("/") || arg.StartsWith("-"))
            {
                return arg.Substring(1);
            }

            return arg;
        }

        private static void ExecuteOption(string uppercaseOption)
        {
            if (!string.IsNullOrWhiteSpace(uppercaseOption))
            {
                if (Options.ContainsKey(uppercaseOption))
                {
                    Options[uppercaseOption]();
                }
                else
                {
                    Console.Error.WriteLine("Invalid option selected.");
                }
            }
            else
            {
                // by default run all options
                Options.Values.ForEach(action => action());
            }
        }

        private static void LoadNewAndAmendedContractAllocationsApprovedItems()
        {
            NewAndAmendedContractAllocationApprovedFeedLoader loader = new NewAndAmendedContractAllocationApprovedFeedLoader(MonitoringDeliverablesDbContext);
            loader.LoadFeed();
        }
        
        private static void LoadAmendedContractAllocationsApprovedItems()
        {
            throw new NotImplementedException();
        }

        private static  void LoadContractAllocationsActualsReceivedItems()
        {
            new ContractAllocationsActualsVerifiedItemLoader().LoadItems();
        }

        private static void LoadContractAllocationsPaymentPostedItems()
        {
            new ContractAllocationsPaymentPostedItemLoader().LoadItems();
        }

        private static void LoadPlannedAndActualValues()
        {
            new PlannedAndActualValuesLoader().LoadItems();
        }

        private static void LoadAllocationStartAndEndDates()
        {
            new AllocationsValuesLoader().LoadItems();
        }

        private static void LocalStoreToCrmCheck()
        {
            new LocalStoreToCrmChecker().CheckValues();
        }

        private static void LocalStoreToCrmSubnominalAggregationCheck()
        {
            new LocalStoreToCrmSubnominalAggregationChecker().CheckValues();
        }

        private static void LocalStoreToCrmCheckWithDeleteCrmDuplicates()
        {
            new LocalStoreToCrmChecker().CheckValues(true);
        }
    }
}
