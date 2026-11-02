namespace SFA.FCT.CrossDomain.Integration.Entities.ContractRequest
{
    using System;
    using System.Collections.Generic;

    [Serializable]
    public class AllocationValueData
    {
        public AllocationValueData()
        {
            DeliverableCodes = new List<int>();
        }

        public string ContractAllocationNumber { get; set; }

        public decimal MaximumContractValue { get; set; }
        
        public IEnumerable<int> DeliverableCodes { get; set; }

        public DateTime? StartDate { get; set; }

        public DateTime? EndDate { get; set; }
    }
}
