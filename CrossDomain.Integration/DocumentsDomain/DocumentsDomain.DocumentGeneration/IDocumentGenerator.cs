namespace SFA.FCT.DocumentsDomain.DocumentGeneration
{
    using System;
    using CrossDomain.Integration.Entities.CorporateContract;
    using Common.Commands;

    public interface IDocumentGenerator
    {
        DocumentSaveCommand GenerateDocument(string correlationId, Contract contract, string masterContractNumber);
    }
}
