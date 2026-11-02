namespace Operations.Web.Checkers
{
    using Dtos;
    using Operations.Web.GatewayServiceContract;
    using Services;
    using System;
    using System.Threading.Tasks;

    public class UkrlpCheckAvailability : ICheckAvailability
    {
        private readonly IUkrlpServiceQuerier _ukrlpServiceQuerier;
        private const string TestProvider1 = "90000058";

        public UkrlpCheckAvailability(IUkrlpServiceQuerier ukrlpServiceQuerier)
        {
            _ukrlpServiceQuerier = ukrlpServiceQuerier;
        }

        public async Task<AvailabilityCheckResult> GetCheckResult()
        {
            try
            {
                bool doesUkprnExistInUkrlp = await _ukrlpServiceQuerier.DoesUkprnExistInUkrlp(new[] {TestProvider1});
             
                string message = doesUkprnExistInUkrlp
                    ? "Successful"
                    : "Could not retrieve expected provider, even though an exception was not thrown";
                AvailabilityCheckResult availabilityCheckResult = new AvailabilityCheckResult(ServiceName, doesUkprnExistInUkrlp)
                {
                    Details = message
                };
                
                return availabilityCheckResult;
            }
            catch (Exception e)
            {
                await Task.Delay(1);
                return new AvailabilityCheckResult(ServiceName, false) {Details = e.Message};
            }
        }

        public string ServiceName => "Ukrlp Service";
    }
}