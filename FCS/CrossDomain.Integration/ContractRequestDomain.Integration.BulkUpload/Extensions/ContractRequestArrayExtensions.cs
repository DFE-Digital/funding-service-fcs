namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload.Extensions
{
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;

    public static class ContractRequestArrayExtensions
    {
        public static (string fundingTypeCode, string fundingPeriodName) GetFundingInfo(this 
            contractRequestType[] contractRequestTypes)
        {
            var contractRequestType = contractRequestTypes.First();
            return (contractRequestType.contract.fundingTypeCode, contractRequestType.GetFundingPeriod());
        }
    }
}
