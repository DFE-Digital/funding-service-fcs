namespace SFA.FCT.ContractCreateDomain.Common.Messages.Commands
{
    using System.Collections.Generic;
    using System.Linq;

    public class CreateProvidersIfNecessaryCommand
    {
        public CreateProvidersIfNecessaryCommand(string fundingId,
            IEnumerable<int> ukprns,
            bool passedConfigValidation,
            int readId,
            bool isPostReadProviderNotFoundCheck,
            string parkedConfigSubStatus)
        {
            FundingId = fundingId;
            Ukprns = ukprns;
            PassedConfigValidation = passedConfigValidation;
            ReadId = readId;
            IsPostReadProviderNotFoundCheck = isPostReadProviderNotFoundCheck;
            ParkedConfigSubStatus = parkedConfigSubStatus;
        }

        public string FundingId { get; }
        public IEnumerable<int> Ukprns { get; }
        public bool PassedConfigValidation { get; }
        public int ReadId { get; }
        public bool IsPostReadProviderNotFoundCheck { get; }
        public string ParkedConfigSubStatus { get; }

        public override string ToString() => $"FundingId: {FundingId}, Ukprns count: {Ukprns?.Count()}, PassedConfigValidation: {PassedConfigValidation}, ReadId: {ReadId}, IsPostReadProviderNotFoundCheck: {IsPostReadProviderNotFoundCheck}, ParkedConfigSubStatus: {ParkedConfigSubStatus}";
    }
}
