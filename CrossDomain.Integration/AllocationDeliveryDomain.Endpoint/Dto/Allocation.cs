namespace AllocationDeliveryDomain.Endpoint.Dto
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;

    public class Allocation
    {
        public string ContractAllocationNumber { get; set; }

        public DateTime AllocationStartDate { get; set; }

        public DateTime AllocationEndDate { get; set; }

        public string ContractNumber { get; set; }

        public int ContractVersionNumber { get; set; }

        public int ContractSubVersionNumber { get; set; }

        public string Ukprn { get; set; }
    }
}
