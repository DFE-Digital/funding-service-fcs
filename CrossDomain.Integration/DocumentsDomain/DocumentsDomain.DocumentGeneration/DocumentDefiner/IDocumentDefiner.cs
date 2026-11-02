namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner
{
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;

    public interface IDocumentDefiner
    {
        DocumentGenerationRequest[] GetDocumentParts(string masterContractNumber, contractType contract);
        
        FctFile GetTargetFileName(contractType childContract);

        string GetTnCFileNameFilter(contractType childContract);

        ContractIdentificationDetails GetContractDetails(contractType childContract);
    }
}
