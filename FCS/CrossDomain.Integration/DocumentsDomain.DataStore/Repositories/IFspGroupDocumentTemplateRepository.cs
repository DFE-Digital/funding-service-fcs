namespace SFA.FCT.DocumentsDomain.DataStore.Repositories
{
    using Models;

    public interface IFspGroupDocumentTemplateRepository
    {
        FspGroupDocumentTemplate GetByKeyOrUseDefaultForContractType(
            string fundingTypeCode,
            string fundingPeriodCode,
            string documentComponentCode,
            string contractType,
            string fspGroupCode);
    }
}