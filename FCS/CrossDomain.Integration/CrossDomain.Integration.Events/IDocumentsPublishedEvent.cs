namespace SFA.FCT.CrossDomain.Integration.Events
{
    public interface IDocumentsPublishedEvent
    {
        int Ukprn { get; set; }

        string ContractNumber { get; set; }

        int ContractVersionNumber { get; set; }

        string[] DocumentsPublished { get; set; }
    }
}
