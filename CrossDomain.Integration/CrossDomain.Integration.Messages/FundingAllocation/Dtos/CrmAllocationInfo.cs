namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos
{
    public class CrmAllocationInfo
    {
        public CrmAllocationInfo(string fundingStreamCode, string deliveryOrgUkprn, string allocationNumber)
        {
            FundingStreamCode = fundingStreamCode;
            DeliveryOrgUkprn = deliveryOrgUkprn;
            AllocationNumber = allocationNumber;
        }

        public string FundingStreamCode { get; }
        public string DeliveryOrgUkprn { get; }
        public string AllocationNumber { get; }

        public override string ToString()
        {
            return $"{{FundingStreamCode: {FundingStreamCode}, DeliveryOrgUkprn: {DeliveryOrgUkprn}, AllocationNumber: {AllocationNumber}}}";
        }
    }
}