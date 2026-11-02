namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Services
{
    using CrossDomain.Integration.Entities;

    public interface IOrganisationService
    {
        organisation GetOrganisationForUkprn(int ukprn);
    }
}