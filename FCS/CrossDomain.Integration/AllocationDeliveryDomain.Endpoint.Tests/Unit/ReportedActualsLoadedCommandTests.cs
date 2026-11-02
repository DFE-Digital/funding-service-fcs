namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using AllocationDelivery.Messages.Commands;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ReportedActualsLoadedCommandTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ReportedActualsLoadedCommand_ToStringShouldWorkWhenArraysAreNull()
        {
            ReportedActualsLoadedCommand command = new ReportedActualsLoadedCommand
            {
                FundingStreamPeriodCode = "SomeFsp"
            };

            // act
            var text = command.ToString();
        }
    }
}
