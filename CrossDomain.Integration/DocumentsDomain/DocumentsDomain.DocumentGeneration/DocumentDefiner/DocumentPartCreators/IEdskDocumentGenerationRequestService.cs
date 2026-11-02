namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators
{
    using System.Collections.Generic;
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;

    public interface IEdskDocumentGenerationRequestService
    {
        IDictionary<string, DocumentGenerationRequest> GetDocumentGenerationRequestsWithSortOrder(
            string documentComponentCode,
            string masterContractNumber,
            contractType contract,
            string templateContainer);
    }
}