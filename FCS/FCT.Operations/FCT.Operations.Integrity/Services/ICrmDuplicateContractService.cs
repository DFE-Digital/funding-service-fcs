namespace SFA.FCT.Operations.Integrity.Services
{
    using Framework.Logging.Interfaces;

    public interface ICrmDuplicateContractService
    {
        void IdentifyNewDuplicateContracts(ILogger logger);
    }
}