namespace SFA.FCT.FundingStreamConfigDomain.BusinessLogic
{
    using CrossDomain.Integration.Common;

    public class FundingStreamConfigDomainEvents
    {
        public const int FscDomainSeedFundingStreamPeriodSettingConfiguration = LoggingEventId.FundingStreamConfigDomain;
        public const int FscDomainSeedDeliverableSettingConfiguration = LoggingEventId.FundingStreamConfigDomain + 1;
        public const int FscDomainSeedFundingStreamPeriodConfiguration = LoggingEventId.FundingStreamConfigDomain + 2;
    }
}
