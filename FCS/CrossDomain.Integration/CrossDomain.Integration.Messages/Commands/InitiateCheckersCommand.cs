namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    using System.Collections.Generic;

    public class InitiateCheckersCommand
    {
        public IEnumerable<string> ChecksToRun { get; set; }
        public long? ChangeTrackingCurrentVersionOverride { get; set; }

        public static InitiateCheckersCommand CreatePostMonthEndIntegrityChecksCommand()
        {
            return new InitiateCheckersCommand
            {
                ChecksToRun = new[]
                {
                    // remember - integrity checker names name must be 50 chars or less
                    "ALLOC_LEVEL_ACTUALS_SUMACTUAL_TO_DELIVPAYT_ACTUALS",
                    "ANITA_PAAS_EXTRACT",
                    "CRM_TO_PAAS_CHECK_SUBNOMINAL_AGGREGATION",
                    "PAAS_TO_CRM_CHECK_SUBNOMINAL_AGGREGATION",
                    "PAYCALC_VS_PAYGEN_CHECK",
                    "PAYMENT_INSTRUCTIONS_SUMACTUAL_TO_DELIV_PAYMENTS",
                    "DELIVERABLE_PAYMENT_POSITIVE_CAP_CHECKER"
                }
            };
        }

        public static InitiateCheckersCommand CreatePostMonthEndImmediateBatchIntegrityChecksCommand()
        {
            return new InitiateCheckersCommand
            {
                ChecksToRun = new[]
                {
                    "ALLOC_LEVEL_ACTUALS_SUMACTUAL_TO_DELIVPAYT_ACTUALS",
                    "ANITA_PAAS_EXTRACT",
                    "PAYMENT_INSTRUCTIONS_SUMACTUAL_TO_DELIV_PAYMENTS",
                    "DELIVERABLE_PAYMENT_POSITIVE_CAP_CHECKER"
                }
            };
        }

        public static InitiateCheckersCommand CreatePostMonthEndDelayedBatchIntegrityChecksCommand()
        {
            return new InitiateCheckersCommand
            {
                ChecksToRun = new[]
                {
                    "CRM_TO_PAAS_CHECK_SUBNOMINAL_AGGREGATION",
                    "PAAS_TO_CRM_CHECK_SUBNOMINAL_AGGREGATION",
                    "PAYCALC_VS_PAYGEN_CHECK",
                }
            };
        }

        public static InitiateCheckersCommand CreateNightlyIntegrityChecksCommand()
        {
            return new InitiateCheckersCommand
            {
                ChecksToRun = new[]
                {
                    "PAAS_TO_CRM_CHECK_DELIVERABLE_PAYMENT"
                }
            };
        }
    }
}
