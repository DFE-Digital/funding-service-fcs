namespace Datafix.Tests.Dtos
{
    using System;
    using System.Collections.Generic;
    using Microsoft.Xrm.Sdk;

    public class CrmContractTerminationInfo
    {
        public CrmContractTerminationInfo(
            Guid contractId,
            DateTime? terminationDate,
            OptionSetValue terminationReason,
            IReadOnlyCollection<CrmAllocationTerminationInfo> allocations)
        {
            ContractId = contractId;
            TerminationDate = terminationDate;
            TerminationReason = terminationReason;
            Allocations = allocations;
        }

        public Guid ContractId { get; }
        public DateTime? TerminationDate { get; }
        public OptionSetValue TerminationReason { get; }
        public IReadOnlyCollection<CrmAllocationTerminationInfo> Allocations { get; }
    }

    public class CrmAllocationTerminationInfo
    {
        public CrmAllocationTerminationInfo(Guid allocationId, DateTime? terminationDate, DateTime? stopNewStartsDate)
        {
            AllocationId = allocationId;
            TerminationDate = terminationDate;
            StopNewStartsDate = stopNewStartsDate;
        }

        public Guid AllocationId { get; }
        public DateTime? TerminationDate { get; }
        public DateTime? StopNewStartsDate { get; }
    }
}
