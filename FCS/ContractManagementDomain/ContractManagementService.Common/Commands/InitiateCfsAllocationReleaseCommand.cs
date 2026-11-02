namespace SFA.FCT.ContractManagementService.Common.Commands
{
    public class InitiateCfsAllocationReleaseCommand
    {
        public string FundingType { get; set; }

        public string FundingPeriod { get; set; }

        public override string ToString()
        {
            return $"FundingType: {FundingType}, FundingPeriod: {FundingPeriod}";
        }
    }
}
