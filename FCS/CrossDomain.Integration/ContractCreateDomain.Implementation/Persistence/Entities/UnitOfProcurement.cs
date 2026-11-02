namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities
{
    public class UnitOfProcurement
    {
        public UnitOfProcurement(string code, string procurement, string fundingStreamPeriodCode)
        {
            Code = code;
            Procurement = procurement;
            FundingStreamPeriodCode = fundingStreamPeriodCode;
        }

        public string Code { get; }

        public string Procurement { get; }

        public string FundingStreamPeriodCode { get; }
    }
}
