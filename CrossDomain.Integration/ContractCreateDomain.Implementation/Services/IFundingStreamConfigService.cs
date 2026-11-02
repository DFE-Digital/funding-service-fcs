namespace SFA.FCT.ContractCreateDomain.Implementation.Services
{
    using CrossDomain.Integration.Entities;

    public interface IFundingStreamConfigService
    {
        FSCDeliverableStructureDefinitionResponse GetFullDeliverableStructure(string fundingStreamPeriodCode);
    }
}