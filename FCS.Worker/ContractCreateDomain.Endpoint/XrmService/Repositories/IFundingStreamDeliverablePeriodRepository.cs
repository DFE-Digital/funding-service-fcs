namespace ContractCreateDomain.Endpoint.XrmService.Repositories
{
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public interface IFundingStreamDeliverablePeriodRepository
    {
        IReadOnlyCollection<sfa_fundingstreamperioddeliverable> GetFundingStreamPeriodDeliverables(
            XrmServiceContext xrmContext, string fundingStreamPeriodCode);
    }
}
