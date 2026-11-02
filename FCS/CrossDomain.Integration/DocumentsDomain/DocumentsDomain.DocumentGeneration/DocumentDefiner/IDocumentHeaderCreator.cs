namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner
{
    using System;
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;

    public interface IDocumentHeaderCreator
    {
        bool CanSupplyHeader(string headerName);

        Tuple<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(string masterContractNumber, contractType contract, string templateContainer);
    }
}
