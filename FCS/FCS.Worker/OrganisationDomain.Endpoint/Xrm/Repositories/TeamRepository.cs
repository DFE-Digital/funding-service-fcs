namespace OrganisationDomain.Endpoint.Xrm.Repositories
{
    using System;
    using System.Collections.Concurrent;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class TeamRepository : ITeamRepository
    {
        private readonly ConcurrentDictionary<string, EntityReference> _teams = new ConcurrentDictionary<string, EntityReference>();

        public EntityReference GetContractManagersTeamAsEntityReference(XrmServiceContext xrmServiceContext)
        {
            const string notificationOwningTeamName = "Contract Managers Team";

            return _teams.GetOrAdd(notificationOwningTeamName, teamName =>
            {
                Guid teamGuid = xrmServiceContext.TeamSet.Where(t => t.Name == teamName)
                    .Select(t => t.Id)
                    .FirstOrDefault();

                return new EntityReference(Team.EntityLogicalName, teamGuid);
            });
        }
    }
}
