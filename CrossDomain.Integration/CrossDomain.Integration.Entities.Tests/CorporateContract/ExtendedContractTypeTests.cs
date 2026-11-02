namespace CrossDomain.Integration.Entities.Tests.CorporateContract
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class ExtendedContractTypeTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ExtendedContractType_CopyTerminationDetailsToProvisionalFields_ShouldCopyAllValues()
        {
            // arrange
            ExtendedContractType extendedContractType = new ExtendedContractType
            {
                StopNewStartsDate = DateTime.UtcNow.AddDays(1),
                NewStartsSuspendedReason = "Contract NewStartsSuspendedReason",
                TerminationDate = DateTime.UtcNow.AddDays(2),
                TerminationReason = "Contract TerminationReason",
                contractAllocations = new List<ExtendedContractAllocation>
                {
                    new ExtendedContractAllocation
                    {
                        StopNewStartsDate = DateTime.UtcNow.AddDays(3),
                        NewStartsSuspendedReason = "Allocation1 NewStartsSuspendedReason",
                        FundingCessationDate = DateTime.UtcNow.AddDays(4)
                    },
                    new ExtendedContractAllocation
                    {
                        StopNewStartsDate = DateTime.UtcNow.AddDays(5),
                        NewStartsSuspendedReason = "Allocation2 NewStartsSuspendedReason",
                        FundingCessationDate = DateTime.UtcNow.AddDays(6)
                    }
                }
            };

            // act
            extendedContractType.CopyTerminationDetailsToProvisionalFields();

            // assert
            Assert.AreEqual(extendedContractType.StopNewStartsDate, extendedContractType.InflightStopNewStartsDate,
                "Contract InflightStopNewStartsDate should be populated from StopNewStartsDate");
            Assert.AreEqual(extendedContractType.NewStartsSuspendedReason, extendedContractType.InflightNewStartsSuspendedReason,
                "Contract InflightNewStartsSuspendedReason should be populated from NewStartsSuspendedReason");
            Assert.AreEqual(extendedContractType.TerminationDate, extendedContractType.InflightTerminationDate,
                "Contract InflightTerminationDate should be populated from TerminationDate");
            Assert.AreEqual(extendedContractType.TerminationReason, extendedContractType.InflightTerminationReason,
                "Contract InflightTerminationReason should be populated from TerminationReason");

            extendedContractType.contractAllocations.ForEach(allocation =>
            {
                Assert.AreEqual(allocation.StopNewStartsDate, allocation.InflightStopNewStartsDate,
                    "Allocation InflightStopNewStartsDate should be populated from StopNewStartsDate");
                Assert.AreEqual(allocation.NewStartsSuspendedReason, allocation.InflightNewStartsSuspendedReason,
                    "Allocation InflightNewStartsSuspendedReason should be populated from NewStartsSuspendedReason");
                Assert.AreEqual(allocation.FundingCessationDate, allocation.InflightTerminationDate,
                    "Allocation InflightTerminationDate should be populated from FundingCessationDate");
            });
        }
    }
}
