namespace OrganisationDomain.Implementation.Services
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Integration.Entities;

    public interface IOrgSupplementaryPopulationService
    {
        Task<IReadOnlyCollection<OrgSupplementaryDataExtended>> PopulateOrgSupplementaryData(IReadOnlyCollection<int> unsuccessfulUkprns);
    }
}
