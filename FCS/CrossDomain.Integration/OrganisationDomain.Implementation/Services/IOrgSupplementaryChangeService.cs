namespace OrganisationDomain.Implementation.Services
{
    using System;
    using System.Collections.Generic;
    using Integration.Entities;

    public interface IOrgSupplementaryChangeService
    {
        IReadOnlyCollection<OrgChangedData> ChangeOrgSupplementaryData(
            IReadOnlyCollection<OrgSupplementaryData> supplementaryDataChanges);
    }
}