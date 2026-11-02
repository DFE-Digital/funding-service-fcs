namespace SFA.FCT.ContractCreateDomain.Implementation.Repositories
{
    public interface INumberPrefixRepository
    {
        string GetMasterContractPrefix(string fundingType);

        string GetContractPrefix(string fundingType);

        string GetAllocationPrefix(string fundingStreamPeriod);
    }
}
