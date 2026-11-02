namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Dto
{
    using System.Collections.Generic;

    public class HeldActualsForAllocationGrpIdentifier
    {
        public HeldActualsForAllocationGrpIdentifier(IReadOnlyCollection<string> partitionKeys, string fundingStreamPeriodCode)
        {
            PartitionKeys = partitionKeys;
            FundingStreamPeriodCode = fundingStreamPeriodCode;
        }

        public IReadOnlyCollection<string> PartitionKeys { get; }

        public string FundingStreamPeriodCode { get; }
    }
}
