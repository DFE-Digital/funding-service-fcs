namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Repositories
{
    public interface IFundingTypeFundingPeriodContractTypeRepository
    {
        string GetDefinedContractTermForProvider(string fundingTypeCode, string fundingPeriodCode, string contractType);
    }
}