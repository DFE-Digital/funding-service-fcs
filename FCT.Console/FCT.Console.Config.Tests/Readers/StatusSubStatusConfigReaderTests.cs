namespace FCT.Console.Config.Tests.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class StatusSubStatusConfigReaderTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldProvideThePreDefinedConfiguration()
        {
            List<(string status, string subStatus)> statusesExpected = new List<(string status, string subStatus)>
            {
                (StatusSubStatusConfigReader.ContractApproved, StatusSubStatusConfigReader.ContractApproved),
                (StatusSubStatusConfigReader.Withdrawn, StatusSubStatusConfigReader.Withdrawn),
                (StatusSubStatusConfigReader.Discarded, StatusSubStatusConfigReader.Superseded),
                (StatusSubStatusConfigReader.Discarded, StatusSubStatusConfigReader.NonMaterialUpdate),
                (StatusSubStatusConfigReader.Parked, StatusSubStatusConfigReader.AwaitingOutcome),
                (StatusSubStatusConfigReader.StatusScheduling, StatusSubStatusConfigReader.SubStatusAwaitingRelease),
                (StatusSubStatusConfigReader.Parked, StatusSubStatusConfigReader.AwaitingFundingAllocationConfig),
                (StatusSubStatusConfigReader.Parked, StatusSubStatusConfigReader.AwaitingContractTypeConfig),
                (StatusSubStatusConfigReader.Parked, StatusSubStatusConfigReader.AwaitingFundingLineConfig),
                (StatusSubStatusConfigReader.Parked, StatusSubStatusConfigReader.AwaitingProvider),
                (StatusSubStatusConfigReader.StatusParkedPending, StatusSubStatusConfigReader.SubStatusProviderCheck),
            };
            // arrange
            var target = new StatusSubStatusConfigReader();

            // act
            var actualStatuses = target.ReadConfig();

            //assert
            statusesExpected.All(expected => actualStatuses.Any(actual => actual.Status == expected.status &&
                                                                          actual.SubStatus == expected.subStatus)).Should().BeTrue();
        }
    }
}
