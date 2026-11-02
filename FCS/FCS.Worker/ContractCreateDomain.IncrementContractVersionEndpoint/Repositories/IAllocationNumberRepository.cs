namespace ContractCreateDomain.IncrementContractVersionEndpoint.Repositories
{
    public interface IAllocationNumberRepository
    {
        string GetAllocationNumberPrefix(string fundingStreamPeriodCode);
    }
}