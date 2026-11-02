namespace OrganisationDomain.Endpoint.Xrm.Repositories
{
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public interface ITeamRepository
    {
        EntityReference GetContractManagersTeamAsEntityReference(XrmServiceContext xrmServiceContext);
    }
}
