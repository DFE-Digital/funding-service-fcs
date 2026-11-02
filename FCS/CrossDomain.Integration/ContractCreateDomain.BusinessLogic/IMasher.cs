namespace SFA.FCT.ContractCreateDomain.BusinessLogic
{
    using CrossDomain.Integration.Entities.ContractRequest;

    public interface IMasher
    {
       contractType Mash(contractType crmContract, contractType delta);
    }
}
