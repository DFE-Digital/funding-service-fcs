namespace FundingAllocation.Repositories
{
    using System.Net.Http;

    public interface ICrmPolicyConfigRepository
    {
        string GetFundingTypeEntityReference(string restApiUrl, HttpClient httpClient, string accessToken, string id);

        string GetPeriodEntityReference(string restApiUrl, HttpClient httpClient, string accessToken, string periodName);
        string GetContractTypeId(string restApiUrl, HttpClient httpClient, string accessToken, string contractType);
        string GetFspGroupId(string restApiUrl, HttpClient httpClient, string accessToken, string fspGroupCode);
    }
}