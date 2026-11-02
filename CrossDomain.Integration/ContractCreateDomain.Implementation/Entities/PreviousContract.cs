namespace SFA.FCT.ContractCreateDomain.Implementation.Entities
{
    using System;
    using System.Collections.Generic;

    public class PreviousContract
    {
        public PreviousContract(DateTime? contractStartDate, DateTime? contractEndDate, string masterContractReferenceNumber,
            string amendmentType, string contractDescription, string contractType, IReadOnlyCollection<PreviousAllocation> previousAllocations)
        {
            ContractStartDate = contractStartDate;
            ContractEndDate = contractEndDate;
            MasterContractReferenceNumber = masterContractReferenceNumber;
            AmendmentType = amendmentType;
            ContractDescription = contractDescription;
            ContractType = contractType;
            PreviousAllocations = previousAllocations;
        }

        public DateTime? ContractStartDate { get; }

        public DateTime? ContractEndDate { get; }

        public string MasterContractReferenceNumber { get; }

        public string AmendmentType { get; }

        public string ContractDescription { get; }

        public string ContractType { get; }

        public IReadOnlyCollection<PreviousAllocation> PreviousAllocations { get; }
    }
}