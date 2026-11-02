namespace OrganisationDomain.Implementation.Services
{
    using Integration.Entities;
    using System.Collections.Generic;
    using System.Threading.Tasks;

    public interface IOrgSupplementaryDataService
    {
        Task<OrgSupplementaryDataServiceResult> GetDataForUkprn(int ukprn);

        Task<IReadOnlyCollection<OrgSupplementaryData>> GetSupplementaryDataChanges(int numberOfDaysToCheck = -7);
    }
}
