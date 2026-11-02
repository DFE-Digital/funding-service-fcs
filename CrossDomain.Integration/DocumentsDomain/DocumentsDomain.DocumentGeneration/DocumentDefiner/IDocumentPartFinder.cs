namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner
{
    using CrossDomain.Integration.Entities.CorporateContract;

    public interface IDocumentPartFinder
    {
        DocumentPartCreator[] GetDocumentPartCreators(contractType contract);

        IDocumentHeaderCreator[] GetDocumentHeaderCreators();
    }
}
