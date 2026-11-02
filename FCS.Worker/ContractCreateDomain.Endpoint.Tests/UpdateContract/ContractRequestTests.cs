namespace ContractCreateDomain.Endpoint.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class ContractRequestTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractRequestContractType_EnsureAllAllocationsHaveTheSameModificationDetails_ShouldUpdateNewAllocation()
        {
            // arrange
            const string newStartsSuspendedReason = "nssr";
            const string inflightNewStartsSuspendedReason = "inflightNssr";
            DateTime inflightStopNewStartsDate = DateTime.Now;
            DateTime stopNewStartsDate = inflightStopNewStartsDate.AddDays(1);

            contractType contract = new contractType
            {
                contractAllocations = new List<contractAllocation>
                {
                    new contractAllocation
                    {
                        NewStartsSuspendedReason = newStartsSuspendedReason,
                        InflightStopNewStartsDate = inflightStopNewStartsDate,
                        InflightNewStartsSuspendedReason = inflightNewStartsSuspendedReason,
                        StopNewStartsDate = stopNewStartsDate,
                    },
                    new contractAllocation
                    {
                        NewStartsSuspendedReason = newStartsSuspendedReason,
                        InflightStopNewStartsDate = inflightStopNewStartsDate,
                        InflightNewStartsSuspendedReason = inflightNewStartsSuspendedReason,
                        StopNewStartsDate = stopNewStartsDate,
                    },
                    new contractAllocation()
                }
            };

            // act
            contract.EnsureAllAllocationsHaveTheSameModificationDetails(true);

            // assert
            var allHaveModificationDetails = contract.contractAllocations.All(a => a.NewStartsSuspendedReason == newStartsSuspendedReason &&
                                                                                   a.InflightStopNewStartsDate == inflightStopNewStartsDate &&
                                                                                   a.InflightNewStartsSuspendedReason == inflightNewStartsSuspendedReason &&
                                                                                   a.StopNewStartsDate == stopNewStartsDate);

            Assert.IsTrue(allHaveModificationDetails);
        }
    }
}
