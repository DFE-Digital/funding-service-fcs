namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Services
{
    using System.Net.Http;

    public interface IOrganisationServiceApiHttpClient
    {
        HttpResponseMessage GetHttpResponseForUkprn(int ukprn);
    }
}