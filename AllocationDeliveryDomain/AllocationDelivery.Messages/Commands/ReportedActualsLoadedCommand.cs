namespace AllocationDelivery.Messages.Commands
{
    using System.Collections.Generic;
    using System.Linq;
    using DTOs;

    public class ReportedActualsLoadedCommand
    {
        public string[] PartitionKeys { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        public SummarisedActualOrgFspGroupKey[] SummarisedActualOrgFspGroupKeys { get; set; }

        private IEnumerable<string> GetSummarisedActualOrgFspGroupKeyStrings =>
            (SummarisedActualOrgFspGroupKeys ?? new SummarisedActualOrgFspGroupKey[0]).Select(k => k.ToString());

        private string[] GetPartitionKeys => PartitionKeys ?? new string[0];

        public override string ToString()
        {
            return
                $"FundingStreamPeriodCode: {FundingStreamPeriodCode}, PartitionKeys: {string.Join(",", GetPartitionKeys)}, SummarisedActualOrgFspGroupKeys: {string.Join(",", GetSummarisedActualOrgFspGroupKeyStrings)}";
        }
    }
}
