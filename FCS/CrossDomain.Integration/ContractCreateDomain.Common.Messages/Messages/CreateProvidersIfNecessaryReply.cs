namespace SFA.FCT.ContractCreateDomain.Common.Messages.Messages
{
    public class CreateProvidersIfNecessaryReply
    {
        public CreateProvidersIfNecessaryReply(string fundingId, bool allProvidersExist, bool passedConfigValidation, int readId, bool isPostReadProviderNotFoundCheck, string parkedConfigSubStatus)
        {
            FundingId = fundingId;
            AllProvidersExist = allProvidersExist;
            PassedConfigValidation = passedConfigValidation;
            ReadId = readId;
            IsPostReadProviderNotFoundCheck = isPostReadProviderNotFoundCheck;
            ParkedConfigSubStatus = parkedConfigSubStatus;
        }

        public string FundingId { get; }
        public bool AllProvidersExist { get; }
        public bool PassedConfigValidation { get; }
        public int ReadId { get; }
        public bool IsPostReadProviderNotFoundCheck { get; }
        public string ParkedConfigSubStatus { get; }

        public bool PassedAllValidation => AllProvidersExist && PassedConfigValidation;

        public override string ToString() => $"FundingId: {FundingId}, AllProvidersExist: {AllProvidersExist}, PassedConfigValidation: {PassedConfigValidation}, ReadId: {ReadId}, IsPostReadProviderNotFoundCheck: {IsPostReadProviderNotFoundCheck}, ParkedConfigSubStatus: {ParkedConfigSubStatus}";
    }
}
