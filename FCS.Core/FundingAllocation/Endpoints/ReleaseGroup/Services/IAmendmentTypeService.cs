namespace FundingAllocation.Endpoints.ReleaseGroup.Services
{
    using System.Threading.Tasks;

    public interface IAmendmentTypeService
    {
        Task<string> GetAmendmentType(GetAmendmentTypeInput getAmendmentTypeInput);
    }
}