namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentLocationResolver
{
    using CrossDomain.Integration.Entities.CorporateContract;
    public interface IDocumentLocationResolver
    {    
        string GetLocationOfAppendices(contractType contract);

        string GetLocationOfTermsAndConditions(contractType contract);

        string GetLocationOfMergedDocument(contractType contract);

        string GetLocationOfPublishedDocument(contractType contract);
    }
}
