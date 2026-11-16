namespace SFA.FCT.DocumentsDomain.DocumentGeneration
{
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public interface IDocumentMover
    {
        void MoveContractDocumentToPublishLocation(Contract masterContract);

        bool IsContractDocumentAlreadyPublished(Contract masterContract);
    }
}
