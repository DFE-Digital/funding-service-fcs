namespace ContractManagementDomain.Endpoint.DeleteContract.Services
{
    public interface IDeleteDocumentsService
    {
        void DeleteDocumentsForContract(string contractNumber, int version);
    }
}
