namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateContract
{
    using System;
    using System.Collections.Generic;

    [Serializable]
    public class ApprovedContractInfo
    {
        private List<ApprovedContractAllocationInfo> _allocations = new List<ApprovedContractAllocationInfo>();
        public string ContractNumber { get; set; }

        public string MasterContractNumber { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime? EndDate { get; set; }

        public string FundingType { get; set; }

        public string FundingPeriod { get; set; }

        public List<ApprovedContractAllocationInfo> Allocations
        {
            get => _allocations;
            set => _allocations = value;
        }
    }
}
