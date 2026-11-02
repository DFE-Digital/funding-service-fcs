namespace SFA.FCT.Contracts.AcceptanceTests.Pages.DTO
{
    using System.Collections.Generic;

    public class SimpleContractDeliverable
    {
        public string ContractNumber { get; set; }

        public string AllocationReference { get; set; }

        public string DeliverableCode { get; set; }

        public string Description { get; set; }

        public string Name { get; set; }

        public int UnitCost { get; set; }

        public int Volume { get; set; }

        public List<SimpleContractDeliverablePeriod> Periods { get; set; }
    }
}
