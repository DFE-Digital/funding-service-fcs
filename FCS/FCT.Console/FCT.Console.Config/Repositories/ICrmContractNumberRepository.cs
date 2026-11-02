namespace FCT.Console.Config.Repositories
{
    using Infrastructure;

    public interface ICrmContractNumberRepository
    {
        int? GetCurrentContractNumber(ContractNumberType contractNumberType, string context);
    }
}