namespace DocGenTests.Infrastructure
{
    using SFA.FCT.CrossDomain.Integration.Entities;

    public interface IFundingStreamConfigService
    {
        FSCDeliverableStructureDefinitionResponse GetFullDeliverableStructure(string fundingStreamPeriodCode);
    }
}
