namespace SFA.FCT.DocumentsDomain.DataStore.Models
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class NlapFundingConfig
    {
        public NlapFundingConfig(
            int ukprn,
            decimal newStarts2021Funding1618,
            decimal newStarts2021FundingAdult,
            decimal newStartsEstimatedFutureFunding1618,
            decimal newStartsEstimatedFutureFundingAdult)
        {
            Ukprn = ukprn;
            NewStarts2021Funding1618 = newStarts2021Funding1618;
            NewStarts2021FundingAdult = newStarts2021FundingAdult;
            NewStartsEstimatedFutureFunding1618 = newStartsEstimatedFutureFunding1618;
            NewStartsEstimatedFutureFundingAdult = newStartsEstimatedFutureFundingAdult;
        }

        private NlapFundingConfig()
        {
        }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int Ukprn { get; private set; }

        public decimal NewStarts2021Funding1618 { get; private set; }

        public decimal NewStarts2021FundingAdult { get; private set; }

        public decimal NewStartsEstimatedFutureFunding1618 { get; private set; }

        public decimal NewStartsEstimatedFutureFundingAdult { get; private set; }
    }
}
