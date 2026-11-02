namespace Operations.Web.Checkers
{
    using System.Threading.Tasks;
    using Dtos;

    public interface ICheckAvailability
    {
        Task<AvailabilityCheckResult> GetCheckResult();

        string ServiceName { get; }
    }
}