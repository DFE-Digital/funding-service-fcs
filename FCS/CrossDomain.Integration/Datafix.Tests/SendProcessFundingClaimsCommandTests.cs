namespace Datafix.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using SFA.FCT.PerformanceManagementDomain.Common.Commands;

    [TestClass]
    public class SendProcessFundingClaimsCommandTests
    {
        [TestMethod, TestCategory("DataFix_24755")]
        public void ShouldSendProcessFundingClaimsCommandFor1718YearEndFundingClaims()
        {
            CreateBus().Send(
                "PerformanceManagementDomain.FundingClaimImport",
                new ProcessFundingClaimsCommand(period: "1718", claimTypeName: "YEAREND"));
        }

        private static ISendOnlyBus CreateBus()
        {
            BusConfiguration configuration = new BusConfiguration();
            configuration.UseSerialization<JsonSerializer>();
            configuration.UseTransport<AzureServiceBusTransport>();
            configuration.Conventions().DefiningCommandsAs(t => t == typeof(ProcessFundingClaimsCommand));

            return Bus.CreateSendOnly(configuration);
        }
    }
}
