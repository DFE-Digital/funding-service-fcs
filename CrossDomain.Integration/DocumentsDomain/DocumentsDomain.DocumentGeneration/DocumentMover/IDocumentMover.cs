namespace SFA.FCT.DocumentsDomain.DocumentGeneration
{
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public interface IDocumentMover
    {
        void MoveContractDocumentToPublishLocation(contract masterContract);

        bool IsContractDocumentAlreadyPublished(contract masterContract);
    }
}
