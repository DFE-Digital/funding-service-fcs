namespace SFA.FCT.DocumentsDomain.DataStore.Repositories
{
    using Models;

    public interface IContractDocumentTemplateRepository
    {
        ContractDocumentTemplate GetByKey(string fundingTypeCode, string fundingPeriodCode, string documentComponentCode, string contractType);
    }
}
