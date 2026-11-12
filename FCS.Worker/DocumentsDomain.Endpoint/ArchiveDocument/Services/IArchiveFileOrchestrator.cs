namespace DocumentsDomain.Endpoint.ArchiveDocument.Services
{
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public interface IArchiveFileOrchestrator
    {
        IReadOnlyCollection<FileInfo> OrchestrateForNotification(Contract corporateContract);

        IReadOnlyCollection<FileInfo> OrchestrateForNonNotification(Contract corporateContract);
    }
}
