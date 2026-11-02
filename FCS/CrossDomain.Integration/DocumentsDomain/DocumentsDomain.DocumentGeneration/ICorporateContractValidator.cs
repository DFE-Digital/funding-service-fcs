namespace SFA.FCT.DocumentsDomain.DocumentGeneration
{
    using CrossDomain.Integration.Entities.CorporateContract;

    public interface ICorporateContractValidator
    {
        string Validate(contract masterContract);
    }
}
